@echo off
setlocal EnableExtensions

set BATDIR=%~dp0
if not exist "%USERPROFILE%" (
    echo [Error] Environment variable %%USERPROFILE%% is not set.
    goto :EOF
)

REM Check access priviledge
if exist "%TEMP%\makelinks.tmp" del "%TEMP%\makelinks.tmp"
(mklink "%TEMP%\makelinks.tmp" "%~0" 2>&1) > NUL
if not %ERRORLEVEL% == 0 (
    echo Failed to create a symbolic link
    goto :EOF
)
del ".\makelinks.tmp" 2> NUL

REM Git configurations
git config --global include.path "%BATDIR%git\config"
call :COPY "%BATDIR%git/ignore" "%USERPROFILE%\.gitignore"

REM VIM configurations
call :MKDIR "%USERPROFILE%\_vim\autoload"
call :MKLINK "%USERPROFILE%\_vim\vimrc"                 "%BATDIR%vimfiles\vimrc"
call :MKLINK "%USERPROFILE%\_vim\autoload\plug.vim"     "%BATDIR%vimfiles\autoload\plug.vim"
call :MKDIR "%USERPROFILE%\.vim\autoload"
call :MKLINK "%USERPROFILE%\.vim\vimrc"                 "%BATDIR%vimfiles\vimrc"
call :MKLINK "%USERPROFILE%\.vim\autoload\plug.vim"     "%BATDIR%vimfiles\autoload\plug.vim"
call :MKDIR "%USERPROFILE%\vimfiles\autoload"
call :MKLINK "%USERPROFILE%\vimfiles\vimrc"             "%BATDIR%vimfiles\vimrc"
call :MKLINK "%USERPROFILE%\vimfiles\autoload\plug.vim" "%BATDIR%vimfiles\autoload\plug.vim"

REM Neovim configurations
call :MKDIR "%USERPROFILE%\.config\nvim\autoload"
call :MKDIR "%USERPROFILE%\.config\nvim\lua\plugins"
call :MKLINK "%USERPROFILE%\.config\nvim\init.lua"                  "%BATDIR%nvim\init.lua"
call :MKLINK "%USERPROFILE%\.config\nvim\vimrc"                     "%BATDIR%vimfiles\vimrc"
call :MKLINK "%USERPROFILE%\.config\nvim\autoload\plug.vim"         "%BATDIR%vimfiles\autoload\plug.vim"
call :MKLINK "%USERPROFILE%\.config\nvim\lua\plugins\cmp.lua"       "%BATDIR%nvim\lua\plugins\cmp.lua"
call :MKLINK "%USERPROFILE%\.config\nvim\lua\plugins\lualine.lua"   "%BATDIR%nvim\lua\plugins\lualine.lua"
call :MKLINK "%USERPROFILE%\.config\nvim\lua\plugins\null-ls.lua"   "%BATDIR%nvim\lua\plugins\null-ls.lua"
call :MKLINK "%USERPROFILE%\.config\nvim\lua\plugins\nvim-lsp-installer.lua" "%BATDIR%nvim\lua\plugins\nvim-lsp-installer.lua"
call :MKLINK "%USERPROFILE%\.config\nvim\lua\plugins\nvim-tree.lua" "%BATDIR%nvim\lua\plugins\nvim-tree.lua"
call :MKLINK "%USERPROFILE%\.config\nvim\lua\plugins\telescope.lua" "%BATDIR%nvim\lua\plugins\telescope.lua"
goto :EOF


REM ---------------------------------------------------------------------------
:COPY
    set SRC=%~f1
    set DEST=%~f2
    if not exist "%DEST%" (
        echo copy "%SRC%" "%DEST%"
        copy "%SRC%" "%DEST%" > NUL
    )
    exit /b 0

:MKLINK
    set DEST=%~f1
    set SRC=%~f2
    if exist "%DEST%" del /q "%DEST%"
    echo mklink "%DEST%" "%SRC%"
    mklink "%DEST%" "%SRC%" > NUL
    exit /b 0

:MKDIR
    if not exist "%~f1" (
        echo mkdir "%~f1"
        mkdir "%~f1"
    )
    exit /b 0
