@echo off
setlocal enabledelayexpansion

::Define Iteration
set "TOTAL_ITERATIONS=10"

:: Checking Iteration Marker
if exists C:\progress.txt (
	for /f %%i in (c:\progress.txt) do set "CURRENT_ITERATION=%%i"
) else (
	set "CURRENT_ITERATION=1"
)

:: Start Iteration
for /L %%i in (%CURRENT_ITERATION%,1%TOTAL_ITERATIONS%) do (
	
	:: Save Current Progress
	echo %%i > c:\progress.txt
	
	:: Insert Commands that need to run here
	
	
	:: Reboot the System
	echo Shutting down the System
	shutdown -r -t 00
	
	:: waiting for the system to Reboot
	timeout /t 60 /nobreak
)

::Cleanup Iteration Marker
del c:\progress.txt
echo Script Completed

endlocal
