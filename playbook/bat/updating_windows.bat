@echo off
if not "%1"=="am_admin" (
	powershell -Command "Start-Process cmd -ArgumentList '/c %~f0 am_admin' -Verb RunAs"
	exit /bcdedit
)

set "psScriptPath=c:\users\administrator\Desktop\Updating_Windows.ps1"

powershell -ExecutionPolicy Bypass -File "%psScriptPath%"
