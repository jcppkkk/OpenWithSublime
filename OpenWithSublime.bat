@echo off
:: Path to Sublime Text installation dir.
SET stPath=%~dp0sublime_text.exe
:: Key name for the registry entries.
SET UserEntry=Sublime Text
SET AdminEntry=Sublime Text As Admin
:: Context menu texts.
SET "UserMenuText=Open with Sublime(&-)"
SET "AdminMenuText=Open with Sublime As Admin(&+)"

SET GIST_WORKSPACE=https://gist.github.com/jcppkkk/8330314/raw/641713dc4a4338f1c466c1d4802572bc663fef9f
SET F_ELEVATE_CMD=%~dp0OpenWithSublime_elevate.cmd
SET F_ELEVATE_VBS=%~dp0OpenWithSublime_elevate.vbs
SET F_UNINSTALL=%~dp0OpenWithSublime_uninstall.bat
call :download "%GIST_WORKSPACE%/OpenWithSublime_elevate.cmd" "%F_ELEVATE_CMD%"
call :download "%GIST_WORKSPACE%/OpenWithSublime_elevate.vbs" "%F_ELEVATE_VBS%"
call :download "%GIST_WORKSPACE%/OpenWithSublime_uninstall.bat" "%F_UNINSTALL%"
call :check_Permissions

echo ===================================
echo Add context menu entry for all file types
SET REG_BASE=HKEY_CLASSES_ROOT\*\shell\%UserEntry%
reg add "%REG_BASE%"            /t REG_SZ           /v ""       /d "%UserMenuText%"         /f
reg add "%REG_BASE%"            /t REG_EXPAND_SZ    /v "Icon"   /d "\"%stPath%\",0"         /f
reg add "%REG_BASE%\command"    /t REG_SZ           /v ""       /d "\"%stPath%\" \"%%1\""   /f

echo ===================================
echo Add context menu entry for all file types, open as admin
SET REG_BASE=HKEY_CLASSES_ROOT\*\shell\%UserEntry%\%AdminEntry%
reg add "%REG_BASE%"           /t REG_SZ          /v ""       /d "%AdminMenuText%"        /f
reg add "%REG_BASE%"           /t REG_EXPAND_SZ   /v "Icon"   /d "\"%stPath%\",0"         /f
reg add "%REG_BASE%\command"   /t REG_SZ          /v ""       /d "\"%F_ELEVATE_CMD%\" \"%stPath%\" \"%%1\"" /f
echo ===================================

SET REG_BASE=HKEY_CLASSES_ROOT\Folder\shell\%UserEntry%
echo Add context menu entry for folders
reg add "%REG_BASE%"           /t REG_SZ          /v ""       /d "%UserMenuText%"         /f
reg add "%REG_BASE%"           /t REG_EXPAND_SZ   /v "Icon"   /d "\"%stPath%\",0"         /f
reg add "%REG_BASE%\command"   /t REG_SZ          /v ""       /d "\"%stPath%\" \"%%1\""   /f

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
if not exist %2 (
	"C:\Windows\System32\WindowsPowerShell\v1.0\powershell" "$wc = New-Object System.Net.WebClient;$wc.DownloadFile('%1', '%2')"
	echo Download %2
)
goto :EOF