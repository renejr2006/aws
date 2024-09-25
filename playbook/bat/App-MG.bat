
@echo off
setlocal enabledelayexpansion
mkdir c:\users\administrator\Downloads\mg

set "sDir=\\10.230.136.14\Public\Rene\test\"
set "logging=\\10.230.136.14\Public\Rene\Scripts\Personal\
set "logging1=\\10.230.136.14\Public\Rene\Scripts\Personal\
set "dDir=c:\users\administrator\Downloads\"
set "dDir1=c:\users\administrator\Downloads\mg"
set "basePath=C:\Program Files\ETD x86-64 Secure Windows Meatgrinder"

copy "%sDir%/*.zip" "%dDir%"
copy "%logging%\Windows_Export-Logs.bat" "%dDir1%"
copy "%logging1%\log-checkandclear.bat" "%dDir1%"

cd %dDir%
for %%f in (*.zip) do (
 	powershell -command "Expand-Archive -Path '%%f' -DestinationPath '%dDir1%\%%~nf'"
 	echo Extracted: %%f
)

call %dDir1%\Windows_Export-Logs.bat
call %dDir1%\log-checkandclear.bat check
call %dDir1%\log-checkandclear.bat clear

echo -----------------------------------------
if not exist "%dDir1%" (
	echo directory "%dDir1%" does not exists
	exit /b
)

echo current directory being searched %dDir1%
set "found=false"
for /r "%dDir1%" %%f in (*.msi) do (
	echo Found MSI: %%f
	set "msiFile=%%f"
	goto :executeMSI
)

echo No MSI file found in %dDir1%
goto :end

:executeMSI
echo Excuting %%msiFile%%
msiexec /i "%msiFile%" /qn /norestart
goto :end

:end


rem create shortcut
for /d %%i in ("%basePath%*") do (
	set "exePath=%%i\etdntmg.exe"
	set "workingDir=%%i"
)
copy "%sDir%\tests.ini" "%workingDir%

set "flag=-nethaspip=10.228.86.80 -nologo -timeout=604800 -ini=""%workingDir%\tests.ini"" -start"
set "fullPath=%exePath% %flag%"

set "shortcutName=MG_1Week"
set "shortcutPath=%USERPROFILE%\Desktop\%shortcutName%.lnk"

echo Set oShell = CreateObject("WScript.Shell") > %TEMP%\CreateShortcut.vbs
echo Set oLink = oShell.CreateShortcut("%shortcutPath%") >> %TEMP%\CreateShortcut.vbs
echo oLink.TargetPath = "%exePath%" >> %TEMP%\CreateShortcut.vbs
echo oLink.Arguments = "%flag%" >> %TEMP%\CreateShortcut.vbs
echo oLink.WorkingDirectory = "%workingDir%" >> %TEMP%\CreateShortcut.vbs
echo oLink.Save >> "%TEMP%\CreateShortcut.vbs

cscript //nologo %TEMP%\CreateShortcut.vbs
del "%TEMP%\CreateShortcut.vbs



start "%USERPROFILE%\Desktop\MG\MG_1Week.lnk" "%shortcutPath%"
start "%USERPROFILE%\Desktop\MG\MG_1Week.lnk" "%shortcutPath%"
endlocal
