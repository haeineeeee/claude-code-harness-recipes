# Decision Helper — Hooks vs Skills vs Slash

## Trigger
When the user says "어떤 메커니즘", "hook or skill", "뭘 써야", "자동화 방법 추천", or "decide mechanism".

## Purpose
Analyze a given automation requirement and recommend whether it should be implemented as a Hook, Skill, or Slash Command.

## Decision Matrix

| Criterion | Hook | Skill (SKILL.md) | Slash Command |
|---|---|---|---|
| Trigger | Tool lifecycle event | Keyword in conversation | Explicit /command |
| Visibility | Invisible (background) | Loaded when triggered | User invokes manually |
| Scope | Guard / Log / Transform | Domain knowledge + workflow | Quick action shortcut |
| Complexity | Single shell script | Multi-step with context | Template prompt |
| Persistence | Every matching tool call | On-demand per session | On-demand per invocation |

## Procedure

1. Ask: "Is this triggered by a tool call event?" -> Hook
2. Ask: "Does this need domain knowledge or multi-step reasoning?" -> Skill
3. Ask: "Is this a simple, frequently repeated command?" -> Slash Command
4. If unclear, check the tool usage log at `.claude/logs/tool-usage-stats.jsonl`
5. Present recommendation with rationale in a comparison table

## Output Format
Always respond with:
- **Recommendation**: Hook / Skill / Slash
- **Rationale**: 2-3 sentences
- **Implementation skeleton**: File path + minimal code
