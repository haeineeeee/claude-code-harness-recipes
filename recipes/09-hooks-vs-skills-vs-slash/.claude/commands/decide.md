# /decide — 자동화 메커니즘 결정

Analyze the following automation requirement and recommend the best mechanism.

## Input
$ARGUMENTS

## Instructions
1. Parse the requirement description
2. Apply the decision matrix from the decision-helper skill
3. If the requirement involves a tool lifecycle event (pre/post), recommend **Hook**
4. If it requires domain knowledge or multi-step reasoning, recommend **Skill**
5. If it is a simple repeated action, recommend **Slash Command**
6. Output: mechanism name, rationale, and implementation skeleton
