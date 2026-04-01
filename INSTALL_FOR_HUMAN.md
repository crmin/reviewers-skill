# reviewers Installation Guide for Humans

This document explains how to install the `reviewers` skill manually. The key point is simple: copy `SKILL.md` into the correct skills path, and copy the four subagent TOML files into the correct subagent path for the agent you use.

## 1. What You Need

- The downloaded `reviewers` repository on your machine
- These source files from the repository:
  - `/path/to/reviewers/SKILL.md`
  - `/path/to/reviewers/subagents/correctness_guardian.toml`
  - `/path/to/reviewers/subagents/performance_guardian.toml`
  - `/path/to/reviewers/subagents/simplicity_guardian.toml`
  - `/path/to/reviewers/subagents/spec_alignment_guardian.toml`

In the commands below, replace `/path/to/reviewers` with the actual location of the repository on your machine.

## 2. Installation Paths

Use the following paths for each supported agent:

| Agent Name | Skills Path | Subagent Path |
|---|---|---|
| Codex | `~/.codex/skills/reviewers/` | `~/.codex/agents/` |
| Claude Code | `~/.claude/skills/reviewers/` | `~/.claude/agents/` |
| OpenCode | `~/.opencode/skills/reviewers/` | `~/.opencode/agents/` |

## 3. Required Installed Layout

After installation, the files should look like this:

```text
<skills path>/reviewers/
└── SKILL.md

<subagent path>/
├── correctness_guardian.toml
├── performance_guardian.toml
├── simplicity_guardian.toml
└── spec_alignment_guardian.toml
```

If you copy only `SKILL.md` and skip the subagent TOML files, the skill will not work correctly.

## 4. Install for Your Agent

### Install for Codex

```bash
mkdir -p ~/.codex/skills/reviewers ~/.codex/agents
cp /path/to/reviewers/SKILL.md ~/.codex/skills/reviewers/SKILL.md
cp /path/to/reviewers/subagents/*.toml ~/.codex/agents/
find ~/.codex/skills/reviewers -maxdepth 2 -type f | sort
find ~/.codex/agents -maxdepth 1 -type f | sort
```

If the two `find` commands show `SKILL.md` and all four TOML files, installation is complete.

### Install for Claude Code

```bash
mkdir -p ~/.claude/skills/reviewers ~/.claude/agents
cp /path/to/reviewers/SKILL.md ~/.claude/skills/reviewers/SKILL.md
cp /path/to/reviewers/subagents/*.toml ~/.claude/agents/
find ~/.claude/skills/reviewers -maxdepth 2 -type f | sort
find ~/.claude/agents -maxdepth 1 -type f | sort
```

### Install for OpenCode

```bash
mkdir -p ~/.opencode/skills/reviewers ~/.opencode/agents
cp /path/to/reviewers/SKILL.md ~/.opencode/skills/reviewers/SKILL.md
cp /path/to/reviewers/subagents/*.toml ~/.opencode/agents/
find ~/.opencode/skills/reviewers -maxdepth 2 -type f | sort
find ~/.opencode/agents -maxdepth 1 -type f | sort
```

## 5. Verify the Installation

After installation, these files must exist:

- `SKILL.md` in the selected agent's skills path
- `correctness_guardian.toml` in the selected agent's subagent path
- `performance_guardian.toml` in the selected agent's subagent path
- `simplicity_guardian.toml` in the selected agent's subagent path
- `spec_alignment_guardian.toml` in the selected agent's subagent path

You can also verify manually:

```bash
ls -R ~/.codex/skills/reviewers
ls -R ~/.codex/agents
```

If you are using Claude Code or OpenCode, replace the paths accordingly.

## 6. How to Use It

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

## 7. Troubleshooting

### The skill does not appear

- Confirm that `reviewers` was installed under the correct skills path
- Restart the agent if it does not reload skills automatically
- Check for path or file name typos

### The review does not work correctly

- Confirm that all four TOML files exist in the subagent path
- Confirm that `SKILL.md` is in the skills path and not in the subagent path
- Confirm that the TOML files were not renamed

### The repository is stored somewhere else

- Replace `/path/to/reviewers` in the commands with the actual local path to the downloaded repository
