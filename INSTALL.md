# reviewers Installation Guide for Coding Agents

This document is written for coding agents. Its purpose is to install the `reviewers` skill and the matching platform-native subagent definitions into the correct local paths for Codex, Claude Code, or OpenCode.

## 1. What to Install

- Skill name: `reviewers`
- Shared skill file:
  - `/path/to/reviewers/SKILL.md`
- Platform-specific subagent sources:
  - Codex: `/path/to/reviewers/subagents/codex/`
  - Claude Code: `/path/to/reviewers/subagents/claude/`
  - OpenCode: `/path/to/reviewers/subagents/opencode/`

Install `SKILL.md` into the selected agent's skill path and install the matching subagent files into the selected agent's subagent path.

## 2. Subagent Formats and File Names

| Agent Name | Source Directory | Installed Files |
|---|---|---|
| Codex | `subagents/codex/` | `correctness_guardian.toml`, `performance_guardian.toml`, `simplicity_guardian.toml`, `spec_alignment_guardian.toml` |
| Claude Code | `subagents/claude/` | `correctness-guardian.md`, `performance-guardian.md`, `simplicity-guardian.md`, `spec-alignment-guardian.md` |
| OpenCode | `subagents/opencode/` | `correctness-guardian.md`, `performance-guardian.md`, `simplicity-guardian.md`, `spec-alignment-guardian.md` |

Do not mix formats across platforms.

## 3. Target Paths

| Agent Name | Skill Path | Subagent Path |
|---|---|---|
| Codex | `~/.codex/skills/reviewers/` | `~/.codex/agents/` |
| Claude Code | `~/.claude/skills/reviewers/` or `.claude/skills/reviewers/` | `~/.claude/agents/` or `.claude/agents/` |
| OpenCode | `~/.config/opencode/skills/reviewers/` or `.opencode/skills/reviewers/` | `~/.config/opencode/agents/` or `.opencode/agents/` |

Use project-local paths only when you intentionally want the installation scoped to one repository.

## 4. Recommended Installation Script

If you have a local checkout of this repository, prefer the bundled installer:

```bash
cd /path/to/reviewers
./install.sh codex
./install.sh claude
./install.sh opencode
```

For Claude Code and OpenCode project-local installation:

```bash
cd /path/to/reviewers
./install.sh claude --project /path/to/project
./install.sh opencode --project /path/to/project
```

## 5. Manual Installation Commands

Replace `/path/to/reviewers` with the real local path of this repository before running the commands.

### Codex

```bash
mkdir -p ~/.codex/skills/reviewers ~/.codex/agents
cp /path/to/reviewers/SKILL.md ~/.codex/skills/reviewers/SKILL.md
cp /path/to/reviewers/subagents/codex/*.toml ~/.codex/agents/
find ~/.codex/skills/reviewers -maxdepth 2 -type f | sort
find ~/.codex/agents -maxdepth 1 -type f | sort
```

### Claude Code, global install

```bash
mkdir -p ~/.claude/skills/reviewers ~/.claude/agents
cp /path/to/reviewers/SKILL.md ~/.claude/skills/reviewers/SKILL.md
cp /path/to/reviewers/subagents/claude/*.md ~/.claude/agents/
find ~/.claude/skills/reviewers -maxdepth 2 -type f | sort
find ~/.claude/agents -maxdepth 1 -type f | sort
```

### Claude Code, project-local install

```bash
mkdir -p /path/to/project/.claude/skills/reviewers /path/to/project/.claude/agents
cp /path/to/reviewers/SKILL.md /path/to/project/.claude/skills/reviewers/SKILL.md
cp /path/to/reviewers/subagents/claude/*.md /path/to/project/.claude/agents/
find /path/to/project/.claude/skills/reviewers -maxdepth 2 -type f | sort
find /path/to/project/.claude/agents -maxdepth 1 -type f | sort
```

### OpenCode, global install

```bash
mkdir -p ~/.config/opencode/skills/reviewers ~/.config/opencode/agents
cp /path/to/reviewers/SKILL.md ~/.config/opencode/skills/reviewers/SKILL.md
cp /path/to/reviewers/subagents/opencode/*.md ~/.config/opencode/agents/
find ~/.config/opencode/skills/reviewers -maxdepth 2 -type f | sort
find ~/.config/opencode/agents -maxdepth 1 -type f | sort
```

### OpenCode, project-local install

```bash
mkdir -p /path/to/project/.opencode/skills/reviewers /path/to/project/.opencode/agents
cp /path/to/reviewers/SKILL.md /path/to/project/.opencode/skills/reviewers/SKILL.md
cp /path/to/reviewers/subagents/opencode/*.md /path/to/project/.opencode/agents/
find /path/to/project/.opencode/skills/reviewers -maxdepth 2 -type f | sort
find /path/to/project/.opencode/agents -maxdepth 1 -type f | sort
```

## 6. Required Installed Layout

All installations must contain the shared skill file:

```text
<skill path>/reviewers/
└── SKILL.md
```

Codex subagent layout:

```text
<subagent path>/
├── correctness_guardian.toml
├── performance_guardian.toml
├── simplicity_guardian.toml
└── spec_alignment_guardian.toml
```

Claude Code and OpenCode subagent layout:

```text
<subagent path>/
├── correctness-guardian.md
├── performance-guardian.md
├── simplicity-guardian.md
└── spec-alignment-guardian.md
```

Do not place subagent files inside the skill directory.

## 7. Verification

After installation, verify:

- `SKILL.md` exists in the selected skill path
- the four matching subagent files exist in the selected subagent path
- the file names exactly match the source files for that platform

Example verification commands:

```bash
find ~/.codex/skills/reviewers -maxdepth 2 -type f | sort
find ~/.codex/agents -maxdepth 1 -type f | sort
```

Swap the paths for Claude Code or OpenCode as needed.

## 8. Usage Prompts

After installation, the user can invoke the skill with prompts such as:

```text
Review my local changes with the reviewers skill.
```

```text
Review my working tree and unpushed commits with the reviewers skill.
```

```text
Run a full project review with the reviewers skill.
```

## 9. Troubleshooting

### The subagents are not found

- Verify that the subagent files were copied from the correct platform directory
- Verify that only `SKILL.md` was not installed by itself
- Verify that the installed file names exactly match the source files

### The skill is not detected

- Verify that the skill was installed in the correct skill path
- Restart the agent or reload its skill list if needed
- Check for path typos

### The repository is stored in a different local path

- Replace `/path/to/reviewers` in the commands with the actual path to the downloaded repository
