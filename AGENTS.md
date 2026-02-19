# Agent Notes

## Project overview

This repo automates macOS setup for a new machine. The main files are:

- `scripts/setup.sh` — the setup script, run once on a new machine
- `Brewfile` — Homebrew packages and casks
- `config/` — dotfiles copied to their destinations by the script
- `README.md` — setup instructions

## User preferences

- **Keep it simple.** No fancy options, flags, or configurability. The script does everything every time.
- **Manual steps are acceptable.** If automation is fragile or requires a deprecated tool, prefer a clear manual step over a hacky solution.
- **Avoid extra tools** unless there's a clear benefit and the tool is well-maintained.
- **Present options before implementing** non-trivial changes. Wait for approval.
- **Commit after each logical change.** Always commit and push together. Write concise, descriptive commit messages.
- **The script should be idempotent** — safe to re-run without side effects.

## macOS automation patterns

- **System preferences:** Use `defaults write` for most settings. Many require a logout to take effect.
- **Dock management:** Use `dockutil` (in Brewfile). Finder and Trash are permanent dock items — do not try to add them, only add other items.
- **Terminal settings:** Use AppleScript (`osascript`) rather than `defaults write` — more reliable when Terminal is running.
- **Finder sidebar:** `mysides` is deprecated and disabled in Homebrew (as of Oct 2025). This step is manual.
- **Widget/Control Center settings:** stored in `com.apple.WindowManager` and `com.apple.controlcenter`.

## Working with uncertain `defaults write` keys

If a `defaults write` key is uncertain, do not guess. Verify by reading the relevant plist before and after making the change manually on a fresh machine, then diff the output to confirm the correct key.

## Keeping these notes up to date

Update this file when discovering new patterns, deprecated tools, or other useful findings — especially things that would affect future automation decisions.

## Known limitations

- Keyboard shortcut removal (Cmd-Shift-A, Cmd-Shift-M) is not automated — the symbolic hotkey IDs are unknown without a fresh machine to inspect.
- Finder sidebar setup is manual — no maintained tool exists for this.
- JetBrains settings are manual — no good automation path.
