# Repository Guide

Personal dotfiles for shells, editors, Git, tmux, and coding agents.

## Configuration Map

- `profile/profile.sh`
  - Login environment: locale, XDG paths, PATH, and tool initialization.
    `setup.sh` adds sourcing blocks to existing `~/.profile`,
    `~/.bash_profile`, and `~/.zprofile`.
- `profile/rc.sh`
  - Shared interactive Bash/Zsh settings: aliases, editor, pager, and history.
    Sourced from existing `~/.bashrc` and `~/.zshrc` via `setup.sh`.
- `profile/bashrc.bash`, `profile/zshrc.zsh`
  - Shell-specific prompts, keybindings, and integrations. Sourced alongside
    `rc.sh`.
- `nu/`
  - Nushell environment, prompt, aliases, keybindings, and completions. Setup
    appends source lines to Nushell's environment and configuration files.
    `download-completions.nu` refreshes `custom-completions/` from upstream.
- `pwsh/profile.ps1`
  - PowerShell environment, aliases, prompt, and keybindings. Must be
    dot-sourced manually from `$PROFILE`; neither setup script installs it.
- `git/config`
  - Shared Git settings and aliases, included by the global Git configuration.
- `git/ignore`
  - Ignore patterns. `setup.sh` symlinks this to `~/.config/git/ignore`;
    `setup.nu` copies it to `~/.gitignore`.
- `vimfiles/`
  - Vim settings, keymaps, and bundled vim-plug loader. Setup symlinks
    individual files into `~/.vim/`.
- `nvim/`
  - Neovim Lua configuration: `init.lua` loads plugins, keymaps, and options;
    `lua/plugins/` holds per-plugin settings. Setup symlinks individual files
    into the Neovim config directory.
- `tmux.conf`
  - tmux behavior, status line, mouse, and terminal key handling. `setup.sh`
    symlinks it to `~/.tmux.conf`.
- `personal-instructions.md`
  - Global coding-agent guidelines. Symlinked to `~/.pi/agent/AGENTS.md` and,
    when `~/.copilot` already exists, `~/.copilot/copilot-instructions.md`.
    Distinct from this repository-local guide.
- `agents/*.md`
  - Custom agents. Symlinked into `~/.pi/agent/agents/` and
    `~/.copilot/agents/`; Copilot filenames use the `.agent.md` suffix.
- `prompts/`
  - Pi prompt templates. **Copied**, not symlinked, into
    `~/.pi/agent/prompts/`; rerun setup to deploy edits.
- `scripts/setup-pi-extensions.sh`
  - Installs pinned Pi extension packages with `pi install`; run separately
    from setup.
- `scripts/super-refresh.nu`
  - Updates installed tools and clears caches and temporary files; not a setup
    or validation script.

## Setup and Editing

- `setup.sh` is the POSIX-shell installer; `setup.nu` is the Nushell installer.
  They overlap but are not interchangeable: `setup.sh` also configures
  Bash/Zsh, Readline, and tmux.
- `setup.sh` uses `~/.config/nvim`; `setup.nu` uses `$XDG_CONFIG_HOME/nvim`,
  falling back to `~/.config/nvim`.
- Edit repository sources. Symlinked and sourced configurations use those
  sources directly; copied files require redeployment.
- Keep the checkout path stable: installed links and source lines refer to it.
- When adding configuration files, check both installers. Some files are listed
  explicitly rather than discovered automatically.
- Both installers still reference `wezterm.lua`, which is absent from this
  checkout.
- Run installers only when deployment is intended: they modify user-level
  configuration, can replace destination files, and remove broken symlinks from
  selected configuration directories.

## Validation

- Run `pre-commit run` for staged files, or `pre-commit run --files <paths>`
  for specific changed files. The hooks require `stylua` and `shfmt` on PATH.
- ShellCheck runs in `.github/workflows/shellcheck.yml`.
- Setup and maintenance scripts modify the user environment; do not run them as
  validation.
