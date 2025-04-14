$env.config.show_banner = "short"
$env.config.datetime_format = { normal: '%+', table: '%F %T' } # format date -l
$env.config.cursor_shape = { emacs: blink_block, vi_insert: blink_block, vi_normal: blink_line }
$env.config.table.mode = "compact"

use std/dirs shells-aliases * # n, p, g, enter, dexit, or shells

# Disable shell integration when running on WezTerm on Windows
# https://github.com/nushell/nushell/issues/5585
if ($env | get -i OS TERM_PROGRAM) == [Windows_NT, WezTerm] {
  $env.config.shell_integration.osc133 = false
}

# Very basic (incomplete too) fzf-like fuzzy finder menu, for file and directory paths
$env.config.menus = ($env.config.menus | append {
  name: files_and_dirs_menu
  only_buffer_difference: true # Search is done on the text written after activating the menu
  marker: "| "
  type: {
    layout: list
    page_size: 10
  }
  style: {
    text: green
    selected_text: green_reverse
    description_text: yellow
  }
  source: {|buffer, position|
    ls **/*
    | filter { $in.name =~ $"($buffer)" }
    | each {|it| {
          value: $it.name,
          description: $"($it.type | str substring 0..1)"
        }
      }
    }
})

# Ctrl+t to trigger the file path fuzzy finder
$env.config.keybindings = ($env.config.keybindings | append {
  name: files_and_dirs_menu
  modifier: control
  keycode: char_t
  mode: emacs
  event: {
    send: menu name: files_and_dirs_menu
  }
})

alias gb = git show-branch
alias gd = git diff
alias gl = git graph
alias gla = git graph ...(git for-each-ref --format='%(refname:short)' 'refs/heads' 'refs/tags' 'refs/remotes' | lines)
alias gs = git status --short --branch --ahead-behind

source custom-completions/bat-completions.nu
source custom-completions/cargo-completions.nu
source custom-completions/curl-completions.nu
source custom-completions/docker-completions.nu
source custom-completions/dotnet-completions.nu
source custom-completions/git-completions.nu
source custom-completions/less-completions.nu
source custom-completions/man-completions.nu
source custom-completions/npm-completions.nu
source custom-completions/pnpm-completions.nu
source custom-completions/poetry-completions.nu
source custom-completions/pre-commit-completions.nu
source custom-completions/pytest-completions.nu
source custom-completions/rg-completions.nu
source custom-completions/rustup-completions.nu
source custom-completions/scoop-completions.nu
source custom-completions/ssh-completions.nu
source custom-completions/tar-completions.nu
source custom-completions/uv-completions.nu
source custom-completions/winget-completions.nu
