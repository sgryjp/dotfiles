# "dot source" this file in my $PROFILE

# Define git related functions for aliases
function GitDiff { git diff }
function GitLog { git log --graph --oneline --decorate }
function GitShowBranch { git show-branch }
function GitStatus { git status -s }

# Define git related aliases. Note, "gl" is for Get-Location by default.
Set-Alias gd GitDiff
Set-Alias gb GitShowBranch
Set-Alias gs GitStatus
if ($Host.Version.Major -ge 7) {
    Set-Alias -Force gl GitLog
} else {
    Set-Alias -Force -Option AllScope gl GitLog
}

# Use Emacs keybindings
Set-PSReadLineOption -EditMode Emacs
