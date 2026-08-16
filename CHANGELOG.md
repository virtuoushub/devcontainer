# Changelog

## 2026-08-16

### Changed

- **Base image versions**: Updated default `ELIXIR_VERSION` (1.19.5 → 1.17.3) and `OTP_VERSION` (28.3.2 → 26.0.2) in `.devcontainer/Dockerfile` to match the versions required by [Popcorn](https://hexdocs.pm/popcorn/first_steps.html).
- **Claude Code install**: Simplified the Dockerfile's npm install command to `npm install -g @anthropic-ai/claude-code`, dropping the `--allow-scripts` flag. Instead, `npm config set allow-scripts=@anthropic-ai/claude-code --location=user` is now run beforehand so the allow-scripts setting persists in the user's npm config.

## 2026-05-29

### Added

- **Makefile commands**: Added `dc.claude.update` and `dc.tidewave.update` to update Claude Code and Tidewave inside the devcontainer. Added `dc.makefile.pull` to pull the latest Makefile from the GitHub repo. Added `dc.bun.install` to install the assets with `mix bun`. Added `dc.rebuild.force` to force rebuild the devcontainer without cache.
- **Allowed domains**: Added default domains for Crates.io, Cloudflare, and Stripe.

## 2026-03-30

### Added
- **Devcontainer guard:** All Makefile targets that should only run inside the container now check the `DEVCONTAINER` env var and exit with a clear error message if run on the host

## 2026-03-12

### Added
- **Status command:** `make dc.status` shows whether the devcontainer is running

### Improved
- **Better `dc.down` output:** Prints `Devcontainer removed: <id>` and `Volume removed: <name>` (or corresponding "nothing to remove" messages) instead of raw Docker output

## 2026-03-10

### Added
- **Isolated `node_modules`:** `assets/node_modules` is now stored in a per-project Docker volume (`<project>-node-modules`) instead of being shared with the host, avoiding platform mismatches and improving install/build performance. The volume is cleaned up automatically on `make dc.down`

## 2026-03-04

### Fixed
- **Signal handling in Makefile:** Added `exec` to all interactive/long-running targets (`dc.server`, `dc.shell`, `dc.claude`, `dc.tidewave`, `dc.logs.*`) to prevent orphaned processes on CTRL+C
- **`dc.stop`/`dc.down` without running container:** No longer errors when no devcontainer is running; prints a message instead

## 2026-03-02

### Fixed
- **First-run `.claude` directory:** Added `initializeCommand` to create the `.claude` folder before the container starts, preventing a bind-mount failure on fresh projects

## 2026-02-26

### Added
- **Git identity:** Bind-mounts the host's `~/.gitconfig` into the container so git commits use your name and email
- **Git support:** Pre-configured `safe.directory` so git works inside the container; enabled git status in the zsh prompt
- **Git worktrees:** `make dc.worktree.new/list/remove` targets and `wt` shell function for switching between worktrees
- **Parallel Claude workflow:** Run multiple Claude instances in separate worktrees via multiple `make dc.shell` sessions
- **Zsh tab completion:** Enabled `compinit` and make target completion (`make <TAB>`)
- **Download script:** One-liner curl/tar command in README to fetch `.devcontainer/` into any project
- **Stop command:** `make dc.stop` stops the devcontainer without removing it, allowing fast restart with `make dc.up`
- **Tidewave logs command:** `make dc.logs.tidewave` now shows the tidewave logs

### Fixed
- **No more orphaned volumes:** Removed named Docker volumes for mix, hex, and bash history; these now live in the container layer and are cleaned up automatically on `make dc.down`

### Changed
- **Smaller image:** Replaced `vim` with `vim-tiny`, `build-essential` with `gcc`/`make`/`libc-dev`, cleaned docs/man pages and npm cache (~95-145MB savings)
