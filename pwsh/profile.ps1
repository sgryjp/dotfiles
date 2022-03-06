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
} else {
    Set-Alias -Force -Option AllScope gl GitLog
}

# Remove unnecessary aliases
Get-ChildItem Alias: | Where-Object -Property Name -in @("curl", "wget") | Remove-Item

# Use Emacs keybindings
Set-PSReadLineOption -EditMode Emacs

# Use standard-ish prompt using "~" for user profile directory
function prompt {
    "PS " + "$(Get-Location)".Replace($env:USERPROFILE, "~") + "> "
}

# Check and warn if host specific environment variables are not as expected
if ($env:XDG_CONFIG_HOME -eq $null) { Write-Warning "XDG_CONFIG_HOME is not defind." }
if ($env:XDG_DATA_HOME -eq $null)   { Write-Warning "XDG_DATA_HOME is not defind." }
