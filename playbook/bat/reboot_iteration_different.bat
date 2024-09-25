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

:: Check if port-Reboot run
if exists c:\post-reboot.flag (
	echo Post-reboot tasks are running..
	
	:: Determine the iteration from the marker file
	for /f %%i in (c:\progress.txt) do set "CURRENT_ITERATION=%%i"
	
	::Execute post-Reboot commands based on the iteration number
	call "run_post_reboot_tasks !CURRENT_ITERATION!
	
	:: Cleanup the flag file
	del c:\post-reboot.flag
	goto :EOF
	
:: Start Iteration
for /L %%i in (%CURRENT_ITERATION%,1%TOTAL_ITERATIONS%) do (
	echo Iteration %%i
	
	:: Save Current Progress
	echo %%i > c:\progress.txt
	
	:: Executre  pre-reboot commands based on the iteration number
	call :run_pre_reboot_tasks %%icacls
	
	:: Create a flag file indicating post-Reboot tasks
	echo This is a post-Reboot run > c:\post-reboot.flag
	
	:: waiting for the system to Reboot
	timeout /t 300 /nobreak
	echo welcome
	
	:: Reboot the System
	echo Shutting down the System
	shutdown -r -t 0
	
	:: waiting for the system to Reboot
	timeout /t 60 /nobreak
)

::Cleanup Iteration Marker
del c:\progress.txt
echo Script Completed

endlocal
goto :EOF

:run_pre_reboot_tasks
set "iteration=%1"
echo Running Pre-Reboot tasks for iteration %iteration%...
::Add specific commands based on iteration
set "%iteration%"=="1" (
	echo Performing Task 1...
	:: Insert Commands that need to run here
) else if "%iteration%"=="2" (
	echo Performing Task 2...
	:: Insert Commands that need to run here
) else if "%iteration%"=="3" (
	echo Performing Task 3...
	:: Insert Commands that need to run here
) else (
	echo Performing Default Task ...
	:: Insert Commands that need to run here
goto :EOF

:run_post_reboot_tasks
set "iteration=%1"
echo Running Post-Reboot tasks for iteration %iteration%...
::Add specific commands based on iteration
set "%iteration%"=="1" (
	echo Performing post-reboot Task 1...
	:: Insert Commands that need to run here
) else if "%iteration%"=="2" (
	echo Performing  post-reboot Task 2...
	:: Insert Commands that need to run here
) else if "%iteration%"=="3" (
	echo Performing  post-reboot Task 3...
	:: Insert Commands that need to run here
) else (
	echo Performing Default  post-reboot Task ...
	:: Insert Commands that need to run here
goto :EOF





