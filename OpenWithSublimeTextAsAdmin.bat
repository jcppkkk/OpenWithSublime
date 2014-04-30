@echo off
@rem ==================
@rem Source:  
@rem     https://gist.github.com/jcppkkk/8330314
@rem Description: 
@rem     Install context menu to allow user opens file with Sublime Text as User or Admin, or Open Folder with Sublime Text.
@rem Usage:
@rem     Download this .bat file to in Sublime Text's installation folder.
@rem     Execute this batch file. It will download elevate codes and setup context menu.
@rem ==================
@rem \"%stPath%\"   : Path to Sublime Text installation dir.
@rem %entryName%: Key name for the registry entry.
@rem %menuText% : Context menu text. Set your preferred menu text (e.g.: translate to your language).
@rem %entryNameAsAdmin%: Key name for the registry entry.
@rem %menuTextAsAdmin% : Context menu text. Set your preferred menu text for administrator privilege (e.g.: translate to your language).

SET stPath=%~dp0sublime_text.exe
SET entryName=Sublime Text
SET menuText=Open with Sublime Text
SET entryNameAsAdmin=Sublime Text As Admin
SET menuTextAsAdmin=Open with Sublime Text As Admin
SET elevate.CmdPath=%~dp0__elevate.cmd
SET elevate.VbsPath=%~dp0__elevate.vbs

echo # Administrative permissions required. Detecting permissions...
call :check_Permissions

echo # add it for all file types
reg add "HKEY_CLASSES_ROOT\*\shell\%entryName%"         /t REG_SZ /v "" /d "%menuText%"   /f
reg add "HKEY_CLASSES_ROOT\*\shell\%entryName%"         /t REG_EXPAND_SZ /v "Icon" /d "\"%stPath%\",0" /f
reg add "HKEY_CLASSES_ROOT\*\shell\%entryName%\command" /t REG_SZ /v "" /d "\"%stPath%\" \"%%1\"" /f

echo # Download elevate scripts
call :download "https://gist.github.com/jcppkkk/8330314/raw/3d863b0d5de7b47cb177f0571ffa232d27a3869e/__elevate.cmd" "%elevate.CmdPath%"
call :download "https://gist.github.com/jcppkkk/8330314/raw/2b89b316d6af469db513a02d156c9a315d684fd0/__elevate.vbs" "%elevate.VbsPath%"

echo # add it for all file types as admin
reg add "HKEY_CLASSES_ROOT\*\shell\%entryNameAsAdmin%"         /t REG_SZ /v "" /d "%menuTextAsAdmin%"   /f
reg add "HKEY_CLASSES_ROOT\*\shell\%entryNameAsAdmin%"         /t REG_EXPAND_SZ /v "Icon" /d "\"%stPath%\",0" /f
reg add "HKEY_CLASSES_ROOT\*\shell\%entryNameAsAdmin%\command" /t REG_SZ /v "" /d "\"%elevate.CmdPath%\" \"%stPath%\" \"%%1\"" /f

echo # add it for folders
reg add "HKEY_CLASSES_ROOT\Folder\shell\%entryName%"         /t REG_SZ /v "" /d "%menuText%" /f
reg add "HKEY_CLASSES_ROOT\Folder\shell\%entryName%"         /t REG_EXPAND_SZ /v "Icon" /d "\"%stPath%\",0" /f
reg add "HKEY_CLASSES_ROOT\Folder\shell\%entryName%\command" /t REG_SZ /v "" /d "\"%stPath%\" \"%%1\"" /f
pause
goto :EOF


:check_Permissions
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Administrative permissions confirmed.
    goto :EOF
) else (
    echo Failure: Current permissions inadequate.
    echo You will need to "Run as Administrator" if using Vista/Win7/Win8.
    pause >nul
    exit
)
goto :EOF


:download 
@"C:\Windows\System32\WindowsPowerShell\v1.0\powershell" "$wc = New-Object System.Net.WebClient;$wc.DownloadFile('%1', '%2')"
@echo %2
@goto :EOF