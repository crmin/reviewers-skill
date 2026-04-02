# reviewers

`reviewers` is a review skill that inspects local changes and unpushed commits by explicitly running specialized review subagents and consolidating consensus-based findings.

This project contains the following files:

```text
.
├── install.sh
├── SKILL.md
├── INSTALL.md
├── INSTALL_FOR_HUMAN.md
└── subagents/
    ├── claude/
    │   ├── correctness-guardian.md
    │   ├── performance-guardian.md
    │   ├── simplicity-guardian.md
    │   └── spec-alignment-guardian.md
    ├── codex/
    │   ├── correctness_guardian.toml
    │   ├── performance_guardian.toml
    │   ├── simplicity_guardian.toml
    │   └── spec_alignment_guardian.toml
    └── opencode/
        ├── correctness-guardian.md
        ├── performance-guardian.md
        ├── simplicity-guardian.md
        └── spec-alignment-guardian.md
```

## Overview

- Default review scope: staged changes, unstaged changes, relevant untracked files, and local commits that have not been pushed
- Full review mode: expands to the entire codebase when the user explicitly asks for a full project review
- Key behavior:
  - Collects proposals from correctness, simplicity, and performance perspectives
  - Cross-evaluates non-spec proposals
  - Separately checks implementation-to-document alignment
  - Reports review findings without modifying code

### Required Subagents

The review flow always runs the following subagents. The nickname is the short label users are most likely to see in review output.

| Review Role | Codex | Claude Code | OpenCode | Nickname | Primary Purpose |
|---|---|---|---|---|---|
| Correctness reviewer | `correctness_guardian` | `correctness-guardian` | `correctness-guardian` | `Sentinel` | Finds bugs, edge cases, unsafe assumptions, and reliability risks |
| Simplicity reviewer | `simplicity_guardian` | `simplicity-guardian` | `simplicity-guardian` | `Scribe` | Flags unnecessary complexity, readability issues, duplicated logic, dead code, and maintainability costs |
| Performance reviewer | `performance_guardian` | `performance-guardian` | `performance-guardian` | `Turbo` | Looks for inefficiencies, scalability risks, and unnecessary runtime cost |
| Specification reviewer | `spec_alignment_guardian` | `spec-alignment-guardian` | `spec-alignment-guardian` | `Arbiter` | Detects mismatches between implementation and file-managed specifications or instructions |

## Installation

### For Agents

Copy the block below and give it directly to the coding agent you want to use.

```text
Read https://raw.githubusercontent.com/crmin/reviewers-skill/refs/heads/main/INSTALL.md and install the reviewers skill and subagents.
```

### For Humans

For a step-by-step manual installation guide, see `https://github.com/crmin/reviewers-skill/blob/main/INSTALL_FOR_HUMAN.md`.

### Quick Install Script

Use the repository script when you want a direct local installation:

```bash
./install.sh codex
./install.sh claude
./install.sh opencode
```

Claude Code and OpenCode also support project-local installation:

```bash
./install.sh claude --project /path/to/project
./install.sh opencode --project /path/to/project
```

## Usage

After installation, ask your agent to run a review in natural language. Example prompts:

- `Review my local changes.`
- `Review this branch before I push.`
- `Review my working tree and unpushed commits.`
- `Review the entire project.`
- `Check whether the implementation and docs are out of sync.`

This skill requires both `SKILL.md` and the four matching platform-native subagent files. Do not install only `SKILL.md`; the subagent files must also be placed in the agent-specific subagent path.

Supported installation targets:

| Agent Name | Skill Path | Subagent Path | Source Directory |
|---|---|---|---|
| Codex | `~/.codex/skills/reviewers/` | `~/.codex/agents/` | `subagents/codex/` |
| Claude Code | `~/.claude/skills/reviewers/` or `.claude/skills/reviewers/` | `~/.claude/agents/` or `.claude/agents/` | `subagents/claude/` |
| OpenCode | `~/.config/opencode/skills/reviewers/` or `.opencode/skills/reviewers/` | `~/.config/opencode/agents/` or `.opencode/agents/` | `subagents/opencode/` |

## Notes

- This project is for collecting and presenting review findings.
- The default behavior is review only, not code modification.
- `SKILL.md` and the subagent files must be installed into separate locations: the skill path and the subagent path.
- Codex uses TOML subagents. Claude Code and OpenCode use Markdown files with YAML frontmatter.
