$env.config = ($env.config | upsert show_banner false)
$env.config = ($env.config | upsert datetime_format { normal: '%Y-%m-%d %H:%M:%S %z' })
$env.config.cursor_shape = { emacs: blink_block, vi_insert: blink_block, vi_normal: blink_line }

alias gb = git show-branch
alias gd = git diff
alias gl = git graph
alias gs = git status
