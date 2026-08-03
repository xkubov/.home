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

Configs are installed by **symlinking the target path in `$HOME` to the file in this repo**, so edits take effect in place — no install step after editing, just reload the tool.

There is deliberately **no installer**. A `Makefile` used to exist and was removed (commit `caa0380`) because its approach was unwanted — it also ran `rm -rf $HOME/.config` and referenced directories that no longer exist. Do not reintroduce a Makefile-based installer without asking.

Install a tool by hand, one at a time:

```sh
ln -sfn /Users/petekubo/projects/mydots/<dir>/<file> ~/<target>
```

Use `ln -sfn` (not plain `ln -s`) so re-running replaces an existing symlink instead of nesting one inside a directory. **Back up first if the target is a real file** — check with `[ -L path ]` before overwriting, since a real file there may hold settings not in the repo.

### Currently symlinked

| Target | Source | Status |
|---|---|---|
| `~/.gitconfig` | `git/.gitconfig` | linked (previous real file saved to `~/.gitconfig.bak.pre-dots`) |
| `~/.tmux.conf` | `tmux/.tmux.conf` | linked |
| `~/.config/nvim` | `nvim/` | linked (whole directory) |

Everything else (`fish`, `sketchybar`, `skhd`, `yabai`, `alacritty`) is **not yet linked** — those live as independent files outside the repo. Link them one tool at a time as they're reviewed.

**`lazy-lock.json` is rewritten by `:Lazy sync`**, which updates every plugin to its branch head. It is a tracked file, so a sync produces a repo diff — commit it deliberately, and expect breaking upstream changes to arrive this way (that's how the Treesitter rewrite landed). Use `:Lazy restore` to roll plugins back to the committed lockfile.

### Verified working after install

`nvim` starts clean with no errors, warnings, or deprecation notices. Confirmed end-to-end: Treesitter highlighting active on a Python buffer with 6 parsers compiled; `pyright` + `ruff` both attach and report diagnostics; format-on-save reformats Python via ruff. 5 servers installed under `~/.local/share/nvim/mason/bin`.

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

### External dependencies (all MIT-licensed, no proprietary software)

Audited for `git/.gitconfig` and `tmux/.tmux.conf`:

- **`tmux/.tmux.conf` has zero external dependencies.** No TPM, no plugins, no `run-shell`. The `#{prefix_highlight}` in `status-right` (line 49) is from tmux-prefix-highlight, which is **not installed** — an unresolved format string renders as empty, so it degrades silently rather than breaking.
- **`git/.gitconfig` needs `fzf`** (MIT) for 4 interactive aliases: `api`, `bl`, `chi`, `chic`. **fzf is not currently installed** — those 4 aliases fail until `brew install fzf`. Every other alias is pure git plus POSIX tools (`sed`, `awk`, `xargs`, `uniq`, `rm`, `echo`).
- **`delta`** (git-delta, MIT) is installed and set as `core.pager`.
- `include.path = ~/.config/delta/themes.gitconfig` **does not exist**, so `delta.features = arctic-fox` is undefined. Verified harmless: git ignores unreadable includes and delta falls back to its default theme without erroring. To get the intended theme, fetch a delta themes file that defines `arctic-fox`.

## Neovim plugin licenses

Audited via the GitHub license API against the specs in `lua/plugins.lua`. **Nothing proprietary is currently declared**, but two entries need attention and several are copyleft — relevant if any config is ever shared into an employer context.

**Proprietary — do not reintroduce:**
- `github/copilot.vim` is licensed under the **GitHub Terms of Service**, not an open-source license ("All Rights Reserved"). Already removed (it was a stale `lazy-lock.json` entry with no plugin spec). Do not re-add Copilot without checking employer policy on AI coding assistants.

**No license at all (all rights reserved by default):**
- `ThePrimeagen/vim-be-good` — no LICENSE file and no statement in the README. **Removed.**
- `tpope/vim-fugitive` — no LICENSE file, but `doc/fugitive.txt` states "License: Same terms as Vim itself", i.e. the **Vim License** (GPL-compatible, charityware). Kept; the GitHub API just can't detect it. Don't "fix" this as unlicensed.

**Copyleft (fine for personal use; note before redistributing this repo):**
- GPL-3.0: `nvim-tree/nvim-tree.lua`, `BlakeJC94/alpha-nvim-fortune`
- Vim License: `tpope/vim-fugitive`

Everything else is permissive: MIT (`nvim-cmp`, `cmp-nvim-lsp`, `plenary`, `telescope`, `lualine`, `gitsigns`, `nightfox`, `Comment.nvim`, `indent-blankline`, `vim-matchup`, `nvim-web-devicons`, `alpha-nvim`, `vimwiki`), Apache-2.0 (`lazy.nvim`, `nvim-lspconfig`, `LuaSnip`, `cmp_luasnip`, `nvim-treesitter`, `mason`, `mason-lspconfig`), BSD-3-Clause (`undotree`).

When adding a plugin, check its license first — prefer permissive, and never add anything under a proprietary ToS.

## Neovim architecture

`init.lua` (94 lines) holds only options, keymaps, and per-filetype indent autocmds. Everything else is in `lua/`.

- **`mapleader = " "` is set at `init.lua:1`, before `require("plugins")` at line 4.** That order is load-bearing — plugin `config` functions register `<leader>` maps.
- **lazy.nvim**, self-bootstrapping (`lua/plugins.lua:6-20`): clones to `~/.local/share/nvim/lazy/lazy.nvim` on first launch, `os.exit(1)` on failure. No manual install. Versions pinned in `lazy-lock.json`.
- **LSP is wired through exactly one edge**: `lua/plugins.lua:31` calls `require("config.lsp").setup()` from inside the `nvim-lspconfig` spec. `lua/config/lsp.lua` is never required from `init.lua`, and there is no `lua/config/init.lua`.
- **nvim-cmp is configured in `lua/config/lsp.lua:159-196`**, not in `plugins.lua` — a non-obvious place to look. Sources are only `nvim_lsp` and `luasnip` (no buffer/path/cmdline).
- `lua/config/lsp.lua:65` calls `require("cmp_nvim_lsp")` at **module top level**, which is why `cmp-nvim-lsp` is declared a dependency of lspconfig (`plugins.lua:28`). Removing that dependency breaks LSP loading, not just completion.
- A shared `on_attach` (`lsp.lua:6-62`) plus module-level `capabilities` and `lsp_flags` singletons are passed to every server. When adding a server, wire all three or it will behave differently from its peers.

### Adding an LSP server requires two edits

`mason-lspconfig` is configured **without** `handlers`/`setup_handlers`, so mason only *installs*. Activation is separate. Adding a server to `ensure_installed` alone does nothing; adding it to `vim.lsp.enable` alone means it never attaches unless the binary is already on `PATH`.

So: add the name to `ensure_installed` in `plugins.lua` **and** to `vim.lsp.enable({...})` in `lsp.lua`. Only add a `vim.lsp.config("<name>", {...})` block if you need to override lspconfig's shipped defaults.

Python is deliberately split: **ruff** formats, lints, and owns import organization; **pyright** does type checking with `disableOrganizeImports = true` (`lsp.lua:97`). Format-on-save exists **only for `*.py`** (`lsp.lua:148-153`); everything else formats manually via `<leader>f`.

### Cleanups already applied — don't reintroduce

Removed in `8d2af1c` and `8410e5b`; if a future edit looks like it's adding these back, it's a regression:

- **none-ls + mason-null-ls** — none-ls ran with `sources = {}` (zero diagnostics/formatters) and mason-null-ls declared `pyright`, which is an LSP, not a null-ls source. Formatting is handled by the LSP servers directly (ruff for Python). Don't re-add a null-ls layer unless there's an actual source to register; prefer `conform.nvim` if a non-LSP formatter is ever needed.
- **nvim-dap** — GPL, and had no adapters, no dap-ui, and no keymaps, so it could not debug anything.
- **vim-closer** — unmaintained; use `nvim-autopairs` or `matchpairs` if autoclosing is wanted.
- **`ToggleCodespell()` / `<leader>fc`** — toggled a file-local that nothing read.
- **Three shadowed keymaps** where the second definition silently won: `th` (`:tabfirst` → moved to `tf`), `<leader>e` (en_us spell toggle → moved to `<leader>S`, since the diagnostic float owns `<leader>e`), and a bogus `"<Ctrl-space>"` literal on `<leader><space>` (dropped; VimWiki owns it).

### Remaining known quirk

`gD` means *type definitions* to telescope (`plugins.lua`) but *declaration* in `on_attach` (`lsp.lua`). Both are still mapped; the buffer-local LSP map wins inside LSP buffers, so `gD` behaves differently depending on the buffer. Left as-is deliberately.
### Version drift (this machine runs Neovim 0.12.4)

Verified against the installed `nvim`, not assumed:

- Deprecated APIs were replaced in `0094b78` / `8410e5b`: use `vim.lsp.get_clients` (not `get_active_clients`), `vim.bo[buf].opt = …` (not `nvim_buf_set_option`), and `vim.diagnostic.jump({count = ±1})` (not `goto_prev`/`goto_next`).
- Mason specs were renamed to **`mason-org/*`** in `f3535d4` (the `williamboman/*` paths only resolved via GitHub redirect). Note mason-lspconfig 2.x changed its config API, so an unpinned update may still break.
- **`telescope.nvim` is pinned to `tag = "0.1.4"`** while upstream is at v0.2.x — several years stale. Unpinning is untested; do it deliberately.

### Treesitter is on the `main` branch (rewritten API)

Migrated in `92aad09`. The old `master` API is **gone**, and going back is not an option — `master` is frozen upstream and its README lists Neovim 0.12 as explicitly unsupported.

Consequences for editing the spec:
- There is **no `nvim-treesitter.configs` module**, no `ensure_installed`, and no `highlight = {}` table. Don't reintroduce them; that's what broke on first sync.
- Parsers are installed imperatively via `require("nvim-treesitter").install({...})`. The spec installs only the parsers not already present.
- **Highlighting is Neovim's job now**: a `FileType` autocmd calls `vim.treesitter.start()`, keeping the 1 MB size skip. Enabling highlighting for a new filetype needs nothing — it's generic.
- **Requires `tree-sitter-cli`** (`brew install tree-sitter-cli`, ≥0.26.1) to compile parsers, plus a C compiler. Without it, every parser install fails with `ENOENT: 'tree-sitter'`.
- `main` **does not support lazy-loading**, hence `lazy = false`.

### LSP uses `vim.lsp.config`, not `require('lspconfig')`

Also migrated in `92aad09`, because `require('lspconfig')` now emits a deprecation warning and is slated for removal in nvim-lspconfig v3.0.0.

- nvim-lspconfig's role is now just shipping ~400 `lsp/<name>.lua` runtime files (cmd, filetypes, root markers). `vim.lsp.config` picks those up automatically, so per-server blocks only carry *our* overrides.
- Shared `on_attach` / `capabilities` / `flags` are registered once via `vim.lsp.config("*", {...})`.
- Servers are activated by `vim.lsp.enable({...})` at the end of `M.setup()`.
- **`vim.lsp.enable` in `lsp.lua` and `ensure_installed` in `plugins.lua` must stay in sync** — mason installs, `vim.lsp.enable` activates. Currently 5 servers: `ruff`, `pyright`, `ts_ls`, `rust_analyzer`, `lua_ls`.
- **`gopls` is deliberately absent from both.** mason builds it with `go install`, and there's no Go toolchain on this machine, so it failed on every sync. Add it to both lists together if Go is installed later.

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

`git/.gitconfig` sets `delta.features = arctic-fox` via an `include` of `~/.config/delta/themes.gitconfig`, which does not exist — see the dependency notes above. Harmless, but the theme is not actually applied.

## Other conventions

- `config.local.fish` is gitignored — machine-specific shell settings belong there, not in `config.fish`.
- Theme is Nightfox, and it is duplicated across tools: nvim colorscheme + a hardcoded `lualine theme = "nightfox"` (`plugins.lua:222`, must change with `:411`), the fish color block, and hand-written hex in `tmux/.tmux.conf`. Changing theme means editing every one.
- `alacritty/` tracks both `alacritty.toml` (current) and `alacritty.yml` (legacy, unused by modern Alacritty).
- `vim/` is the retired Vim+Vundle+coc config, superseded by `nvim/`. Don't edit it when asked to change "vim" — that means `nvim/`.
