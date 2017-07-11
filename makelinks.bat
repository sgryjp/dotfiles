@echo off
setlocal EnableExtensions

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

call :MKLINK "%USERPROFILE%\_vimrc" "%ROOT%.vimrc"
call :MKDIR "%USERPROFILE%\_vim"
call :MKDIR "%USERPROFILE%\_vim\ftplugin"
for %%I in (.vim\ftplugin\*.vim) do (
    call :MKLINK "%USERPROFILE%\_vim\ftplugin\%%~nxI" "%%~fI"
)

:CLEANUP
del ".\makelinks.tmp" > NUL
popd
goto :EOF

REM ---------------------------------------------------------------------------
:MKLINK
    if exist "%~1" del /q "%~1"
    mklink "%~1" "%~2" > NUL
    echo New link: %~1
    exit /b 0

:MKDIR
    if not exist "%~1" (
        mkdir "%~1"
        echo New dir: %~1
    )
    exit /b 0
