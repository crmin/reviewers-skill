# reviewers

`reviewers` is a review skill that inspects local changes and unpushed commits by explicitly running specialized review subagents and consolidating consensus-based findings.

This project contains the following files:

```text
.
├── SKILL.md
└── subagents/
    ├── correctness_guardian.toml
    ├── performance_guardian.toml
    ├── simplicity_guardian.toml
    └── spec_alignment_guardian.toml
```

## Overview

- Default review scope: staged changes, unstaged changes, relevant untracked files, and local commits that have not been pushed
- Full review mode: expands to the entire codebase when the user explicitly asks for a full project review
- Required subagents:
  - `correctness_guardian`
  - `simplicity_guardian`
  - `performance_guardian`
  - `spec_alignment_guardian`
- Key behavior:
  - Collects proposals from correctness, simplicity, and performance perspectives
  - Cross-evaluates non-spec proposals
  - Separately checks implementation-to-document alignment
  - Reports review findings without modifying code

## Installation

### For Agents

Copy the block below and give it directly to the coding agent you want to use.

```text
Read https://raw.githubusercontent.com/crmin/reviewers-skill/refs/heads/main/INSTALL.md and install the reviewers skill and subagents.
```

### For Humans

For a step-by-step manual installation guide, see `https://github.com/crmin/reviewers-skill/blob/main/INSTALL_FOR_HUMAN.md`.

## Usage

After installation, ask your agent to run a review in natural language. Example prompts:

- `Review my local changes.`
- `Review this branch before I push.`
- `Review my working tree and unpushed commits.`
- `Review the entire project.`
- `Check whether the implementation and docs are out of sync.`

This skill requires both `SKILL.md` and the four subagent TOML files. Do not install only `SKILL.md`; the subagent files must also be placed in the agent-specific subagent path.

Supported installation targets:

| Agent Name | Skills Path | Subagent Path |
|---|---|---|
| Codex | `~/.codex/skills/reviewers/` | `~/.codex/agents/` |
| Claude Code | `~/.claude/skills/reviewers/` | `~/.claude/agents/` |
| OpenCode | `~/.opencode/skills/reviewers/` | `~/.opencode/agents/` |

## Notes

- This project is for collecting and presenting review findings.
- The default behavior is review only, not code modification.
- `SKILL.md` and the subagent TOML files must be installed into separate locations: the skill path and the subagent path.
