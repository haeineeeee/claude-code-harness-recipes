# /migrate — 메커니즘 간 마이그레이션

Migrate an existing automation from one mechanism to another.

## Input
$ARGUMENTS

## Instructions
1. Parse: source mechanism (hook/skill/slash) and target mechanism
2. Read the source implementation
3. Transform to target mechanism format:
   - To Hook: Create shell script in `.claude/hooks/`, add to `settings.json`
   - To Skill: Create `SKILL.md` in `.claude/skills/<name>/` with trigger keywords
   - To Slash: Create `.md` in `.claude/commands/` with `$ARGUMENTS` placeholder
4. Verify the migration preserves original behavior
5. Suggest cleanup of the old implementation
