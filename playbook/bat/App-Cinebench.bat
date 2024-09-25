@echo off
setlocal enabledelayedexpansion

mkdir c:\users\administrator\Downloads\Cinebench

set "sDir=\\10.230.136.14\Public\Rene\test\"
set "logging=\\10.230.136.14\Public\Rene\Scripts\Personal\
set "logging1=\\10.230.136.14\Public\Rene\Scripts\Personal\
set "dDir=c:\users\administrator\Downloads\"
set "dDir1=c:\users\administrator\Downloads\Cinebench"
set "cmd=Cinebench.exe g_CinebenchCpuXTest=true"
rem C:\Users\Administrator\Desktop\Cinebench\Cinebench.exe g_CinebenchCpuXTest=true >> Cinebench_Output.txt

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

pause

if not exist "%dDir1%" (
	echo directory "%dDir1%" does not exists
	exit /b
)

echo current directory being searched %dDir1%
set "found=false"
for /r "%dDir1%" %%d in (Cinebench.exe) do (
	if exist "%%d" (
		echo Found: %%d
		set "found=true"
		pushd "%%~dpd"
		echo running command: !cmd!
		!cmd!
		popd
		exit /b
	)
)

if "%found%"=="false" (
	echo Cinebench.exe not found
)
endlocal
