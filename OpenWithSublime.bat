@echo off
:: Path to Sublime Text installation dir.
SET "stPath=%~dp0sublime_text.exe"
SET "stPathOnly=%~dp0"
:: Key name for the registry entries.
SET "UserEntry=Sublime Text"
SET "AdminEntry=Sublime Text As Admin"
:: Context menu texts.
SET "UserMenuText=Open with Sublime(&-)"
SET "AdminMenuText=Open with Sublime As Admin(&+)"

SET GIST_WORKSPACE=https://raw.githubusercontent.com/jcppkkk/OpenWithSublime/master
SET F_ELEVATE_CMD=OpenWithSublime_elevate.cmd
SET F_ELEVATE_VBS=OpenWithSublime_elevate.vbs
SET F_UNINSTALL=OpenWithSublime_uninstall.bat
call :download %GIST_WORKSPACE%/%F_ELEVATE_CMD% %F_ELEVATE_CMD%
call :download %GIST_WORKSPACE%/%F_ELEVATE_VBS% %F_ELEVATE_VBS%
call :download %GIST_WORKSPACE%/%F_UNINSTALL% %F_UNINSTALL%
call :check_Permissions

echo ===================================
echo Add context menu entry for all file types
SET REG_BASE=HKEY_CLASSES_ROOT\*\shell\%UserEntry%
reg add "%REG_BASE%"            /t REG_SZ           /v ""       /d "%UserMenuText%"         /f
reg add "%REG_BASE%"            /t REG_EXPAND_SZ    /v "Icon"   /d "\"%stPath%\",0"         /f
reg add "%REG_BASE%\command"    /t REG_SZ           /v ""       /d "\"%stPath%\" \"%%1\""   /f
echo Add context menu entry for all file types, open as admin
SET REG_BASE=HKEY_CLASSES_ROOT\*\shell\%AdminEntry%
reg add "%REG_BASE%"            /t REG_SZ           /v ""       /d "%AdminMenuText%"        /f
reg add "%REG_BASE%"            /t REG_EXPAND_SZ    /v "Icon"   /d "\"%stPath%\",0"         /f
reg add "%REG_BASE%\command"    /t REG_SZ           /v ""       /d "\"%stPathOnly%%F_ELEVATE_CMD%\" \"%stPath%\" \"%%1\"" /f

echo ===================================
echo Add context menu entry for folders
SET REG_BASE=HKEY_CLASSES_ROOT\Directory\shell\%UserEntry%
reg add "%REG_BASE%"            /t REG_SZ           /v ""       /d "%UserMenuText%"         /f
reg add "%REG_BASE%"            /t REG_EXPAND_SZ    /v "Icon"   /d "\"%stPath%\",0"         /f
reg add "%REG_BASE%\command"    /t REG_SZ           /v ""       /d "\"%stPath%\" \"%%1\""   /f
echo Add context menu entry for directories background
SET REG_BASE=HKEY_CLASSES_ROOT\Directory\Background\shell\%UserEntry%
@reg add "%REG_BASE%"           /t REG_SZ           /v ""       /d "%UserMenuText%"         /f
@reg add "%REG_BASE%"           /t REG_EXPAND_SZ    /v "Icon"   /d "\"%stPath%\",0"         /f
@reg add "%REG_BASE%\command"   /t REG_SZ           /v ""       /d "\"%stPath%\" \"%%V\""   /f

echo ===================================
echo All done! press any key to leave.
echo ===================================
pause
goto :EOF

:check_Permissions
echo # Administrative permissions required. Detecting permissions...
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Administrative permissions confirmed.
    goto :EOF
) else (
    echo Failure: Current permissions inadequate. Try to get elevation...
    SET openwithsublime_elevation=1
    call "%F_ELEVATE_CMD%" "%~fs0"
    exit
)

:download
if not exist "%CD%\%2" (
    C:\Windows\System32\WindowsPowerShell\v1.0\powershell "$wc = New-Object System.Net.WebClient;$wc.DownloadFile(\"%1\", \"%2\")"
    echo Download %2
)
goto :EOF
