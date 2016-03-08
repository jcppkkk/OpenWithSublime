@echo off

SET elevate.CmdPath=%~dp0OpenWithSublime_elevate.cmd

call :check_Permissions

REM uninstall old version
SET entryName=Sublime
SET entryNameAsAdmin=Sublime As Admin
REG DELETE "HKEY_CLASSES_ROOT\*\shell\%entryName%" /f
REG DELETE "HKEY_CLASSES_ROOT\*\shell\%entryNameAsAdmin%" /f
REG DELETE "HKEY_CLASSES_ROOT\Folder\shell\%entryName%" /f

REM uninstall new version
SET entryName=Sublime Text
SET entryNameAsAdmin=Sublime Text As Admin
REG DELETE "HKEY_CLASSES_ROOT\*\shell\%entryName%" /f
REG DELETE "HKEY_CLASSES_ROOT\*\shell\%entryNameAsAdmin%" /f
REG DELETE "HKEY_CLASSES_ROOT\Folder\shell\%entryName%" /f


:check_Permissions
echo # Administrative permissions required. Detecting permissions...
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Administrative permissions confirmed.
    goto :EOF
) else (
    echo Failure: Current permissions inadequate. Try to get elevation...
    SET openwithsublime_elevation=1
    call "%elevate.CmdPath%" "%~fs0"
    exit
)
goto :EOF