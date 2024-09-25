@echo off
setlocal

for /f "tokens=2 delims==" %%T in ('wmic path Win32_Process get ThreadCount /format:list') do (
	set /a totalThreads+=%%T
)

echo %totalThreads%

endlocal
pause
