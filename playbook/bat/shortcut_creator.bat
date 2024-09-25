@echo off
set "exePath=c:\Program Files\7-Zip\7zFM.exe"
set "flag=-nethaspip=10.227.2.118 -nologo -timeout= 604800"
set "fullPath=%exePath% %flag%"
set "shortcutName=MG_3MIN"
set "shortcutPath=%USERPROFILE%\Desktop\%shortcutName%.lnk"

echo Set oShell = CreateObject("WScript.Shell") > %TEMP%\CreateShortcut.vbs
echo Set oLink = oShell.CreateShortcut("%shortcutPath%") >> %TEMP%\CreateShortcut.vbs
echo oLink.TargetPath = "%exePath%" >> %TEMP%\CreateShortcut.vbs
echo oLink.Arguments = "%flag%" >> %TEMP%\CreateShortcut.vbs
echo oLink.WorkingDirectory = oShell.CurrentDirectory >> %TEMP%\CreateShortcut.vbs
echo oLink.Save >> "%TEMP%\CreateShortcut.vbs

cscript //nologo %TEMP%\CreateShortcut.vbs
del "TEMP%\CreateShortcut.vbs"
