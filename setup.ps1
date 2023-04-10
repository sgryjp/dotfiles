#Requires -Version 5.1
[CmdletBinding()]
param ()

function New-Directory {
    param (
        [string]$path
    )
    $path = "$env:USERPROFILE\$path"
    Write-Verbose "mkdir $path"
    if (-not (Test-Path -Path $path -PathType Container)) {
        New-Item -ItemType Directory $path
    }
}

function New-SymlinkFile {
    param (
        [string]$target
    )
    $target = "$PSScriptRoot\$target"
    $path = $env:USERPROFILE + "\" + $args[0]
    Write-Verbose "ln -s $target $path"
    if (-not (Test-Path -Path $path)) {
        New-Item -Verbose -ItemType SymbolicLink -Path $path -Target $target
    }
}

# Git configurations
git config --global include.path $PSScriptRoot\git\config
Copy-Item "$PSScriptRoot\git\ignore" "$env:USERPROFILE\.gitignore"

# VIM configurations
New-Directory "_vim\autoload"
New-SymLinkFile -Target "vimfiles\vimrc"                "_vim\vimrc"
New-SymlinkFile -Target "vimfiles\autoload\plug.vim"    "_vim\autoload\plug.vim"
New-Directory ".vim\autoload"
New-SymlinkFile -Target "vimfiles\vimrc"                ".vim\vimrc"
New-SymlinkFile -Target "vimfiles\autoload\plug.vim"    ".vim\autoload\plug.vim"
New-Directory "vimfiles\autoload"
New-SymlinkFile -Target "vimfiles\vimrc"                "vimfiles\vimrc"
New-SymlinkFile -Target "vimfiles\autoload\plug.vim"    "vimfiles\autoload\plug.vim"

# # Neovim configurations
New-Directory ".config\nvim\autoload"
New-Directory ".config\nvim\lua\plugins"
New-SymlinkFile -Target "nvim\init.lua"                 ".config\nvim\init.lua"
New-SymlinkFile -Target "vimfiles\vimrc"                ".config\nvim\vimrc"
New-SymlinkFile -Target "vimfiles\autoload\plug.vim"    ".config\nvim\autoload\plug.vim"
New-SymlinkFile -Target "nvim\lua\plugins\cmp.lua"      ".config\nvim\lua\plugins\cmp.lua"
New-SymlinkFile -Target "nvim\lua\plugins\lualine.lua"  ".config\nvim\lua\plugins\lualine.lua"
New-SymlinkFile -Target "nvim\lua\plugins\null-ls.lua"  ".config\nvim\lua\plugins\null-ls.lua"
New-SymlinkFile -Target "nvim\lua\plugins\nvim-lsp-installer.lua" ".config\nvim\lua\plugins\nvim-lsp-installer.lua"
New-SymlinkFile -Target "nvim\lua\plugins\nvim-tree.lua"    ".config\nvim\lua\plugins\nvim-tree.lua"
New-SymlinkFile -Target "nvim\lua\plugins\telescope.lua"    ".config\nvim\lua\plugins\telescope.lua"
