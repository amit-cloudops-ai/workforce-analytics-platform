#!/usr/bin/env python3
"""Create labels, milestones and issues in GitHub from docs/backlog.json.

Usage:
  gh auth login                                   # once
  python3 scripts/create_github_issues.py         # dry run (prints what would happen)
  python3 scripts/create_github_issues.py --apply # actually create

Idempotent: existing labels are updated, existing milestones/issues (matched by title/ID prefix) are skipped.
Requires the GitHub CLI (`gh`). Standard library only.
"""
import argparse
import json
import subprocess
import sys
from pathlib import Path

BACKLOG = Path(__file__).resolve().parent.parent / "docs" / "backlog.json"


def gh(*args, input_text=None, check=True):
    res = subprocess.run(["gh", *args], input=input_text, capture_output=True, text=True, check=False)
    if check and res.returncode != 0:
        sys.exit(f"gh {' '.join(args)} failed:\n{res.stderr}")
    return res.stdout


def issue_body(issue: dict) -> str:
    lines = [f"**Workstream:** {issue['workstream']} | **Milestone:** {issue['milestone']}", ""]
    lines += ["## Goal", issue["goal"], "", "## Allowed paths (touch nothing else)"]
    lines += [f"- `{p}`" for p in issue["paths"]]
    lines += ["", "## Acceptance criteria"]
    lines += [f"- [ ] {a}" for a in issue["acceptance"]]
    deps = ", ".join(issue["depends_on"]) or "none"
    rules = (
        "Read `AGENTS.md` first. One issue = one branch (`wfa-<number>-<slug>`) = one PR titled "
        + f"`{issue['id']}: <summary>`. Run `make verify` before and after."
    )
    lines += [
        "",
        f"## Depends on\n{deps}",
        "",
        "## Rules",
        rules,
    ]
    return "\n".join(lines)


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--repo", help="owner/name (default: from backlog.json)")
    ap.add_argument("--apply", action="store_true", help="actually create (default is dry run)")
    args = ap.parse_args()

    data = json.loads(BACKLOG.read_text())
    repo = args.repo or data["repo"]
    mode = "APPLY" if args.apply else "DRY RUN"
    print(f"[{mode}] repo={repo}, {len(data['issues'])} issues, {len(data['milestones'])} milestones")

    # Labels
    for name, color in data["labels"].items():
        print(f"label: {name}")
        if args.apply:
            gh("label", "create", name, "--color", color, "--repo", repo, "--force")

    # Milestones
    existing_ms = set()
    if args.apply:
        out = gh("api", f"repos/{repo}/milestones?state=all&per_page=100")
        existing_ms = {m["title"] for m in json.loads(out)}
    for title in data["milestones"]:
        if title in existing_ms:
            print(f"milestone exists: {title}")
            continue
        print(f"milestone: {title}")
        if args.apply:
            gh("api", f"repos/{repo}/milestones", "-f", f"title={title}")

    # Issues
    existing_issues = set()
    if args.apply:
        out = gh("issue", "list", "--repo", repo, "--state", "all", "--limit", "500", "--json", "title")
        existing_issues = {i["title"] for i in json.loads(out)}
    for issue in data["issues"]:
        title = f"{issue['id']}: {issue['title']}"
        if any(t.startswith(issue["id"] + ":") for t in existing_issues):
            print(f"issue exists: {issue['id']}")
            continue
        labels = ["task", data["workstream_labels"][issue["workstream"]]]
        print(f"issue: {title}  [{', '.join(labels)}]  -> {issue['milestone']}")
        if args.apply:
            cmd = ["issue", "create", "--repo", repo, "--title", title, "--body-file", "-",
                   "--milestone", issue["milestone"]]
            for lab in labels:
                cmd += ["--label", lab]
            gh(*cmd, input_text=issue_body(issue))

    if not args.apply:
        print("\nDry run only. Re-run with --apply to create everything.")


if __name__ == "__main__":
    main()
