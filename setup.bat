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
    echo Failed to create symbolic link
    goto :EOF
)
del ".\makelinks.tmp" 2> NUL

call :COPY "%BATDIR%git/config" "%USERPROFILE%\.gitconfig"
call :COPY "%BATDIR%git/ignore" "%USERPROFILE%\.gitignore"

call :MKDIR "%USERPROFILE%\_vim\autoload"
call :MKLINK "%USERPROFILE%\_vim\vimrc"                 "%BATDIR%vimfiles\vimrc"
call :MKLINK "%USERPROFILE%\_vim\coc-settings.json"     "%BATDIR%vimfiles\coc-settings.json"
call :MKLINK "%USERPROFILE%\_vim\autoload\plug.vim"     "%BATDIR%vimfiles\autoload\plug.vim"
call :MKDIR "%USERPROFILE%\.vim\autoload"
call :MKLINK "%USERPROFILE%\.vim\vimrc"                 "%BATDIR%vimfiles\vimrc"
call :MKLINK "%USERPROFILE%\.vim\coc-settings.json"     "%BATDIR%vimfiles\coc-settings.json"
call :MKLINK "%USERPROFILE%\.vim\autoload\plug.vim"     "%BATDIR%vimfiles\autoload\plug.vim"
call :MKDIR "%USERPROFILE%\vimfiles\autoload"
call :MKLINK "%USERPROFILE%\vimfiles\vimrc"             "%BATDIR%vimfiles\vimrc"
call :MKLINK "%USERPROFILE%\vimfiles\coc-settings.json" "%BATDIR%vimfiles\coc-settings.json"
call :MKLINK "%USERPROFILE%\vimfiles\autoload\plug.vim" "%BATDIR%vimfiles\autoload\plug.vim"

call :MKDIR "%USERPROFILE%\.config\nvim"
call :MKLINK "%USERPROFILE%\.config\nvim\init.vim"      "%BATDIR%nvim\init.vim"
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
