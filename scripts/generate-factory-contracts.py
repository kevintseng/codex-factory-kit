#!/usr/bin/env python3

import argparse
import json
import re
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]
SKILLS_DIR = REPO_ROOT / "skills"
TEMPLATES_DIR = REPO_ROOT / "templates" / "factory"
AGENTS_PATH = REPO_ROOT / "AGENTS.md"
UPGRADE_SCRIPT = REPO_ROOT / "skills" / "factory-kit-upgrade" / "scripts" / "factory-kit-upgrade.sh"


def parse_frontmatter(markdown: str) -> dict[str, str]:
    if not markdown.startswith("---\n"):
        return {}

    parts = markdown.split("\n---\n", 1)
    if len(parts) != 2:
        return {}

    block = parts[0].splitlines()[1:]
    result: dict[str, str] = {}
    for line in block:
        if ":" not in line:
            continue
        key, value = line.split(":", 1)
        result[key.strip()] = value.strip().strip('"')
    return result


def parse_simple_yaml_interface(path: Path) -> dict[str, str]:
    result: dict[str, str] = {}
    current_section = None
    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.rstrip()
        stripped = line.strip()
        if not stripped or stripped.startswith("#"):
            continue
        if stripped.endswith(":") and not stripped.startswith("-"):
            current_section = stripped[:-1]
            continue
        if current_section != "interface" or ":" not in stripped:
            continue
        key, value = stripped.split(":", 1)
        result[key.strip()] = value.strip().strip('"')
    return result


def extract_section(markdown: str, heading: str) -> str:
    pattern = rf"(?ms)^## {re.escape(heading)}\n(.*?)(?=^## |\Z)"
    match = re.search(pattern, markdown)
    if not match:
        return ""
    return match.group(1).strip()


def extract_bullets(section_body: str) -> list[str]:
    bullets: list[str] = []
    for line in section_body.splitlines():
        stripped = line.strip()
        if stripped.startswith("- "):
            bullets.append(stripped[2:].strip())
    return bullets


def discover_skill_metadata() -> list[dict]:
    skills: list[dict] = []
    for skill_dir in sorted(SKILLS_DIR.iterdir()):
        if not skill_dir.is_dir():
            continue

        skill_doc = skill_dir / "SKILL.md"
        manifest_path = skill_dir / "agents" / "openai.yaml"
        if not skill_doc.exists() or not manifest_path.exists():
            continue

        markdown = skill_doc.read_text(encoding="utf-8")
        frontmatter = parse_frontmatter(markdown)
        manifest = parse_simple_yaml_interface(manifest_path)

        artifact_bullets: list[str] = []
        for heading in ("Artifact Paths", "Artifact Path", "Artifact Convention", "Target Layout"):
            artifact_bullets = extract_bullets(extract_section(markdown, heading))
            if artifact_bullets:
                break

        scripts = [
            str(path.relative_to(REPO_ROOT))
            for path in sorted((skill_dir / "scripts").glob("*"))
            if path.is_file() and path.stat().st_mode & 0o111
        ]

        skills.append(
            {
                "skill_name": skill_dir.name,
                "declared_name": frontmatter.get("name", skill_dir.name),
                "description": frontmatter.get("description", ""),
                "display_name": manifest.get("display_name", skill_dir.name),
                "short_description": manifest.get("short_description", ""),
                "default_prompt": manifest.get("default_prompt", ""),
                "artifact_paths": artifact_bullets,
                "scripts": scripts,
            }
        )

    return skills


def extract_agents_sections() -> list[tuple[str, str]]:
    content = AGENTS_PATH.read_text(encoding="utf-8")
    sections = []
    intro = content.split("\n## ", 1)[0].rstrip()
    sections.append(("Working Policy", intro))
    for heading in (
        "Lightweight Mode",
        "Default Loop",
        "Artifact Convention",
        "Review Policy",
        "QA Policy",
        "Documentation Policy",
        "Release Policy",
        "Open Source Boundary",
    ):
        body = extract_section(content, heading)
        if body:
            sections.append((heading, body))
    return sections


def extract_upgrade_usage() -> list[str]:
    content = UPGRADE_SCRIPT.read_text(encoding="utf-8")
    match = re.search(r"cat <<'EOF'\n(.*?)\nEOF", content, re.S)
    if not match:
        return []
    return [line.rstrip() for line in match.group(1).splitlines()]


def render_skill_index(skills: list[dict]) -> str:
    lines = [
        "# Generated Skill Index",
        "",
        "> Generated from the shipped skill surface. Reference only; do not hand-edit.",
        "",
    ]
    for skill in skills:
        lines.extend(
            [
                f"## {skill['display_name']}",
                "",
                f"- Skill name: `{skill['skill_name']}`",
                f"- Contract summary: {skill['description']}",
                f"- Manifest summary: {skill['short_description']}",
            ]
        )
        if skill["artifact_paths"]:
            lines.append("- Repo-local artifacts:")
            for artifact in skill["artifact_paths"]:
                lines.append(f"  - {artifact}")
        else:
            lines.append("- Repo-local artifacts: none declared")
        if skill["scripts"]:
            lines.append("- Executables:")
            for script in skill["scripts"]:
                lines.append(f"  - `{script}`")
        else:
            lines.append("- Executables: none")
        lines.append("")
    return "\n".join(lines).rstrip() + "\n"


def render_capability_matrix(skills: list[dict]) -> str:
    lines = [
        "# Generated Capability Matrix",
        "",
        "> Generated from the shipped skill surface. Reference only; do not hand-edit.",
        "",
        "| Skill | Contract | Repo-local artifacts | Executables |",
        "| --- | --- | --- | --- |",
    ]
    for skill in skills:
        artifacts = "<br>".join(item for item in skill["artifact_paths"]) or "None"
        scripts = "<br>".join(f"`{item}`" for item in skill["scripts"]) or "None"
        contract = skill["description"].replace("|", "\\|")
        lines.append(
            f"| `{skill['skill_name']}` | {contract} | {artifacts} | {scripts} |"
        )
    lines.append("")
    return "\n".join(lines)


def render_agents_snippet() -> str:
    lines = [
        "# Generated AGENTS Routing Snippet",
        "",
        "> Generated from the current repo-owned `AGENTS.md`. Standalone reference only; do not overwrite human-owned policy files automatically.",
        "",
    ]
    sections = extract_agents_sections()
    if sections:
        _, intro = sections[0]
        lines.append(intro)
        lines.append("")
        sections = sections[1:]

    for heading, body in sections:
        lines.append(f"## {heading}")
        lines.append(body)
        lines.append("")
    return "\n".join(lines).rstrip() + "\n"


def render_install_upgrade_reference(skills: list[dict], templates: list[str]) -> str:
    usage_lines = extract_upgrade_usage()
    lines = [
        "# Generated Install And Upgrade Reference",
        "",
        "> Generated from `install.sh`, the shipped skill surface, and `factory-kit-upgrade`. Reference only; do not hand-edit.",
        "",
        "## Install Targets",
        "",
        "- `~/.codex/skills/<skill>/` for each shipped skill",
        "- `~/.codex/templates/factory/*` for shipped templates",
        "- `~/.codex/AGENTS.factory-kit.md` for the suggested global policy",
        "- `~/.codex/factory-kit/VERSION`",
        "- `~/.codex/factory-kit/CHANGELOG.md`",
        "- `~/.codex/factory-kit/SOURCE_REPO`",
        "- `~/.codex/factory-kit/INSTALLED_SKILLS`",
        "- `~/.codex/factory-kit/INSTALLED_TEMPLATES`",
        "- `~/.codex/factory-kit/update-state.json` after `check-updates` runs",
        "",
        "## Installed Skills",
        "",
    ]
    for skill in skills:
        lines.append(f"- `{skill['skill_name']}`")
    lines.extend(["", "## Installed Templates", ""])
    for template in templates:
        lines.append(f"- `{template}`")
    lines.extend(["", "## Upgrade Commands", "", "```text"])
    lines.extend(usage_lines)
    lines.extend(
        [
            "```",
            "",
            "## Safety Contract",
            "",
            "- The installer does not overwrite `~/.codex/AGENTS.md`.",
            "- `factory-kit-upgrade upgrade` refreshes only the selected `CODEX_HOME` root.",
            "- Retired factory-kit-owned skills and templates are pruned using tracked install metadata, while unrelated user-owned items are left in place.",
            "- Human-owned repo files are not rewritten by generated references.",
            "",
        ]
    )
    return "\n".join(lines)


def build_install_manifest(skills: list[dict], templates: list[str]) -> dict:
    return {
        "schema_version": 1,
        "install_targets": {
            "skills_root": "~/.codex/skills",
            "templates_root": "~/.codex/templates/factory",
            "policy_reference": "~/.codex/AGENTS.factory-kit.md",
            "factory_metadata_root": "~/.codex/factory-kit",
        },
        "installed_metadata": [
            "VERSION",
            "CHANGELOG.md",
            "SOURCE_REPO",
            "INSTALLED_SKILLS",
            "INSTALLED_TEMPLATES",
        ],
        "runtime_state": [
            "update-state.json",
        ],
        "skills": [skill["skill_name"] for skill in skills],
        "templates": templates,
        "upgrade_commands": [
            "status",
            "check-updates",
            "upgrade",
        ],
        "generated_references": [
            "docs/generated/skill-index.md",
            "docs/generated/capability-matrix.md",
            "docs/generated/AGENTS-routing-snippet.md",
            "docs/generated/install-upgrade-reference.md",
            "docs/generated/install-manifest.json",
        ],
    }


def write_text(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate factory contract references.")
    parser.add_argument("--output-dir", default=str(REPO_ROOT / "docs" / "generated"))
    args = parser.parse_args()

    output_dir = Path(args.output_dir)
    skills = discover_skill_metadata()
    templates = [path.name for path in sorted(TEMPLATES_DIR.iterdir()) if path.is_file()]

    write_text(output_dir / "skill-index.md", render_skill_index(skills))
    write_text(output_dir / "capability-matrix.md", render_capability_matrix(skills))
    write_text(output_dir / "AGENTS-routing-snippet.md", render_agents_snippet())
    write_text(
        output_dir / "install-upgrade-reference.md",
        render_install_upgrade_reference(skills, templates),
    )
    write_text(
        output_dir / "install-manifest.json",
        json.dumps(build_install_manifest(skills, templates), indent=2, sort_keys=True)
        + "\n",
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
