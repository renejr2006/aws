
set "shortcutPath=%CD%\Desktop\test.lnk"
set "targetPath=%CD%\Desktop\test.bat"
set "workingDir=%CD%\Desktop"

echo Set oWS = WScript.CreateObject("WScript.Shell")> "%temp%\createShortcut.vbs"
echo sLinkFile = "%shortcutPath%" >> "%temp%\createShortcut.vbs"
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> "%temp%\createShortcut.vbs"
echo oLink.TargetPath = "%targetPath%" >> "%temp%\createShortcut.vbs"
echo oLink.WorkingDirectory = "%workingDir%" >> "%temp%\createShortcut.vbs"
echo oLink.Save >> "%temp%\createShortcut.vbs"

cscript "%temp%\createShortcut.vbs"

del "%temp%\createShortcut.vbs"
