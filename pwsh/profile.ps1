# "dot source" this file in my $PROFILE

# Check whether my personally important environment variables are set or not
# and set fallback values if not set
if (-Not (Test-Path Env:\XDG_CONFIG_HOME)) {
    $env:XDG_CONFIG_HOME = $env:UserProfile + "\.config" 
    Write-Warning "XDG_CONFIG_HOME is not defind; using $env:XDG_CONFIG_HOME as fallback"
}
if (-Not (Test-Path Env:\XDG_DATA_HOME)) {
    $env:XDG_DATA_HOME = $env:UserProfile + "\.local\share"
    Write-Warning "XDG_DATA_HOME is not defind; using $env:XDG_DATA_HOME as fallback"
}
$env:LESSCHARSET = "utf-8"

# Define git related functions for aliases
function GitDiff { git diff $args }
function GitGraph { git graph $args }
function GitShowBranch { git show-branch $args }
function GitStatus { git status --short --branch --ahead-behind $args }

# Define git related aliases. Note, "gl" is for Get-Location by default.
Set-Alias gd GitDiff
Set-Alias gb GitShowBranch
Set-Alias gs GitStatus
if ($Host.Version.Major -ge 7) {
    Set-Alias -Force gl GitGraph
}
else {
    Set-Alias -Force -Option AllScope gl GitGraph
}

# Remove unnecessary aliases
Get-ChildItem Alias: | Where-Object -Property Name -in @("curl", "wget", "r") | Remove-Item

# Use Emacs keybindings
Set-PSReadLineOption -EditMode Emacs

# Use standard-ish prompt except that user profile directory is shown as "~"
function prompt {
    "PS " + "$(Get-Location)".Replace($env:USERPROFILE, "~") + "> "
}

# Setup EDITOR environment variable
if (Get-Command -ErrorAction Ignore -CommandType Application nvim) {
    $env:EDITOR = "nvim"
}

# Define "pipx" command which invokes its zipapp
if (Test-Path -Path "$env:USERPROFILE\.local\opt\pipx.pyz" -PathType Leaf) {
    function Invoke-Pipx {
        Invoke-Expression "$(scoop which python39) $env:USERPROFILE\.local\opt\pipx.pyz $args"
    }
    Set-Alias -Option AllScope pipx Invoke-Pipx
}

# Node.js (fnm)
if (Get-Command -ErrorAction Ignore -CommandType Application fnm) {
    fnm env --use-on-cd | Out-String | Invoke-Expression
}

# Python
$env:PIP_REQUIRE_VIRTUALENV = "true"
