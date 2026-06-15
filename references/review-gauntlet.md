# Review gauntlet (Stage 2)

Run the gstack plugin skills when available; otherwise apply these dimensions
inline (manual mode). Either way, the output shape is the same: per-dimension
score + "what would make it a 10" + must-fix list.

## The gauntlet (in order)
1. **office-hours** — is the problem real?
   - Demand reality, status quo, narrowest wedge, observation, future-fit.
   - Kills positioning changes that solve a non-problem.
2. **plan-ceo-review** — is the scope/ambition right?
   - Rethink premises; expand scope only when it creates a better product;
     reduce when it's bloat. Output: scope decision.
3. **plan-eng-review** — is it buildable and sound?
   - Architecture, data flow, edge cases, test/verify coverage, performance.
   - Output: locked execution plan + diagrams.
4. **plan-design-review** / **plan-devex-review** — only when UI or DX is in scope.

## Positioning-review dimensions (score 0–10 each)
For each system whose positioning is changing:
- **边界清晰度 / boundary clarity** — is "what it owns vs delegates" unambiguous?
- **接缝契约正确性 / seam contract** — are inbound/outbound adapter contracts well-defined and one-directional?
- **闭环完整性 / loop completeness** — does data flow back; is the chain end-to-end?
- **与现状冲突度 / conflict with current state** — does the change contradict the system's existing spec/code?

## Round-robin cross-review (multi-system changes)
- Each system is reviewed by an agent that does **not** own it (independence).
- The owner provides ground truth; a different agent scores.
- Collect all reviews, then look for **convergence**: when two independent
  reviewers recommend the same structural change, treat it as a strong signal and
  lock it (after a consistency check that it doesn't break the loop).

## Output
A spec proposal + a table of per-system scores, must-fix items, and any structural
revision the review surfaced. Carry blockers (e.g. a broken execution layer) into
Stage 5 as explicit "cannot claim closed until fixed" items.
