# gugugaga

**The supervision layer that keeps Codex sessions safer, sharper, and consistent under real project pressure.**

Built on top of [Calculus-Singularity/codex](https://github.com/Calculus-Singularity/codex) · Rust · TUI

---

gugugaga is a supervision-first Codex project.
It does not try to replace Codex generation ability. Instead, it adds a second control loop around each turn so behavior, quality, and execution discipline remain stable across long sessions.

When coding conversations get long, fast output alone is not enough. gugugaga focuses on making sessions reviewable, steerable, and resilient: less silent drift, fewer avoidable regressions, and clearer correction signals when model behavior deviates from user intent.

## Install

### Unix (macOS / Linux)

```bash
curl -fsSL https://raw.githubusercontent.com/Calculus-Singularity/gugugaga/main/scripts/install.sh | bash
```

### Windows (PowerShell)

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser; irm https://raw.githubusercontent.com/Calculus-Singularity/gugugaga/main/scripts/install.ps1 | iex
```

## What This Project Emphasizes

- Continuous supervision on top of normal Codex turn flow.
- Persistent notebook memory for supervisory context across turns.
- Correction/caution mechanisms that can be surfaced in UI and fed back into the next turn.
- Practical alignment work so Gugugaga behavior remains close to Codex baseline where appropriate.

## What Gugugaga Checks

Today, the explicit turn-level supervision taxonomy is:

- `FALLBACK`: Codex refuses or defers instead of attempting the requested task.
- `IGNORED_INSTRUCTION`: Codex violates an explicit user instruction.
- `UNAUTHORIZED_CHANGE`: Codex changes unrelated behavior outside requested scope.
- `UNNECESSARY_INTERACTION`: Codex interrupts autonomous flow with avoidable back-and-forth when user asked to just do it.
- `OVER_ENGINEERING`: Codex introduces unnecessary architectural complexity for the requested task.

