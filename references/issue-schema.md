# Multica issue contract (Stage 4)

Every executable unit = a pair: one **dev** issue + one **verify** issue. This is
the pipeline's single naming + schema + gate convention. On conflict, the
workspace's authoritative pipeline-spec issue wins (link it via `status_contract`).

## Naming (one convention only)
- dev title:    `[<work_id>] dev: <module summary>`
- verify title: `[<work_id>] verify: <module summary>`
- `work_id` is globally unique, e.g. `SMS-T03`, `IC-D4`, `CONV-P1`.

## Required metadata (pin on BOTH dev and verify)
| key | meaning |
|---|---|
| work_id | globally unique unit id |
| dev_issue | dev issue key (hard link) |
| verify_issue | verify issue key (hard link) |
| repo_url | code repository |
| branch_name | dev branch |
| target_path | code subpath |
| acceptance_cmd | acceptance command (the gate) |
| pr_url | PR link |
| dev_agent | dev agent (MUST ≠ verify_agent) |
| verify_agent | verify agent (MUST ≠ dev_agent) |
| status_contract | key of the authoritative pipeline-spec issue |
| rework_policy | default `verify_blocked->dev_todo` |

dev↔verify are linked by **metadata only**, never by title matching.

```bash
multica issue create --title "[CONV-P1] dev: conversion-ledger spec" \
  --project <project-id> --assignee <dev-agent> --status todo
multica issue metadata set <issue-id> --key work_id --value CONV-P1
# ...pin all 12 keys on both dev and verify
```

## Gates (enforced by the pipeline manager)
1. dev without `verify_issue` → not allowed into todo/in_progress (set blocked).
2. dev without `acceptance_cmd` → not allowed to start.
3. dev done but no `pr_url` → cannot enter in_review.
4. verify with no evidence of running `acceptance_cmd` in comments → cannot be done.
5. PR not merged → dev cannot be done.
6. verify = blocked → auto-rework: flip the paired `dev_issue` back to todo.
7. Parent epic status is **derived from children only** — never closed subjectively.

## Hard rule: dev_agent ≠ verify_agent
The author of a unit must not verify it. If the natural verifier is also the dev,
route verification to a neutral third agent.

## Serial vs parallel
- Serial: create downstream steps as `backlog`; promote to `todo` one at a time
  once the prerequisite is **truly** done (per the child's own dependency, which
  may be "PR merged", not just "verify passed").
- Parallel: create as `todo` (fires the assignee immediately).

## PR linkage vs close intent (two separate scans)
- **Link**: issue key (`PREFIX-NUMBER`) anywhere in PR title, body, OR branch.
- **Close intent**: `Closes`/`Fixes`/`Resolves <KEY>` in title or body only (not
  branch). Only this auto-advances the issue to done on merge.
- Read real PR state via `multica issue pull-requests <issue-id> --output json`
  (`state` enum: merged/closed/draft/open), not from `pr_url` metadata.

## Done
`done` = code merged AND verification closed. "Agent says it's done" ≠ done.
Agents do not self-merge: merge needs verify-pass + CI + linkage + human/manager
policy.
