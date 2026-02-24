<div align="center">

# guga-codex

**The supervision layer that keeps Codex sessions safer, sharper, and consistent under real project pressure.**

</div>

---

guga-codex is a supervision-first Codex project.
It does not try to replace Codex generation ability. Instead, it adds a second control loop around each turn so behavior, quality, and execution discipline remain stable across long sessions.

When coding conversations get long, fast output alone is not enough. guga-codex focuses on making sessions reviewable, steerable, and resilient: less silent drift, fewer avoidable regressions, and clearer correction signals when model behavior deviates from user intent.

## Install

### Unix (macOS / Linux)

```bash
curl -fsSL https://raw.githubusercontent.com/Calculus-Singularity/guga-codex/main/scripts/install.sh | bash
```

### Windows (PowerShell)

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser; irm https://raw.githubusercontent.com/Calculus-Singularity/guga-codex/main/scripts/install.ps1 | iex
```

## Usage

Just use `guga-codex` the same way you would use Codex. The supervisor runs automatically in the background — it reviews every Codex turn, updates its persistent notebook, and surfaces correction or caution messages directly in the TUI when it detects issues.

### Supervisor chat and commands (`//`-prefixed)

Inside the TUI, prefix a message with `//` to talk directly to the GugaCodex supervisor instead of Codex:

| Command | Description |
|---|---|
| `//help` | Show available supervisor commands |
| `//stats` | Show supervision status for the current session |
| `//notebook` | Show the supervisor's persistent notebook |
| `//model` | Open or set the supervisor model |
| `//clear` | Start a fresh supervisor session |

Any other `//` message (e.g. `//focus on test coverage`) is sent as free-form chat to the supervisor.

## What This Project Emphasizes

- Continuous supervision on top of normal Codex turn flow.
- Persistent notebook memory for supervisory context across turns.
- Correction/caution mechanisms that can be surfaced in UI and fed back into the next turn.
- Practical alignment work so GugaCodex behavior remains close to Codex baseline where appropriate.

## What GugaCodex Checks

Today, the explicit turn-level supervision taxonomy is:

- `FALLBACK`: Codex refuses or defers instead of attempting the requested task.
- `IGNORED_INSTRUCTION`: Codex violates an explicit user instruction.
- `UNAUTHORIZED_CHANGE`: Codex changes unrelated behavior outside requested scope.
- `UNNECESSARY_INTERACTION`: Codex interrupts autonomous flow with avoidable back-and-forth when user asked to just do it.
- `OVER_ENGINEERING`: Codex introduces unnecessary architectural complexity for the requested task.

