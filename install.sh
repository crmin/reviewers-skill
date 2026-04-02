#!/usr/bin/env bash

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SKILL_NAME="reviewers"
readonly SKILL_SOURCE="${SCRIPT_DIR}/SKILL.md"

usage() {
  cat <<'EOF'
Usage:
  ./install.sh codex
  ./install.sh claude [--project /path/to/project]
  ./install.sh opencode [--project /path/to/project]

Installs the reviewers skill and the matching platform-native subagents.
If --project is omitted, installation uses the global user-level paths.
EOF
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

agent="$1"
shift

project_root=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)
      if [[ $# -lt 2 ]]; then
        echo "Missing path after --project" >&2
        exit 1
      fi
      project_root="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ -n "${project_root}" ]]; then
  project_root="$(cd "${project_root}" && pwd)"
fi

case "${agent}" in
  codex)
    if [[ -n "${project_root}" ]]; then
      echo "Codex installation supports only global paths." >&2
      exit 1
    fi
    skill_target="${HOME}/.codex/skills/${SKILL_NAME}"
    subagent_target="${HOME}/.codex/agents"
    subagent_source="${SCRIPT_DIR}/subagents/codex"
    ;;
  claude)
    if [[ -n "${project_root}" ]]; then
      skill_target="${project_root}/.claude/skills/${SKILL_NAME}"
      subagent_target="${project_root}/.claude/agents"
    else
      skill_target="${HOME}/.claude/skills/${SKILL_NAME}"
      subagent_target="${HOME}/.claude/agents"
    fi
    subagent_source="${SCRIPT_DIR}/subagents/claude"
    ;;
  opencode)
    if [[ -n "${project_root}" ]]; then
      skill_target="${project_root}/.opencode/skills/${SKILL_NAME}"
      subagent_target="${project_root}/.opencode/agents"
    else
      skill_target="${HOME}/.config/opencode/skills/${SKILL_NAME}"
      subagent_target="${HOME}/.config/opencode/agents"
    fi
    subagent_source="${SCRIPT_DIR}/subagents/opencode"
    ;;
  *)
    echo "Unsupported agent: ${agent}" >&2
    usage
    exit 1
    ;;
esac

mkdir -p "${skill_target}" "${subagent_target}"
cp "${SKILL_SOURCE}" "${skill_target}/SKILL.md"
cp "${subagent_source}"/* "${subagent_target}/"

echo "Installed ${SKILL_NAME} for ${agent}"
echo "Skill path: ${skill_target}/SKILL.md"
echo "Subagent path: ${subagent_target}"
find "${skill_target}" -maxdepth 2 -type f | sort
find "${subagent_target}" -maxdepth 1 -type f | sort
