@echo off
setlocal enableddelayedexpansion

set "sDir=\\10.230.136.14\Personal\menu"

:SUBMENU
cls
echo ************************************************************************
echo *                                                                      *
echo *                       Windows Stress Test MENU                       *
echo *                                                                      *
echo ************************************************************************
echo 0. Setup AZ PC Turin
echo 1. Setup AZ PC Genoa
echo 2. Setup AZ PC Milan
echo m. Main Menu
echo x. Exit
set /p choice=Select an Option:

if "%choice%"=="0" goto Turin
if "%choice%"=="1" goto Genoa
if "%choice%"=="2" goto Milan
if "%choice%"=="m" goto Main
if "%choice%"=="x" goto Exit

:Turin
echo Turin
set "psScriptPath0=%sDir%\setup-az-pc-turin.ps1"
powershell -ExecutionPolicy Bypass -File "%psScriptPath0%"
goto SUBMENU

:Genoa
echo Genoa
set "psScriptPath1=%sDir%\setup-az-pc-genoa.ps1"
powershell -ExecutionPolicy Bypass -File "%psScriptPath1%"
goto SUBMENU

:Milan
echo Milan
set "psScriptPath2=%sDir%\setup-az-pc-milan.ps1"
powershell -ExecutionPolicy Bypass -File "%psScriptPath2%"
goto SUBMENU

:Main
call \\10.230.136.14\Public\Rene\Scripts\Personal\menu\menu.bat
exit

:Exit
echo Exiting...
exit
