@echo off
setlocal

set outputDir=C:\EventLogs
for /f "delims=" %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HH.mm.ss"') do set timestamp=%%i

set applicationLogFile=%outputDir%\ApplicationLog_%timestamp%.evtx
set securityLogFile=%outputDir%\securityLog_%timestamp%.evtx
set setupLogFile=%outputDir%\setupLog_%timestamp%.evtx
set systemLogFile=%outputDir%\SystemLog_%timestamp%.evtx

if not exist %outputDir% mkdir %outputDir%

rem wevtutil epl Application %applicationLogFile%
rem wevtutil epl Security %securityLogFile%
rem wevtutil epl Setup %setupLogFile%
wevtutil epl System %systemLogFile%

echo Event Logs Exported to %outputDir% with timestamp %timestamp%
endlocal
pause
