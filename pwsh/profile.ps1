# "dot source" this file in my $PROFILE

# Define git related functions for aliases
function GitDiff { git diff $args }
function GitLog { git log --graph --oneline --decorate $args }
function GitShowBranch { git show-branch $args }
function GitStatus { git status -s $args }

# Define git related aliases. Note, "gl" is for Get-Location by default.
Set-Alias gd GitDiff
Set-Alias gb GitShowBranch
Set-Alias gs GitStatus
if ($Host.Version.Major -ge 7) {
    Set-Alias -Force gl GitLog
}
else {
    Set-Alias -Force -Option AllScope gl GitLog
}

# Remove unnecessary aliases
Get-ChildItem Alias: | Where-Object -Property Name -in @("curl", "wget") | Remove-Item

# Use Emacs keybindings
Set-PSReadLineOption -EditMode Emacs

# Use standard-ish prompt except that user profile directory is shown as "~"
function prompt {
    "PS " + "$(Get-Location)".Replace($env:USERPROFILE, "~") + "> "
}

# Check and warn if host specific environment variables are not as expected
if ($null -eq $env:XDG_CONFIG_HOME) { Write-Warning "XDG_CONFIG_HOME is not defind." }
if ($null -eq $env:XDG_DATA_HOME) { Write-Warning "XDG_DATA_HOME is not defind." }

# Setup EDITOR environment variable
if (Get-Command -CommandType Application nvim) {
    $env:EDITOR = "nvim"
}
