# reviewers Installation Guide for Humans

This document explains how to install the `reviewers` skill manually. The key point is simple: copy `SKILL.md` into the correct skill path, and copy the matching platform-native subagent files into the correct subagent path for the agent you use.

## 1. What You Need

- The downloaded `reviewers` repository on your machine
- The shared skill file:
  - `/path/to/reviewers/SKILL.md`
- The platform-specific subagent directory for your agent:
  - Codex: `/path/to/reviewers/subagents/codex/`
  - Claude Code: `/path/to/reviewers/subagents/claude/`
  - OpenCode: `/path/to/reviewers/subagents/opencode/`

In the commands below, replace `/path/to/reviewers` with the actual location of the repository on your machine.

## 2. Quick Install Script

If you want the simplest installation path, use the script in the repository:

```bash
cd /path/to/reviewers
./install.sh codex
./install.sh claude
./install.sh opencode
```

Claude Code and OpenCode also support project-local installation:

```bash
cd /path/to/reviewers
./install.sh claude --project /path/to/project
./install.sh opencode --project /path/to/project
```

## 3. Installation Paths

Use the following paths for each supported agent:

| Agent Name | Skill Path | Subagent Path |
|---|---|---|
| Codex | `~/.codex/skills/reviewers/` | `~/.codex/agents/` |
| Claude Code | `~/.claude/skills/reviewers/` or `.claude/skills/reviewers/` | `~/.claude/agents/` or `.claude/agents/` |
| OpenCode | `~/.config/opencode/skills/reviewers/` or `.opencode/skills/reviewers/` | `~/.config/opencode/agents/` or `.opencode/agents/` |

## 4. Required Installed Layout

Every installation must contain the shared skill file:

```text
<skill path>/reviewers/
└── SKILL.md
```

Codex subagent files:

```text
<subagent path>/
├── correctness_guardian.toml
├── performance_guardian.toml
├── simplicity_guardian.toml
└── spec_alignment_guardian.toml
```

Claude Code and OpenCode subagent files:

```text
<subagent path>/
├── correctness-guardian.md
├── performance-guardian.md
├── simplicity-guardian.md
└── spec-alignment-guardian.md
```

If you copy only `SKILL.md` and skip the subagent files, the skill will not work correctly.

## 5. Install for Your Agent

### Install for Codex

```bash
mkdir -p ~/.codex/skills/reviewers ~/.codex/agents
cp /path/to/reviewers/SKILL.md ~/.codex/skills/reviewers/SKILL.md
cp /path/to/reviewers/subagents/codex/*.toml ~/.codex/agents/
find ~/.codex/skills/reviewers -maxdepth 2 -type f | sort
find ~/.codex/agents -maxdepth 1 -type f | sort
```

If the two `find` commands show `SKILL.md` and all four TOML files, installation is complete.

### Install for Claude Code, global

```bash
mkdir -p ~/.claude/skills/reviewers ~/.claude/agents
cp /path/to/reviewers/SKILL.md ~/.claude/skills/reviewers/SKILL.md
cp /path/to/reviewers/subagents/claude/*.md ~/.claude/agents/
find ~/.claude/skills/reviewers -maxdepth 2 -type f | sort
find ~/.claude/agents -maxdepth 1 -type f | sort
```

### Install for Claude Code, project-local

```bash
mkdir -p /path/to/project/.claude/skills/reviewers /path/to/project/.claude/agents
cp /path/to/reviewers/SKILL.md /path/to/project/.claude/skills/reviewers/SKILL.md
cp /path/to/reviewers/subagents/claude/*.md /path/to/project/.claude/agents/
find /path/to/project/.claude/skills/reviewers -maxdepth 2 -type f | sort
find /path/to/project/.claude/agents -maxdepth 1 -type f | sort
```

### Install for OpenCode, global

```bash
mkdir -p ~/.config/opencode/skills/reviewers ~/.config/opencode/agents
cp /path/to/reviewers/SKILL.md ~/.config/opencode/skills/reviewers/SKILL.md
cp /path/to/reviewers/subagents/opencode/*.md ~/.config/opencode/agents/
find ~/.config/opencode/skills/reviewers -maxdepth 2 -type f | sort
find ~/.config/opencode/agents -maxdepth 1 -type f | sort
```

### Install for OpenCode, project-local

```bash
mkdir -p /path/to/project/.opencode/skills/reviewers /path/to/project/.opencode/agents
cp /path/to/reviewers/SKILL.md /path/to/project/.opencode/skills/reviewers/SKILL.md
cp /path/to/reviewers/subagents/opencode/*.md /path/to/project/.opencode/agents/
find /path/to/project/.opencode/skills/reviewers -maxdepth 2 -type f | sort
find /path/to/project/.opencode/agents -maxdepth 1 -type f | sort
```

## 6. Verify the Installation

After installation, these files must exist:

- `SKILL.md` in the selected agent's skill path
- the four matching subagent files in the selected agent's subagent path

You can also verify manually:

```bash
ls -R ~/.codex/skills/reviewers
ls -R ~/.codex/agents
```

If you are using Claude Code or OpenCode, replace the paths accordingly.

## 7. How to Use It

After installation, ask your agent to use the skill with prompts such as:

```text
Review my local changes with the reviewers skill.
```

```text
Review my branch before I push.
```

```text
Run a full review of the whole project.
```

## 8. Troubleshooting

### The skill does not appear

- Confirm that `reviewers` was installed under the correct skill path
- Restart the agent if it does not reload skills automatically
- Check for path or file name typos

### The review does not work correctly

- Confirm that all four platform-matching subagent files exist in the subagent path
- Confirm that `SKILL.md` is in the skill path and not in the subagent path
- Confirm that the subagent files were not renamed

### The repository is stored somewhere else

- Replace `/path/to/reviewers` in the commands with the actual local path to the downloaded repository
