---
name: reviewers
description: Review local unpushed code changes by explicitly spawning specialized reviewer subagents, collecting their proposals, cross-evaluating them, and reporting consensus-approved findings with additional specification-alignment comments.
---

# Reviewers

Review local code changes that have not been pushed yet.

By default, this skill reviews:
- staged changes
- unstaged changes
- relevant untracked files
- local commits not pushed to remote

If the user explicitly asks for a full code review, expand the scope to the entire project codebase instead of limiting the review to changed files.

This skill does not modify code.
This skill does not generate patches.
This skill only decides which review findings are worth presenting to the user.

“Approval” in this skill means:
- the review finding should be shown to the user

“Approval” does not mean:
- the code must be changed
- the skill should edit code
- a reviewer opinion overrides user instructions

The final choice always belongs to the user.

## When to use

Use this skill when:
- the user asks for review of local changes
- the user wants pre-commit or pre-push review
- the user wants consensus-based review across multiple engineering values
- the user wants review of code that includes uncommitted changes
- the user wants an overall review of the whole project

Do not use this skill for:
- lint-only checks
- syntax-only checks
- automatic refactoring
- code generation

## Review scope rules

### Default scope
Review only local unpushed changes.

### Full project override
If the user explicitly requests a review of the entire codebase or whole project:
- expand the working scope to the full project code
- do not limit analysis to changed files
- use changed files only as possible entry points when useful

### Specification sources
When available, include repository-managed instruction and specification files such as:
- SPEC.md
- AGENTS.md
- README.md
- design docs
- protocol or contract docs
- other files that define intended behavior or constraints

## Skill stance

This skill is not obsessed with one value.

This skill evaluates findings with balanced engineering judgment and shared baseline values:
- obvious correctness
- basic security
- practical maintainability
- reasonable performance awareness
- respect for explicit project instructions
- user intent

This skill should not blindly follow any one subagent’s bias.

## Required subagents

This skill must explicitly spawn all of the following review roles using the platform-native subagent identifiers.

| Review role | Codex identifier | Claude Code identifier | OpenCode identifier | Nickname |
|---|---|---|---|---|
| Correctness reviewer | `correctness_guardian` | `correctness-guardian` | `correctness-guardian` | `Sentinel` |
| Simplicity reviewer | `simplicity_guardian` | `simplicity-guardian` | `simplicity-guardian` | `Scribe` |
| Performance reviewer | `performance_guardian` | `performance-guardian` | `performance-guardian` | `Turbo` |
| Specification reviewer | `spec_alignment_guardian` | `spec-alignment-guardian` | `spec-alignment-guardian` | `Arbiter` |

Use the identifier that matches the current runtime.

Important:
- subagents run only when they are explicitly spawned by their exact configured identifier
- do not refer to them indirectly
- do not skip any required subagent
- do not merge their responsibilities into one generic review call

## Phase 1 - Spawn subagents to review and raise proposals

Explicitly spawn each required review role by its current-platform identifier.

Each subagent receives the same review context:
- all local unpushed code changes, or full project code if full review was explicitly requested
- changed file list
- relevant nearby code context when needed
- repository instruction and specification documents when available

Ask each subagent to:
- review using its own priority lens
- raise one or more review proposals if needed
- include suggested direction for each proposal
- include metadata that explicitly records the proposing subagent name

Each proposal must include:
- title
- summary
- rationale
- suggested direction
- severity estimate
- affected files or scope if known
- metadata.proposed_by

The metadata field must contain the exact subagent name that raised the proposal.

Example values:
- Codex: `metadata.proposed_by: correctness_guardian`
- Codex: `metadata.proposed_by: simplicity_guardian`
- Codex: `metadata.proposed_by: performance_guardian`
- Codex: `metadata.proposed_by: spec_alignment_guardian`
- Claude Code or OpenCode: `metadata.proposed_by: correctness-guardian`
- Claude Code or OpenCode: `metadata.proposed_by: simplicity-guardian`
- Claude Code or OpenCode: `metadata.proposed_by: performance-guardian`
- Claude Code or OpenCode: `metadata.proposed_by: spec-alignment-guardian`

A subagent may raise multiple proposals.

## Special rule for specification reviewer proposals

Any review proposal raised by the specification reviewer:
- must not be evaluated by other subagents
- is always considered approved for reporting
- should normally be framed as a request to inspect and update stale or mismatched specification documents, unless the context clearly indicates that the implementation should instead be brought back into alignment with the documented behavior

These proposals bypass consensus voting.

## Phase 2 - Cross-evaluate proposals from non-spec subagents

After collecting all proposals, iterate through them one by one.

For each proposal raised by the correctness reviewer, simplicity reviewer, or performance reviewer:

do the following:

1. Read `metadata.proposed_by`
2. Treat the proposing subagent as already having approved the proposal
3. Explicitly spawn the other two non-spec reviewer subagents by their current-platform identifiers
4. Ask each of those two subagents to evaluate the proposal and return:
   - approve
   - reject
5. Require a reason for reject

This produces the consensus vote.

The proposing subagent must not re-evaluate its own proposal.

## Phase 3 - Specification-alignment advisory evaluation

For every proposal not raised by the specification reviewer, explicitly spawn the specification reviewer by its current-platform identifier and ask it to evaluate whether the proposal conflicts with file-managed specifications or instructions.

The result from the specification reviewer in this phase:
- does not change the vote count
- does not participate in consensus
- does not block approval by itself
- must be included in final reporting as an advisory opinion when relevant

This evaluation should return:
- approve or reject
- a reason, especially when rejecting
- the relevant document or instruction source when possible

Interpretation:
- `approve` means the proposal does not conflict with the known specification or instruction set, or is compatible with it
- `reject` means the proposal appears to conflict with explicit repository-managed specification or instructions and needs user review

## Consensus rules

Each proposal from the correctness reviewer, simplicity reviewer, or performance reviewer starts with one implicit approval from its proposer.

### 1 of 3
Ignore the proposal.

This means:
- only the proposer approved it
- both other voting subagents rejected it

Do not present it as an approved finding.

### 2 of 3
Use this skill’s balanced judgment to decide whether to approve it for reporting.

This decision must consider:
- whether the proposal is reasonable
- whether it is acceptable in the current code and product context
- whether the change cost is proportional
- whether the rejection reason reveals an important counterargument
- whether the proposal is too biased toward one subagent’s preference
- whether it still makes sense under the project’s stated constraints

The single rejection reason must be used in this decision.
Do not ignore it.

### 3 of 3
Approve the proposal automatically for reporting.

No additional balancing judgment is required.

## Instruction and spec conflict handling

There are two different kinds of spec-related handling in this skill.

### 1. Direct stale-spec findings
If the specification reviewer raises its own proposal about stale or mismatched documentation:
- always approve it for reporting
- do not send it through voting
- present it as a documentation or specification alignment finding

### 2. Advisory comments on other approved findings
If the specification reviewer rejects another subagent’s proposal during advisory evaluation:
- do not change the vote count
- do not automatically discard the proposal
- attach the advisory opinion to the final result shown to the user

Example framing:
- “This review finding appears to conflict with the documented specification and should be checked against SPEC.md before acting on it.”
- “This suggestion may not align with the current AGENTS.md guidance and requires user review.”

The final choice remains with the user.

## Proposal normalization

Before final reporting, merge proposals only when they are meaningfully the same.

Merge proposals when they share:
- the same underlying issue
- the same practical impact
- the same suggested direction

Do not merge proposals when:
- they argue from different root causes
- they require different actions
- they create different trade-offs
- they only look similar on the surface

If merged, preserve:
- all agreeing voting subagents
- all rejecting voting subagents
- all useful rejection reasons
- any advisory opinion from the specification reviewer

Do not merge a direct stale-spec proposal into a normal code-review proposal unless they are truly the same issue.

## Output format

Return results in the user's preferred language.

All user-facing labels, section titles, review titles, explanations, and the final follow-up instruction must use the user's preferred language.

Return results in this structure.

### Summary
Include:
- total proposals raised
- how many direct stale-spec proposals were raised
- how many proposals were ignored
- how many proposals were approved for reporting
- whether any approved findings have specification-alignment concerns
- the most important takeaways for the user

### Approved findings
For each approved finding, include:
- review number and title
- proposer
- result
- changed file and location
- issue details
- improvement suggestion
- what the user should consider before changing code

If there is a relevant advisory comment from the specification reviewer, append it clearly as an opinion note.

Use the following field rules for every approved finding:
- `review number and title`: a short, concrete title that explains the problem situation clearly, such as `#1: Performance degradation due to nested loops`; the title must use the user's preferred language
- `proposer`: show the subagent nickname
- `result`: show the vote count or approval status, such as `2/3`, `3/3`, or `spec`
- `changed file and location`: identify the file and line clearly, and render it in a clickable format supported by the current client; when the client supports markdown file links, prefer absolute paths with line numbers
- `issue details`: explain the problem, its cause, and its impact in enough detail for the user to judge whether it matters
- `improvement suggestion`: give a concrete fix direction; include a short code snippet when that would make the recommendation materially clearer

When clickable file references are supported, prefer a format like:
- `[src/filename.ts](/absolute/path/src/filename.ts#L315)`

### Specification alignment findings
List direct findings raised by the specification reviewer, especially when they indicate stale documents, mismatched specs, outdated contracts, or misleading instructions.

For each item, include:
- title
- mismatched files or documents
- what appears out of sync
- suggested direction
- why the user should review it

### Specification advisory notes
For approved findings raised by other subagents, include any relevant advisory opinion from the specification reviewer.

This section should clearly state:
- the proposal title
- whether the specification reviewer approved or rejected it
- the reason
- the related document or instruction source when known

### Rejected or ignored notes
Keep this section brief.
Only include items that may still be useful as low-confidence reference.

### Final follow-up instruction
After presenting the review results, always append a short follow-up instruction in the user's preferred language.

Include this exact meaning:
- to apply all review feedback, the user can enter `수정`
- to apply only part of the review feedback, the user can enter one or more review numbers

For Korean users, render it exactly as:
- `리뷰를 반영해서 수정을 하려면 "수정"을 입력해주세요. 또는 리뷰 번호를 포함해서 일부 리뷰만 반영 할 수 있습니다.`

## Guardrails

- Always explicitly spawn all four review roles by their current-platform identifiers in phase 1
- Always explicitly spawn the two non-proposing voting subagents by their current-platform identifiers for non-spec proposals
- Always explicitly spawn the specification reviewer for advisory evaluation of non-spec proposals
- Never assume a subagent ran unless it was explicitly spawned
- Never let a proposal evaluate itself twice
- Never let the specification reviewer affect the vote count for another subagent's proposal
- Never send a specification reviewer proposal through normal voting
- Never treat approval as permission to edit code
- Never hide specification conflicts or advisory cautions
- Never overrule the user's stated constraints
- Never invent mismatches or stale documents
- Never present review titles or the final follow-up instruction in a language that differs from the user's preferred language
- Prefer concrete, user-actionable findings over broad theory

## Success criteria

This skill is successful when:
- all four named subagents are explicitly spawned during proposal generation
- every proposal records the proposing subagent in metadata
- proposals from the correctness reviewer, simplicity reviewer, and performance reviewer are evaluated by the other two voting subagents
- proposals from the specification reviewer are always approved and never voted on
- the specification reviewer evaluates other proposals only as an advisory specification-alignment check
- advisory specification comments are surfaced to the user without changing vote totals
- approved findings are reported without editing code
- the user retains final decision authority
