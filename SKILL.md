---
name: portfolio-to-issues
description: Use when asked to analyze the whole project portfolio for pipeline gaps, adjust system positioning at the project_map level, run a gstack review gauntlet (office-hours / ceo-review / eng-review) to form a spec, refine it with GSD into phased verified-specs, and break it into paired dev+verify Multica issues. The end-to-end "portfolio → positioning → review → spec → GSD phases → Multica issues" methodology. Triggers: "梳理所有项目/流程哪里没走通", "调整系统定位", "评审形成 spec", "拆成 issue 提交 multica", "portfolio review to issues".
---

# Portfolio → Issues Pipeline

A repeatable methodology that turns a fuzzy "our systems don't fully connect" into
a reviewed spec and a set of paired dev+verify Multica issues. Five stages:
**Preflight → Gap analysis → Positioning + gstack review → GSD refinement → Multica issues → Full-view closure.**

This skill encodes the *playbook, the contracts, and a dependency self-check*. It
does NOT bundle the heavy toolchains (`gstack`, `gsd`) — those are runtime plugins
each agent provisions itself (see Preflight).

## When to use
- "对全部 project 分析，看哪些环节没完全走通" / portfolio gap analysis.
- "从 project_map 层面调整系统及功能定位".
- "用 gstack 的 office-hours / ceo-review / eng-review 检视形成 spec".
- "用 gsd 细化 spec、生成 phases、拆成 issue 提交 Multica".

## Stage 0 — Preflight (run first, every time)
Self-check dependencies before doing anything. Run:

```bash
bash scripts/preflight.sh
```

It checks `multica` (required), `gstack`, and `gsd`. For each missing tool it
prints the install hint. **Degrade path, not hard stop:** if `gstack`/`gsd` are
absent and the agent's runtime cannot install plugins, continue in *manual mode* —
do the review/spec reasoning inline (apply the dimensions in
`references/review-gauntlet.md` by hand) instead of invoking the plugin skills.
Never silently skip a stage; state which mode you are in.

## Stage 1 — Portfolio gap analysis
Goal: a "value-chain stage × landing status" table that shows which links are not
yet walked through.

1. Read the authoritative positioning sources:
   - `multica project list --output json` (Multica is the source of truth for "what's active").
   - the repo/workspace `project_map.md` (or `PROJECT_MAP.md`).
2. Read the actual code/docs for the systems in scope (don't trust descriptions —
   verify against the repo: specs, runners, READMEs).
3. Produce the gap table using `references/gap-analysis-template.md`: every
   value-chain stage marked ✅ has-home / ⚠️ gap / ❌ homeless, with the owning
   project. Name the homeless functions explicitly.

Output: a grounded gap report. Do not invent integrations that don't exist.

## Stage 2 — Positioning adjustment + gstack review gauntlet
Goal: a reviewed spec.

1. Propose positioning changes at the **project_map level** (which system owns
   what; tool-vs-business separation; no cross-layer embedding).
2. Run the review gauntlet (or manual equivalent — see `references/review-gauntlet.md`):
   - `office-hours` — is the problem/wedge real?
   - `plan-ceo-review` — is the scope/ambition right?
   - `plan-eng-review` — is the architecture/data-flow sound?
   - add `plan-design-review` / `plan-devex-review` when UI/DX is in scope.
3. For multi-system changes, do **round-robin cross-review**: each system reviewed
   by an agent that does NOT own it (dev≠reviewer), scored per dimension, with
   "what would make it a 10" + must-fix list.
4. Converge into a spec. Surface any structural revision the review produced.

## Stage 3 — GSD refinement
Goal: phased, verifiable spec.

1. Use `gsd` (gsd-spec-phase / gsd-plan-phase) to clarify WHAT each phase delivers
   and refine the spec into **phases**.
2. For each phase produce a **verified-spec**: explicit acceptance criteria and the
   command/check that proves it.
3. Keep every output auditable and traceable to Stage 1/2 evidence.

## Stage 4 — Break into paired Multica issues
Goal: dev+verify issue pairs submitted to Multica, schema-complete.

Follow `references/issue-schema.md` (the pipeline contract):
- Every executable unit = one **dev** issue + one **verify** issue.
- Pin all required metadata keys; `dev_agent` ≠ `verify_agent` (hard rule).
- Serial steps: create downstream as `backlog`, promote to `todo` one at a time.
- Parallel steps: create as `todo`.
- PR linkage vs close-intent: put the issue key in PR title/body/branch to link;
  `Closes/Fixes/Resolves <KEY>` in title/body to auto-close on merge.

## Stage 5 — Full-view closure check
After all per-system reviews/revisions, run one full-view to confirm the
adjustments stayed mutually consistent and the loop closes:
1. Every hop has an adapter contract and data flows back.
2. There is a single source of truth (no second ledger/account).
3. Human-review gates can't be bypassed where required.
4. Layer boundaries have no embedded overlap.
5. Revisions don't contradict each other (no cycles, no dangling contracts).

State a verdict: closed / conditionally-closed (list blockers) / open.

## References
- `references/gap-analysis-template.md` — the value-chain gap table format.
- `references/review-gauntlet.md` — gstack review dimensions + manual fallback.
- `references/issue-schema.md` — the dev+verify pairing contract and metadata keys.

## Tuning
This skill is expected to be imperfect and tuned in real use. When a run exposes a
better step, contract field, or review dimension, update the corresponding file and
re-import with `--on-conflict overwrite`.
