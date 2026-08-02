# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal macOS dotfiles (`~/projects/mydots`). No build, no tests, no CI — changes are validated by reloading the affected tool. There is no application code here; every file is configuration for a specific tool.

## Branches are per-machine variants, not features

This is the most important thing to understand. Each long-lived branch is a complete config for one environment, and they are meant to diverge permanently rather than be merged into `master`:

| Branch | Environment | `user.email` in `git/.gitconfig` |
|---|---|---|
| `master` | personal | `xkubov@gmail.com` |
| `work` | SkipPay | `peter.kubov@skippay.cz` |
| `amazon` | Amazon | `petekubo@amazon.cz` |

`amazon` was branched from `origin/work` (so it inherits Alacritty, the Lua nvim setup, delta, and the aerospace sketchybar) and deliberately has **no upstream tracking** — a bare `git push` must not land on `work`. Use `git push -u origin amazon` the first time.

Implications when making changes:
- Ask which branch/environment a change is for. Never merge a branch into `master` to "sync" it.
- Only port changes deliberately, one tool at a time. `git cherry-pick`, or `git diff master...origin/work -- <path>` to see what a branch did to one tool.
- The identity block in `git/.gitconfig` is the one file that must stay different per branch. Don't "fix" it to match another branch.
- Because branches diverge, machine-specific absolute paths leak in easily. See the hardcoded-path issue below.

## Installation model

`~/.config/<tool>` and `~/.<tool>rc` are **symlinks into this repo**, so edits take effect in place — no install step after editing, just reload the tool.

Nothing is currently symlinked on this machine (checked: `~/.gitconfig`, `~/.config/nvim`, `~/.config/fish`, `~/.tmux.conf`, `~/.config/sketchybar`, `~/.skhdrc` are all absent or plain files). Whatever installed the current environment, it was not this repo's `Makefile`.

### The Makefile is legacy and partly destructive — do not run it

`make` / `make all` / `make core` will fail or do damage. Verify before touching it:

- **`make config` runs `rm -rf $HOME/.config`** (Makefile:61-66). It deletes the entire `~/.config` directory — every tool's config, not just this repo's. `vimc` depends on `config` (Makefile:19), so **`make vimc` wipes `~/.config`**.
- `vimc` installs the *old* Vim config, not the current Neovim one: it symlinks `~/.config/nvim/init.vim` → `vim/.vimrc` and clones Vundle. It does not reference `nvim/` at all.
- `core` depends on `fzfc`, which **is not defined** → `make core` and `make all` error out.
- `bashc` and `sshc` reference `bash/` and `ssh/` directories that **do not exist** in the repo.
- Only `gitc` and `tmuxc` are currently sound, and `tmuxc` fails if `~/.tmux.conf` already exists (no unlink guard, unlike the other targets).

Treat the Makefile as unmaintained. Prefer creating symlinks explicitly, or rewrite the target properly before running it.

## Applying changes per tool

| Tool | Files | How to apply |
|---|---|---|
| Neovim | `nvim/` | Restart nvim; `:Lazy sync` after editing `lua/plugins.lua` |
| fish | `fish/config.fish` | `exec fish` or new shell |
| git | `git/.gitconfig` | Immediate |
| tmux | `tmux/.tmux.conf` | `tmux source-file ~/.tmux.conf` (prefix is `C-a`, not `C-b`) |
| sketchybar | `sketchybar/` | `sketchybar --reload` |
| skhd | `skhd/.skhdrc` | `skhd --restart-service` |
| yabai | `yabai/.yabairc` | `yabai --restart-service` |
| Alacritty | `alacritty/alacritty.toml` | Live-reloads on save |

`brew/core` is a plain newline-separated package list, not a Brewfile: install with `xargs brew install < brew/core`. It lists `exa`, which is deprecated/unmaintained, while `fish/config.fish` aliases `ls` to `eza` (the successor) — the list is out of date with the shell config.

## Neovim architecture

`init.lua` (94 lines) holds only options, keymaps, and per-filetype indent autocmds. Everything else is in `lua/`.

- **`mapleader = " "` is set at `init.lua:1`, before `require("plugins")` at line 4.** That order is load-bearing — plugin `config` functions register `<leader>` maps.
- **lazy.nvim**, self-bootstrapping (`lua/plugins.lua:6-20`): clones to `~/.local/share/nvim/lazy/lazy.nvim` on first launch, `os.exit(1)` on failure. No manual install. Versions pinned in `lazy-lock.json`.
- **LSP is wired through exactly one edge**: `lua/plugins.lua:31` calls `require("config.lsp").setup()` from inside the `nvim-lspconfig` spec. `lua/config/lsp.lua` is never required from `init.lua`, and there is no `lua/config/init.lua`.
- **nvim-cmp is configured in `lua/config/lsp.lua:159-196`**, not in `plugins.lua` — a non-obvious place to look. Sources are only `nvim_lsp` and `luasnip` (no buffer/path/cmdline).
- `lua/config/lsp.lua:65` calls `require("cmp_nvim_lsp")` at **module top level**, which is why `cmp-nvim-lsp` is declared a dependency of lspconfig (`plugins.lua:28`). Removing that dependency breaks LSP loading, not just completion.
- A shared `on_attach` (`lsp.lua:6-62`) plus module-level `capabilities` and `lsp_flags` singletons are passed to every server. When adding a server, wire all three or it will behave differently from its peers.

### Adding an LSP server requires two edits

`mason-lspconfig` here is configured **without** `handlers`/`setup_handlers`, so mason only *installs* — all real config lives in `lsp.lua`. Adding a server to `ensure_installed` alone does nothing.

The two lists already disagree: mason installs `lua_ls`, `rust_analyzer`, `pyright`, `ruff` (`plugins.lua:51-58`), but `lsp.lua` also configures `ts_ls` (:113) and `gopls` (:141). Those two are **not** mason-managed and must be on `PATH` (`typescript-language-server`, `gopls`) or they silently never attach.

Python is deliberately split: **ruff** formats, lints, and owns import organization; **pyright** does type checking with `disableOrganizeImports = true` (`lsp.lua:97`). Format-on-save exists **only for `*.py`** (`lsp.lua:148-153`); everything else formats manually via `<leader>f`.

### Known dead code and shadowed keymaps

Don't assume these work — verify before building on them:

- **`<leader>fc` / `ToggleCodespell()` is a no-op.** `turn_on_codespell` (`init.lua:88-94`) is a file-local that nothing reads; there is no codespell source anywhere. Leftover from an older null-ls/ALE setup.
- **none-ls is installed with `sources = {}`** (`plugins.lua:70-74`) — initialized but contributing zero diagnostics/formatters. Required under its legacy name `require("null-ls")`.
- `mason-null-ls` has `ensure_installed = { "pyright" }` — pyright is an LSP, not a null-ls source; redundant with mason-lspconfig.
- `copilot.vim` is pinned in `lazy-lock.json` but has **no spec** in `plugins.lua`. `lazy-lock.json` is not a reliable inventory of what's installed.
- Duplicate maps where the **later definition wins**: `<leader>e` (spell toggle at `init.lua:48` is dead; diagnostics float at `:61` wins), `th` (`:tabfirst` at `:40` dead, `:tabprev` at `:42` wins), `<leader><space>` (`:49` dead, VimWiki at `:55` wins).
- `gD` means *type definitions* to telescope (`plugins.lua:207`) but *declaration* in `on_attach` (`lsp.lua`) — buffer-local wins in LSP buffers.
- Deprecated APIs still in use: `vim.api.nvim_buf_set_option` and `vim.lsp.get_active_clients` (`lsp.lua:8,32,47,48`); the `williamboman/mason*` forks are archived (upstream is `mason-org/*`).

## sketchybar architecture

`sketchybarrc` sources `colors.sh` and `icons.sh`, then sources each item from `items/`. **Items define appearance and click handlers; `plugins/` holds the scripts items invoke on events.** Adding a widget means a file in each, plus a `source` line in `sketchybarrc`.

Two things to know:

- **`sketchybarrc` compiles a C helper on every reload**: it `killall helper`, then `cd $HOME/.config/sketchybar/helper && make`, then runs it as `git.kubov.helper`. `clang` must be available or reload fails. The compiled `helper` binary is **committed to the repo** (arm64 Mach-O) — it is a build artifact and will conflict on merges; it should arguably be gitignored.
- **Window-manager split-brain**: `items/spaces.sh` and `plugins/aerospace.sh` query **aerospace** (`aerospace list-workspaces`), but `skhd/.skhdrc` drives **yabai** exclusively (47 yabai commands, 0 aerospace) and `yabai/.yabairc` is still present. The bar and the keybindings target different window managers. Confirm which WM is actually running before changing either. A stale `plugins/yabai.sh` also remains.

`sketchybarrc` also unloads `com.apple.OSDUIHelper` to suppress the macOS volume overlay.

## Hardcoded absolute paths — check these on every branch

Configs contain stale home directories from other machines. The real home here is `/Users/petekubo`. Grep for `/Users/` before trusting any path:

- `fish/config.fish` references both `/Users/peter.kubov/.local/bin` and `/Users/kubov/.local/bin` — neither exists on this machine, so those `PATH` entries are inert.
- `git/.gitconfig` previously had `include.path = /Users/kubov/.config/delta/themes.gitconfig`; now `~/.config/delta/themes.gitconfig`. Prefer `~` over absolute homes in new config.
- nvim's alpha dashboard hardcodes `$HOME/projects` and `~/vimwiki/index.wiki`; pyright's `stubPath` points at a `python-type-stubs` directory that no plugin ever creates (harmless only because `reportMissingTypeStubs = false`).

**`git/.gitconfig` currently sets `core.pager = delta` and `delta.features = arctic-fox`, but `delta` is not installed and `~/.config/delta/` does not exist** — git paging is broken on this branch until `brew install git-delta` plus a themes file that defines `arctic-fox`.

## Other conventions

- `config.local.fish` is gitignored — machine-specific shell settings belong there, not in `config.fish`.
- Theme is Nightfox, and it is duplicated across tools: nvim colorscheme + a hardcoded `lualine theme = "nightfox"` (`plugins.lua:222`, must change with `:411`), the fish color block, and hand-written hex in `tmux/.tmux.conf`. Changing theme means editing every one.
- `alacritty/` tracks both `alacritty.toml` (current) and `alacritty.yml` (legacy, unused by modern Alacritty).
- `vim/` is the retired Vim+Vundle+coc config, superseded by `nvim/`. Don't edit it when asked to change "vim" — that means `nvim/`.
