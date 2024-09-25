@echo off

if [%1] == [] goto ouch

set syssrch="bugcheck whea fatal"
set wheasrch="event"
set logfile=log-checkandclear.log
if %1 == check goto check
if %1 == clear goto clear
goto ouch

:check
set fail=0
echo Checking for WHEA log errors. Please wait.
wevtutil.exe qe Microsoft-Windows-Kernel-WHEA/Errors /f:text|findstr /i %wheasrch% > nul
if %errorlevel% equ 0 (
	echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	echo FAIL: WHEA ERROR DETECTED!
	echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXX >> %logfile%
	echo FAIL: WHEA ERROR DETECTED! >> %logfile%
	echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXX >> %logfile%
	wevtutil.exe qe Microsoft-Windows-Kernel-WHEA/Errors >> %logfile%
	set fail=1
)
echo Checking for system log errors. Please wait.
wevtutil.exe qe System  /f:text|findstr /i %syssrch%  > nul
if %errorlevel% equ 0 (
	echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	echo FAIL: SYSTEM ERROR DETECTED!
	echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX >> %logfile%
	echo FAIL: SYSTEM ERROR DETECTED! >> %logfile%
	echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX >> %logfile%
	wevtutil.exe qe System |findstr /i %syssrch% >> %logfile%
	set fail=1
)
if %fail% equ 1 goto fail
echo No errors were detected it is safe to clear the logs.
pause
exit /b

:clear
echo Clearing all of the event logs.
for /f "tokens=*" %%E in ('wevtutil.exe el') do (wevtutil.exe cl "%%E" > nul 2>&1)
del c:\Windows\System32\winevt\Logs\Archive-*  > nul
echo The event logs have been cleared.
exit /b 

:ouch
echo Usage:
echo   To check the logs for errors:
echo     log-checkandclear.bat check
echo   To clear the logs:
echo     log-checkandclear.bat clear
exit /b

:fail
echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
echo Errors were detected in the logs.
echo Check your logs before clearing them.
echo Check %logfile%
echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
exit /b

