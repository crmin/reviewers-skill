# reviewers Installation Guide for Coding Agents

This document is written for coding agents. Its purpose is to install the `reviewers` skill and its required subagent definitions into the correct local paths for each supported agent.

## 1. What to Install

- Skill name: `reviewers`
- Source files:
  - `/path/to/reviewers/SKILL.md`
  - `/path/to/reviewers/subagents/correctness_guardian.toml`
  - `/path/to/reviewers/subagents/performance_guardian.toml`
  - `/path/to/reviewers/subagents/simplicity_guardian.toml`
  - `/path/to/reviewers/subagents/spec_alignment_guardian.toml`

## 2. Target Paths

Install `SKILL.md` into the skill path and install each subagent TOML file into the subagent path.

| Agent Name | Skills Path | Subagent Path |
|---|---|---|
| Codex | `~/.codex/skills/reviewers/` | `~/.codex/agents/` |
| Claude Code | `~/.claude/skills/reviewers/` | `~/.claude/agents/` |
| OpenCode | `~/.opencode/skills/reviewers/` | `~/.opencode/agents/` |

## 3. Preconditions

- A POSIX shell is available
- `mkdir`, `cp`, `ls`, and `find` are available
- The local path to the downloaded repository is known

## 4. Required Layout

The installed files must end up in this shape:

```text
<skills path>/reviewers/
└── SKILL.md

<subagent path>/
├── correctness_guardian.toml
├── performance_guardian.toml
├── simplicity_guardian.toml
└── spec_alignment_guardian.toml
```

File mapping:

| Source | Destination |
|---|---|
| `/path/to/reviewers/SKILL.md` | `<skills path>/reviewers/SKILL.md` |
| `/path/to/reviewers/subagents/correctness_guardian.toml` | `<subagent path>/correctness_guardian.toml` |
| `/path/to/reviewers/subagents/performance_guardian.toml` | `<subagent path>/performance_guardian.toml` |
| `/path/to/reviewers/subagents/simplicity_guardian.toml` | `<subagent path>/simplicity_guardian.toml` |
| `/path/to/reviewers/subagents/spec_alignment_guardian.toml` | `<subagent path>/spec_alignment_guardian.toml` |

Do not place the subagent TOML files inside the skills directory. They must be installed into the agent's subagent path.

## 5. Installation Commands

Replace `/path/to/reviewers` with the real local path of this repository before running the commands.

### Codex

```bash
mkdir -p ~/.codex/skills/reviewers ~/.codex/agents
cp /path/to/reviewers/SKILL.md ~/.codex/skills/reviewers/SKILL.md
cp /path/to/reviewers/subagents/*.toml ~/.codex/agents/
ls -R ~/.codex/skills/reviewers
ls -R ~/.codex/agents
```

### Claude Code

```bash
mkdir -p ~/.claude/skills/reviewers ~/.claude/agents
cp /path/to/reviewers/SKILL.md ~/.claude/skills/reviewers/SKILL.md
cp /path/to/reviewers/subagents/*.toml ~/.claude/agents/
ls -R ~/.claude/skills/reviewers
ls -R ~/.claude/agents
```

### OpenCode

```bash
mkdir -p ~/.opencode/skills/reviewers ~/.opencode/agents
cp /path/to/reviewers/SKILL.md ~/.opencode/skills/reviewers/SKILL.md
cp /path/to/reviewers/subagents/*.toml ~/.opencode/agents/
ls -R ~/.opencode/skills/reviewers
ls -R ~/.opencode/agents
```

## 6. Verification

After installation, the following files must exist:

- `~/.codex/skills/reviewers/SKILL.md` or the equivalent skills path for the selected agent
- `correctness_guardian.toml` in the selected agent's subagent path
- `performance_guardian.toml` in the selected agent's subagent path
- `simplicity_guardian.toml` in the selected agent's subagent path
- `spec_alignment_guardian.toml` in the selected agent's subagent path

Example verification commands:

```bash
find ~/.codex/skills/reviewers -maxdepth 2 -type f | sort
find ~/.codex/agents -maxdepth 1 -type f | sort
```

If you are installing for Claude Code or OpenCode, replace the paths accordingly.

## 7. Usage Prompts

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

## 8. Troubleshooting

### The subagents are not found

- Verify that the four TOML files were copied into the subagent path
- Verify that only `SKILL.md` was not installed by itself
- Verify that the file names exactly match the originals

### The skill is not detected

- Verify that the skill was installed in the correct skills path
- Restart the agent or reload its skill list if needed
- Check for path typos

### The repository is stored in a different local path

- Replace `/path/to/reviewers` in the commands with the actual path to the downloaded repository
