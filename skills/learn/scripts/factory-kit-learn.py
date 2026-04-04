#!/usr/bin/env python3

import argparse
import json
import re
import sys
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Iterable


SLUG_RE = re.compile(r"^[a-z0-9][a-z0-9_-]*$")
CONFIDENCE_RANK = {"low": 1, "medium": 2, "high": 3}


@dataclass
class LearningStore:
    context_dir: Path

    @property
    def path(self) -> Path:
        return self.context_dir / "LEARNINGS.jsonl"

    def ensure_parent(self) -> None:
        self.context_dir.mkdir(parents=True, exist_ok=True)

    def load(self) -> list[dict]:
        if not self.path.exists():
            return []

        entries: list[dict] = []
        with self.path.open("r", encoding="utf-8") as handle:
            for lineno, raw_line in enumerate(handle, start=1):
                line = raw_line.strip()
                if not line:
                    continue
                try:
                    entry = json.loads(line)
                except json.JSONDecodeError as exc:
                    raise SystemExit(
                        f"Malformed JSONL in {self.path} at line {lineno}: {exc.msg}"
                    ) from exc
                entries.append(entry)
        return entries

    def append(self, entry: dict) -> None:
        self.ensure_parent()
        with self.path.open("a", encoding="utf-8") as handle:
            handle.write(json.dumps(entry, ensure_ascii=True, sort_keys=True))
            handle.write("\n")

    def rewrite(self, entries: Iterable[dict]) -> None:
        self.ensure_parent()
        with self.path.open("w", encoding="utf-8") as handle:
            for entry in entries:
                handle.write(json.dumps(entry, ensure_ascii=True, sort_keys=True))
                handle.write("\n")


def utc_now() -> str:
    return datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace(
        "+00:00", "Z"
    )


def validate_slug(value: str, label: str) -> str:
    if not SLUG_RE.fullmatch(value):
        raise SystemExit(
            f"{label} must be a stable slug using lowercase letters, numbers, underscores, or hyphens."
        )
    return value


def require_text(value: str, label: str) -> str:
    normalized = value.strip()
    if not normalized:
        raise SystemExit(f"{label} must not be empty.")
    return normalized


def validate_path(path_value: str, label: str) -> Path:
    path = Path(path_value)
    if not path.exists():
        raise SystemExit(f"{label} does not exist: {path}")
    return path


def build_learning_id(task_class: str, kind: str, timestamp: str) -> str:
    stem = timestamp.replace("-", "").replace(":", "").replace("T", "-").replace("Z", "")
    return f"{stem}-{task_class}-{kind}"


def normalize_tags(tags: list[str]) -> list[str]:
    unique = sorted({validate_slug(tag, "tag") for tag in tags})
    return unique


def build_entry(args: argparse.Namespace, source_type: str, source_file: str | None) -> dict:
    timestamp = utc_now()
    task_class = validate_slug(args.task_class, "task_class")
    kind = validate_slug(args.kind, "kind")
    tags = normalize_tags(args.tag or [])
    evidence = [item.strip() for item in (args.evidence or []) if item.strip()]

    entry = {
        "schema_version": 1,
        "learning_id": build_learning_id(task_class, kind, timestamp),
        "created_at": timestamp,
        "updated_at": timestamp,
        "active": True,
        "source_type": source_type,
        "source_file": source_file,
        "task_class": task_class,
        "kind": kind,
        "tags": tags,
        "summary": require_text(args.summary, "summary"),
        "guidance": require_text(args.guidance, "guidance"),
        "applies_when": require_text(args.applies_when, "applies_when"),
        "recommended_action": require_text(
            args.recommended_action, "recommended_action"
        ),
        "confidence": args.confidence,
        "evidence": evidence,
    }
    return entry


def ensure_unique_learning_id(entry: dict, entries: list[dict]) -> dict:
    existing_ids = {item.get("learning_id") for item in entries}
    if entry["learning_id"] not in existing_ids:
        return entry

    suffix = 2
    base_id = entry["learning_id"]
    while True:
        candidate = f"{base_id}-{suffix}"
        if candidate not in existing_ids:
            entry["learning_id"] = candidate
            return entry
        suffix += 1


def print_entry_brief(entry: dict) -> None:
    tags = ",".join(entry.get("tags", []))
    print(f"- learning_id={entry['learning_id']}")
    print(f"  task_class={entry['task_class']}")
    print(f"  kind={entry['kind']}")
    print(f"  confidence={entry['confidence']}")
    print(f"  tags={tags}")
    print(f"  summary={entry['summary']}")
    print(f"  guidance={entry['guidance']}")
    print(f"  recommended_action={entry['recommended_action']}")


def matches_filters(entry: dict, args: argparse.Namespace, *, active_only: bool) -> bool:
    if active_only and not entry.get("active", True):
        return False
    if args.task_class and entry.get("task_class") != args.task_class:
        return False
    if args.kind and entry.get("kind") != args.kind:
        return False
    if args.tag:
        entry_tags = set(entry.get("tags", []))
        requested = set(args.tag)
        if not requested.issubset(entry_tags):
            return False
    return True


def recommendation_score(entry: dict, args: argparse.Namespace) -> tuple[int, int, str]:
    score = 0
    if args.task_class and entry.get("task_class") == args.task_class:
        score += 100
    if args.kind and entry.get("kind") == args.kind:
        score += 20
    if args.tag:
        score += 10 * len(set(entry.get("tags", [])) & set(args.tag))
    confidence = CONFIDENCE_RANK.get(entry.get("confidence", "low"), 0)
    created_at = entry.get("created_at", "")
    return (score, confidence, created_at)


def select_recommendations(store: LearningStore, args: argparse.Namespace) -> list[dict]:
    entries = [
        entry
        for entry in store.load()
        if matches_filters(entry, args, active_only=True)
    ]
    entries.sort(key=lambda item: recommendation_score(item, args), reverse=True)
    if args.limit is not None:
        entries = entries[: args.limit]
    return entries


def replace_section(markdown: str, heading: str, body_lines: list[str]) -> str:
    pattern = rf"(?ms)^## {re.escape(heading)}\n.*?(?=^## |\Z)"
    replacement = f"## {heading}\n" + "\n".join(body_lines).rstrip() + "\n\n"

    if re.search(pattern, markdown):
        return re.sub(pattern, replacement, markdown, count=1)

    stripped = markdown.rstrip()
    if stripped:
        return stripped + "\n\n" + replacement
    return replacement


def replace_relevant_learnings_line(markdown: str, entries: list[dict]) -> str:
    if entries:
        line = f"- Relevant learnings: {len(entries)} active guidance item(s)"
    else:
        line = "- Relevant learnings: none"

    pattern = r"(?m)^- Relevant learnings:.*$"
    if re.search(pattern, markdown):
        return re.sub(pattern, line, markdown, count=1)
    return markdown


def render_relevant_learnings(entries: list[dict]) -> list[str]:
    if not entries:
        return ["- None yet."]

    lines: list[str] = []
    for entry in entries:
        lines.append(f"- [{entry['learning_id']}] {entry['summary']}")
        lines.append(f"  Applies when: {entry['applies_when']}")
        lines.append(f"  Recommended action: {entry['recommended_action']}")
        lines.append(f"  Confidence: {entry['confidence']}")
    return lines


def sync_markdown_context(path: Path, entries: list[dict]) -> None:
    if not path.exists():
        raise SystemExit(f"context file does not exist: {path}")

    original = path.read_text(encoding="utf-8")
    updated = replace_relevant_learnings_line(original, entries)
    updated = replace_section(updated, "Relevant Learnings", render_relevant_learnings(entries))
    path.write_text(updated, encoding="utf-8")


def command_capture(args: argparse.Namespace) -> int:
    store = LearningStore(Path(args.context_dir))
    source_file = None
    if args.source_file:
        source_file = str(validate_path(args.source_file, "source file"))

    entry = build_entry(args, args.source_type, source_file)
    entry = ensure_unique_learning_id(entry, store.load())
    store.append(entry)
    print(f"learning_id={entry['learning_id']}")
    print(f"learnings_path={store.path}")
    print(f"stored_at={entry['created_at']}")
    return 0


def command_promote_retro(args: argparse.Namespace) -> int:
    retro_path = args.source_file or str(Path(args.context_dir) / "RETRO.md")
    source_file = str(validate_path(retro_path, "retro source file"))
    store = LearningStore(Path(args.context_dir))
    entry = build_entry(args, "retro", source_file)
    entry = ensure_unique_learning_id(entry, store.load())
    store.append(entry)
    print(f"learning_id={entry['learning_id']}")
    print(f"learnings_path={store.path}")
    print(f"stored_at={entry['created_at']}")
    return 0


def emit_entries(entries: list[dict], output_format: str) -> None:
    if output_format == "jsonl":
        for entry in entries:
            print(json.dumps(entry, ensure_ascii=True, sort_keys=True))
        return

    print(f"matched_count={len(entries)}")
    for entry in entries:
        print_entry_brief(entry)


def command_list(args: argparse.Namespace) -> int:
    store = LearningStore(Path(args.context_dir))
    entries = [
        entry
        for entry in store.load()
        if matches_filters(entry, args, active_only=not args.all)
    ]
    if args.limit is not None:
        entries = entries[: args.limit]
    emit_entries(entries, args.format)
    return 0


def command_recommend(args: argparse.Namespace) -> int:
    if not args.task_class and not args.tag and not args.kind:
        raise SystemExit(
            "recommend requires at least one filter: --task-class, --kind, or --tag."
        )

    store = LearningStore(Path(args.context_dir))
    entries = select_recommendations(store, args)
    emit_entries(entries, args.format)
    return 0


def command_sync_context(args: argparse.Namespace) -> int:
    if not args.task_class and not args.tag and not args.kind:
        raise SystemExit(
            "sync-context requires at least one filter: --task-class, --kind, or --tag."
        )

    store = LearningStore(Path(args.context_dir))
    entries = select_recommendations(store, args)
    context_dir = Path(args.context_dir)
    plan_path = Path(args.plan_path) if args.plan_path else context_dir / "PLAN.md"
    sync_markdown_context(plan_path, entries)

    if not args.skip_testplan:
        testplan_path = (
            Path(args.testplan_path) if args.testplan_path else context_dir / "TESTPLAN.md"
        )
        sync_markdown_context(testplan_path, entries)

    print(f"matched_count={len(entries)}")
    print(f"plan_path={plan_path}")
    if args.skip_testplan:
        print("testplan_path=skipped")
    else:
        print(f"testplan_path={testplan_path}")
    return 0


def command_deactivate(args: argparse.Namespace) -> int:
    store = LearningStore(Path(args.context_dir))
    entries = store.load()
    found = False
    timestamp = utc_now()

    for entry in entries:
        if entry.get("learning_id") != args.learning_id:
            continue
        found = True
        entry["active"] = False
        entry["updated_at"] = timestamp
        entry["deactivated_at"] = timestamp

    if not found:
        raise SystemExit(f"Learning not found: {args.learning_id}")

    store.rewrite(entries)
    print(f"learning_id={args.learning_id}")
    print("active=false")
    print(f"learnings_path={store.path}")
    return 0


def add_common_learning_fields(parser: argparse.ArgumentParser) -> None:
    parser.add_argument("--task-class", required=True)
    parser.add_argument("--kind", required=True)
    parser.add_argument("--summary", required=True)
    parser.add_argument("--guidance", required=True)
    parser.add_argument("--applies-when", required=True)
    parser.add_argument("--recommended-action", required=True)
    parser.add_argument("--tag", action="append", default=[])
    parser.add_argument("--evidence", action="append", default=[])
    parser.add_argument("--confidence", choices=["low", "medium", "high"], default="medium")


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Manage durable repo-local learnings for Codex Factory Kit."
    )
    parser.add_argument("--context-dir", default=".codex/context")
    subparsers = parser.add_subparsers(dest="command", required=True)

    capture = subparsers.add_parser("capture", help="Append a reusable learning entry.")
    add_common_learning_fields(capture)
    capture.add_argument(
        "--source-type",
        choices=["manual", "retro", "review", "qa", "release", "incident"],
        default="manual",
    )
    capture.add_argument("--source-file")
    capture.set_defaults(func=command_capture)

    promote = subparsers.add_parser(
        "promote-retro", help="Promote a reusable learning from RETRO.md."
    )
    add_common_learning_fields(promote)
    promote.add_argument("--source-file")
    promote.set_defaults(func=command_promote_retro)

    list_parser = subparsers.add_parser("list", help="List stored learnings.")
    list_parser.add_argument("--task-class")
    list_parser.add_argument("--kind")
    list_parser.add_argument("--tag", action="append", default=[])
    list_parser.add_argument("--all", action="store_true")
    list_parser.add_argument("--limit", type=int)
    list_parser.add_argument("--format", choices=["brief", "jsonl"], default="brief")
    list_parser.set_defaults(func=command_list)

    recommend = subparsers.add_parser(
        "recommend", help="Show active learnings relevant to the current task."
    )
    recommend.add_argument("--task-class")
    recommend.add_argument("--kind")
    recommend.add_argument("--tag", action="append", default=[])
    recommend.add_argument("--limit", type=int, default=5)
    recommend.add_argument("--format", choices=["brief", "jsonl"], default="brief")
    recommend.set_defaults(func=command_recommend)

    sync_context = subparsers.add_parser(
        "sync-context",
        help="Write relevant learnings into PLAN.md and TESTPLAN.md.",
    )
    sync_context.add_argument("--task-class")
    sync_context.add_argument("--kind")
    sync_context.add_argument("--tag", action="append", default=[])
    sync_context.add_argument("--limit", type=int, default=5)
    sync_context.add_argument("--plan-path")
    sync_context.add_argument("--testplan-path")
    sync_context.add_argument("--skip-testplan", action="store_true")
    sync_context.set_defaults(func=command_sync_context)

    deactivate = subparsers.add_parser(
        "deactivate", help="Deactivate a stale learning without deleting history."
    )
    deactivate.add_argument("--learning-id", required=True)
    deactivate.set_defaults(func=command_deactivate)

    return parser


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()
    return args.func(args)


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except BrokenPipeError:
        raise SystemExit(1)
