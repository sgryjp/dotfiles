$env.config = ($env.config | upsert show_banner false)
$env.config = ($env.config | upsert datetime_format { normal: '%Y-%m-%d %H:%M:%S %z' })
$env.config.cursor_shape = { emacs: blink_block, vi_insert: blink_block, vi_normal: blink_line }

alias gb = git show-branch
alias gd = git diff
alias gl = git graph
alias gll = git graph ...(git for-each-ref --format='%(refname:short)' 'refs/heads' 'refs/tags' | lines)
alias glr = git graph ...(git for-each-ref --format='%(refname:short)' 'refs/heads' 'refs/tags' 'refs/remotes' | lines)
alias gla = git graph ...(git for-each-ref --format='%(refname:short)' 'refs' | lines)
alias gs = git status --short --branch --ahead-behind

source git-completions.nu
