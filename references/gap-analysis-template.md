# Gap analysis template (Stage 1)

Goal: show which links of the real value chain are walked through, and which are
homeless. Ground every row in the actual repo/specs — not in project descriptions.

## Inputs to read first
- `multica project list --output json` — the source of truth for what's active and
  each system's recorded positioning.
- `project_map.md` / `PROJECT_MAP.md` — cross-project map, owners, intro relations.
- The real code/docs of each in-scope system (specs, runners, READMEs, configs).

## Value-chain × landing-status table

| 环节 (stage) | 该做什么 | 落点 (owning project) | 状态 |
|---|---|---|---|
| 采集 / ingest | … | … | ✅ / ⚠️ / ❌ |
| 组织 / structure | dedupe, lifecycle, registry | … | … |
| 编写 / produce | topic, draft | … | … |
| 计划 + 人审 / plan+review | publish plan, human gate | … | … |
| 执行 / execute | publish / outreach action | … | … |
| 跟踪 / track | lead/conversion funnel ledger | … | … |
| 分析 / analyze | attribution, iteration | … | … |
| 承接 / handle | inbound CS / conversion | … | … |

Legend: ✅ has a home · ⚠️ partial / contract missing · ❌ homeless.

## Required outputs
1. The filled table above.
2. **Homeless function list**: each ❌/⚠️ named, with a recommended owner and why.
3. **Positioning tension**: where a system's *stated* positioning conflicts with the
   role the chain needs it to play (this becomes the Stage 2 decision).
4. Evidence pointers: `file:line` or doc references for each non-obvious claim.

## Discipline
- Don't invent integrations. If a seam doesn't exist in code, mark it ❌, not ✅.
- Separate tool vs business: generic capability → tool line; vertical business →
  business line. A homeless function usually belongs to whichever side it serves.
