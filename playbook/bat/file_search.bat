@echo off
setlocal enabledelayedexpansion

set "dDir1=C:\Users\Administrator\Downloads\FHC"
set "cmd=FHC.exe -r 1440"

if not exist "%dDir1%" (
	echo directory "%dDir1%" does not exists
	exit /b
)

echo current directory being searched %dDir1%
set "found=false"
for /r "%dDir1%" %%d in (FHC.exe) do (
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
	echo FHC.exe not found
)
pause
