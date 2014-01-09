@echo off
@rem %stPath%   : Path to Sublime Text installation dir.
@rem %elevatePath%   : Path to elevated privilege script installation dir.
@rem %entryName%: Key name for the registry entry.
@rem %menuText% : Context menu text. Set your preferred menu text (e.g.: translate to your language).
@rem %entryNameAsAdmin%: Key name for the registry entry.
@rem %menuTextAsAdmin% : Context menu text. Set your preferred menu text for administrator privilege (e.g.: translate to your language).

call :check_Permissions

SET stPath=\"%~dp0sublime_text.exe\"
SET elevatePath=\"%~dp0__elevate.cmd\"
SET entryName=Sublime Text
SET menuText=Open with Sublime Text
SET entryNameAsAdmin=Sublime Text As Admin
SET menuTextAsAdmin=Open with Sublime Text As Admin

echo # add it for all file types
reg add "HKEY_CLASSES_ROOT\*\shell\%entryName%"         /t REG_SZ /v "" /d "%menuText%"   /f
reg add "HKEY_CLASSES_ROOT\*\shell\%entryName%"         /t REG_EXPAND_SZ /v "Icon" /d "%stPath%,0" /f
reg add "HKEY_CLASSES_ROOT\*\shell\%entryName%\command" /t REG_SZ /v "" /d "%stPath% \"%%1\"" /f

echo # add it for all file types as admin. You need to close all sublime instance inorder to open target with Administrative permission.
reg add "HKEY_CLASSES_ROOT\*\shell\%entryNameAsAdmin%"         /t REG_SZ /v "" /d "%menuTextAsAdmin%"   /f
reg add "HKEY_CLASSES_ROOT\*\shell\%entryNameAsAdmin%"         /t REG_EXPAND_SZ /v "Icon" /d "%stPath%,0" /f
reg add "HKEY_CLASSES_ROOT\*\shell\%entryNameAsAdmin%\command" /t REG_SZ /v "" /d "%elevatePath% %stPath% -n \"%%1\"" /f

echo # add it for folders
reg add "HKEY_CLASSES_ROOT\Folder\shell\%entryName%"         /t REG_SZ /v "" /d "%menuText%" /f
reg add "HKEY_CLASSES_ROOT\Folder\shell\%entryName%"         /t REG_EXPAND_SZ /v "Icon" /d "%stPath%,0" /f
reg add "HKEY_CLASSES_ROOT\Folder\shell\%entryName%\command" /t REG_SZ /v "" /d "%stPath% \"%%1\"" /f
pause
goto :EOF


:check_Permissions
echo # Administrative permissions required. Detecting permissions...

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