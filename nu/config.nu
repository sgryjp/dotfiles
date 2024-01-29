$env.config = ($env.config | upsert show_banner false)
$env.config.cursor_shape = { emacs: blink_block, vi_insert: blink_block, vi_normal: blink_line }

alias gb = git show-branch
alias gd = git diff
alias gl = git graph
alias gs = git status
