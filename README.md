<h1 align="center">Guga-Codex</h1>

<div align="center">
  
**A watchdog agent for Codex sessions**

</div>

The longer a Codex session runs, the more it quietly goes off the rails: skipped instructions, unauthorized edits, unnecessary abstractions. You don't notice until you're deep in a broken diff.

guga-codex is a real-time supervisor that catches these on every turn — before they compound. It doesn't replace Codex's generation ability. It watches each turn, flags deviations the moment they happen, and surfaces corrections directly in the TUI so you can steer instead of clean up.

<p align="center">
  <img src="assets/drift_comparison.gif" alt="Codex session drift comparison — without vs with guga-codex supervision" width="720" />
</p>

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
| `//toggle` | Toggle supervisor on/off at runtime |

Any other `//` message (e.g. `//focus on test coverage`) is sent as free-form chat to the supervisor.

### Local issue tracker (`guga-codex issues`)

guga-codex has a built-in local issue tracker. Run `guga-codex issues init` to set up, and `guga-codex issues --help` to see available commands.

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
- `BYPASSED_ISSUE_TRACKER`: Codex uses built-in TodoWrite or task management instead of `guga-codex issues`.

