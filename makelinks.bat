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

call :MAIN "%USERPROFILE%\vimfiles\"
goto :EOF


REM ---------------------------------------------------------------------------
:MAIN
    set DOTVIM=%~f1
    call :MKDIR  "%DOTVIM%"
    call :MKLINK "%DOTVIM%vimrc" "%BATDIR%.vim\vimrc"
    call :MKDIR  "%DOTVIM%autoload"
    call :MKLINK "%DOTVIM%autoload\plug.vim" "%BATDIR%.vim\autoload\plug.vim"
    call :MKDIR  "%DOTVIM%ftplugin"
    for %%I in (%BATDIR%.vim\ftplugin\*.vim) do (
        call :MKLINK "%DOTVIM%ftplugin\%%~nxI" "%%~fI"
    )
    exit /b 0

:MKLINK
    set DEST=%~f1
    set SRC=%~f2
    if exist "%DEST%" del /q "%DEST%"
    mklink "%DEST%" "%SRC%" > NUL
    echo mklink "%DEST%" "%SRC%"
    exit /b 0

:MKDIR
    if not exist "%~f1" (
        mkdir "%~f1"
        echo mkdir "%~f1"
    ) else (
        echo mkdir "%~f1" ^(skip^)
    )
    exit /b 0
