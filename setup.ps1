#Requires -Version 5.1
[CmdletBinding()]
param ()

$ErrorActionPreference = "Stop" # Stop immediately whatever an error occurred

# Ensure XDG_CONFIG_HOME is defined
if ($null -eq $env:XDG_CONFIG_HOME) {
    Write-Error "Environment variable XDG_CONFIG_HOME is not set."
    exit 3
}

function New-Directory {
    [CmdletBinding()]
    param (
        [string]$Path
    )
    Write-Verbose "(dir)  $Path"
    if (Test-Path -Path $Path -PathType Leaf) {
        Write-Warning "Cannot make a directory because the target exists: $Path"
    }
    elseif (-not (Test-Path -Path $Path -PathType Container)) {
        $null = New-Item -ErrorAction $ErrorActionPreference -ItemType Directory $Path
    }
}

function New-SymlinkFile {
    [CmdletBinding()]
    param (
        [string]$LinkTarget,
        [string]$Path
    )
    Write-Verbose "(link) $Path -> $LinkTarget"
    if (-not (Test-Path -Path $Path)) {
        $null = New-Item -ErrorAction $ErrorActionPreference `
            -Verbose `
            -ItemType SymbolicLink `
            -Path $Path `
            -Target $LinkTarget
    }
}

function Get-LinkPathAndTarget {
    [CmdletBinding()]
    param (
        [string]$Source,
        [string]$Destination
    )
    return Get-ChildItem -File -Recurse $Source | ForEach-Object {
        try {
            Push-Location $Source
            $target = $_
            $path = Join-Path $Destination (Resolve-Path -Relative $_)
            $path = $path.Replace("\.\", "\")
            return [Tuple]::Create($target, $path)
        }
        finally {
            Pop-Location
        }
    }
}

# Git configurations
git config --global include.path $PSScriptRoot\git\config
Copy-Item "$PSScriptRoot\git\ignore" "$env:USERPROFILE\.gitignore"

# Create directories
$dirs = [System.Collections.ArrayList]::new(
    @(
        # VIM ------------------------------------------------------------------
        "$env:USERPROFILE\_vim",
        "$env:USERPROFILE\_vim\autoload",
        "$env:USERPROFILE\.vim",
        "$env:USERPROFILE\.vim\autoload",
        "$env:USERPROFILE\vimfiles",
        "$env:USERPROFILE\vimfiles\autoload",
        # Neovim ---------------------------------------------------------------
        "$env:XDG_CONFIG_HOME\nvim",
        "$env:XDG_CONFIG_HOME\nvim\autoload"
    )
)
Get-ChildItem -Recurse -Directory -Path "$PSScriptRoot\nvim" | ForEach-Object {
    $path = Join-Path $env:XDG_CONFIG_HOME (Resolve-Path -Relative -Path $_)
    $path = $path.Replace("\.\", "\")
    $null = $dirs.Add($path)
}
$dirs | ForEach-Object { New-Directory $_ }

# Create symbolic links
$links = [ordered]@{  # <link file to create> = <link target>
    # VIM
    "$env:USERPROFILE\_vim\vimrc"                 = "$PSScriptRoot\vimfiles\vimrc";
    "$env:USERPROFILE\_vim\common.vim"            = "$PSScriptRoot\vimfiles\common.vim";
    "$env:USERPROFILE\_vim\regular.vim"           = "$PSScriptRoot\vimfiles\regular.vim";
    "$env:USERPROFILE\_vim\autoload\plug.vim"     = "$PSScriptRoot\vimfiles\autoload\plug.vim";
    "$env:USERPROFILE\.vim\vimrc"                 = "$PSScriptRoot\vimfiles\vimrc";
    "$env:USERPROFILE\.vim\common.vim"            = "$PSScriptRoot\vimfiles\common.vim";
    "$env:USERPROFILE\.vim\regular.vim"           = "$PSScriptRoot\vimfiles\regular.vim";
    "$env:USERPROFILE\.vim\autoload\plug.vim"     = "$PSScriptRoot\vimfiles\autoload\plug.vim";
    "$env:USERPROFILE\vimfiles\vimrc"             = "$PSScriptRoot\vimfiles\vimrc";
    "$env:USERPROFILE\vimfiles\common.vim"        = "$PSScriptRoot\vimfiles\common.vim";
    "$env:USERPROFILE\vimfiles\regular.vim"       = "$PSScriptRoot\vimfiles\regular.vim";
    "$env:USERPROFILE\vimfiles\autoload\plug.vim" = "$PSScriptRoot\vimfiles\autoload\plug.vim";
    # Neovim
    "$env:XDG_CONFIG_HOME\nvim\vimrc"             = "$PSScriptRoot\vimfiles\vimrc";
    "$env:XDG_CONFIG_HOME\nvim\autoload\plug.vim" = "$PSScriptRoot\vimfiles\autoload\plug.vim";
}
(Get-LinkPathAndTarget -Source "$PSScriptRoot\nvim" -Destination "$env:XDG_CONFIG_HOME\nvim") `
| ForEach-Object {
    $target = $_[0]
    $path = $_[1]
    $links[$path] = $target
}
$links.GetEnumerator() | ForEach-Object { New-SymlinkFile -LinkTarget $_.Value -Path $_.Key }
