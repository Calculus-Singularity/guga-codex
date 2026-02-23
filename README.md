# gugugaga

**The supervision layer that keeps Codex sessions safer, sharper, and consistent under real project pressure.**

Built on top of [Calculus-Singularity/codex](https://github.com/Calculus-Singularity/codex) · Rust · TUI

---

gugugaga is a supervision-first Codex project.
It does not try to replace Codex generation ability. Instead, it adds a second control loop around each turn so behavior, quality, and execution discipline remain stable across long sessions.

When coding conversations get long, fast output alone is not enough. gugugaga focuses on making sessions reviewable, steerable, and resilient: less silent drift, fewer avoidable regressions, and clearer correction signals when model behavior deviates from user intent.

## What This Project Emphasizes

- Continuous supervision on top of normal Codex turn flow.
- Persistent notebook memory for supervisory context across turns.
- Correction/caution mechanisms that can be surfaced in UI and fed back into the next turn.
- Practical alignment work so Gugugaga behavior remains close to Codex baseline where appropriate.

## What Gugugaga Checks

gugugaga focuses on supervision signals that matter in real coding sessions:

- Instruction adherence: whether Codex actually follows explicit user constraints, priorities, and format requirements.
- Scope control: whether the turn stays within the requested task instead of drifting into unrelated work.
- Tool-use correctness: whether tool calls are necessary, correctly formed, and semantically aligned with the user intent.
- Completion integrity: whether the agent claims completion too early, skips required verification, or leaves critical steps unhandled.
- Change safety: whether edits introduce avoidable risk (destructive operations, unsafe assumptions, missing guardrails).
- Regression risk: whether modifications likely break existing behavior without acknowledgement or validation.
- Evidence quality: whether conclusions are backed by concrete outputs, diffs, test results, or reproducible checks.
- UI/behavior alignment: whether visible behavior in the interface matches expected Codex-style interaction semantics.
- Session consistency: whether long-turn memory and notebook updates remain coherent instead of contradictory or repetitive.
