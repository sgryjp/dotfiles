@echo off
setlocal

REM ---------------------------------------------------------------------------
set ROOT=%~dp0
if not exist "%USERPROFILE%" (
    echo [Error] Environment variable %%USERPROFILE%% is not set.
    goto :CLEANUP
)

REM ---------------------------------------------------------------------------
pushd "%ROOT%"

REM Check access priviledge
if exist ".\makelinks.tmp" del ".\makelinks.tmp"
(mklink ".\makelinks.tmp" "%~0" 2>&1) > NUL
if not %ERRORLEVEL% == 0 (
    echo Administrator priviledge needed.
    goto :CLEANUP
)

set DOTVIM=.vim
call :MAIN
set DOTVIM=_vim
call :MAIN

:CLEANUP
del ".\makelinks.tmp" > NUL
popd
goto :EOF

REM ---------------------------------------------------------------------------
:MAIN
    call :MAKE_SYMLINK "%USERPROFILE%\%DOTVIM%rc" "%ROOT%.vimrc"
    call :ENSURE_DIR "%USERPROFILE%\%DOTVIM%"
    call :ENSURE_DIR "%USERPROFILE%\%DOTVIM%\ftplugin"
    for %%I in (.vim\ftplugin\*.vim) do (
        call :MAKE_SYMLINK "%USERPROFILE%\%DOTVIM%\ftplugin\%%~nxI" "%%~fI"
    )
    exit /b 0

:MAKE_SYMLINK
    del /q "%~1" 2> NUL
    mklink "%~f1" "%~f2" > NUL
    echo mklink "%~f1" "%~f2"
    exit /b 0

:ENSURE_DIR
    if not exist "%~1" (
        mkdir "%~1"
        echo mkdir "%~f1"
    )
    exit /b 0
