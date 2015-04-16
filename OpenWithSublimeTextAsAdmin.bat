@echo off
@rem \"%stPath%\"   : Path to Sublime Text installation dir.
@rem %UserEntry%: Key name for the registry entry.
@rem %UserMenuText% : Context menu text. Set your preferred menu text (e.g.: translate to your language).
@rem %AdminEntry%: Key name for the registry entry.
@rem %AdminMenuText% : Context menu text. Set your preferred menu text for administrator privilege (e.g.: translate to your language).

SET stPath=%~dp0sublime_text.exe
SET UserEntry=Sublime Text
SET AdminEntry=Sublime Text As Admin
SET "UserMenuText=Open with Sublime(&-)"
SET "AdminMenuText=Open with Sublime As Admin(&+)"
SET file_elevate.cmd=%~dp0__elevate.cmd
SET file_elevate.vbs=%~dp0__elevate.vbs
SET file_uninstall.bat=%~dp0OpenWithSublimeText-uninstall.bat

if not exist "%file_elevate.cmd%" (
	call :download "https://gist.githubusercontent.com/jcppkkk/8330314/raw/3d863b0d5de7b47cb177f0571ffa232d27a3869e/__elevate.cmd" "%file_elevate.cmd%"
)
if not exist "%file_elevate.vbs%" (
	call :download "https://gist.githubusercontent.com/jcppkkk/8330314/raw/2b89b316d6af469db513a02d156c9a315d684fd0/__elevate.vbs" "%file_elevate.vbs%"
)
if not exist "%file_uninstall.bat%" (
	REM call :download "https://gist.githubusercontent.com/jcppkkk/8330314/raw/2b89b316d6af469db513a02d156c9a315d684fd0/__elevate.vbs" "%file_uninstall.bat%"
)

call :check_Permissions

echo # add it for all file types
reg add "HKEY_CLASSES_ROOT\*\shell\%UserEntry%"         /t REG_SZ /v "" /d "%UserMenuText%"   /f
reg add "HKEY_CLASSES_ROOT\*\shell\%UserEntry%"         /t REG_EXPAND_SZ /v "Icon" /d "\"%stPath%\",0" /f
reg add "HKEY_CLASSES_ROOT\*\shell\%UserEntry%\command" /t REG_SZ /v "" /d "\"%stPath%\" \"%%1\"" /f

echo # add it for all file types as admin
reg add "HKEY_CLASSES_ROOT\*\shell\%AdminEntry%"         /t REG_SZ /v "" /d "%AdminMenuText%"   /f
reg add "HKEY_CLASSES_ROOT\*\shell\%AdminEntry%"         /t REG_EXPAND_SZ /v "Icon" /d "\"%stPath%\",0" /f
reg add "HKEY_CLASSES_ROOT\*\shell\%AdminEntry%\command" /t REG_SZ /v "" /d "\"%file_elevate.cmd%\" \"%stPath%\" \"%%1\"" /f

echo # add it for folders
reg add "HKEY_CLASSES_ROOT\Folder\shell\%UserEntry%"         /t REG_SZ /v "" /d "%UserMenuText%" /f
reg add "HKEY_CLASSES_ROOT\Folder\shell\%UserEntry%"         /t REG_EXPAND_SZ /v "Icon" /d "\"%stPath%\",0" /f
reg add "HKEY_CLASSES_ROOT\Folder\shell\%UserEntry%\command" /t REG_SZ /v "" /d "\"%stPath%\" \"%%1\"" /f
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
    call "%file_elevate.cmd%" "%~fs0"
    exit
)
goto :EOF

:download
"C:\Windows\System32\WindowsPowerShell\v1.0\powershell" "$wc = New-Object System.Net.WebClient;$wc.DownloadFile('%1', '%2')"
echo %2
goto :EOF