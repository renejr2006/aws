@echo off
mkdir c:\users\administrator\Downloads\prime95

set "sDir=\\10.230.136.14\Public\Rene\tests\"
set "logging=\\10.230.136.14\Public\Rene\Scripts\Personal\
set "logging1=\\10.230.136.14\Public\Rene\Scripts\Personal\
set "dDir=c:\users\administrator\Downloads\"
set "dDir1=c:\users\administrator\Downloads\prime95"
set "cmd=prime95.exe"

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

for /f "skip=1 tokens=2 delims==" %%P in ('wmic cpu get NumberOfLogicalProcessors /format:list') do (
	set /a logicalProcessors=%%P
)
echo Core Count Should be displayed in Prime95: %logicalProcessors% 
msg * "%logicalProcessors%"

pause

if not exist "%dDir1%" (
	echo directory "%dDir1%" does not exists
	exit /b
)

echo current directory being searched %dDir1%
set "found=false"
for /r "%dDir1%" %%d in (prime95.exe) do (
	if exist "%%d" (
		echo Found: %%d
		set "found=true"
		pushd "%%~dpd"
		copy "%sDir%\prime.txt" .\
		echo running command: !cmd!
		prime95.exe
		popd
		exit /b
	)
)

if "%found%"=="false" (
	echo prime95.exe not found
)
endlocal
