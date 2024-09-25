@echo off
setlocal enabledelayedexpansion
if not "%1"=="am_admin" (
	powershell -Command "Start-Process cmd -ArgumentList '/c %~f0 am_admin' -Verb RunAs"
	exit /bcdedit
)

set "sDir=\\10.230.136.14\Personal\menu"

:MENU
cls
echo ************************************************************************
echo *                                                                      *
echo *                       Windows Stress Test MENU                       *
echo *                                                                      *
echo ************************************************************************
echo 0. Windows Setup
echo 1. Cinebench
echo 2. FHC
echo 3. HP MeatGrinder
echo 4. IOMeter
echo 5. Prime95
echo 6. ??
echo 7. ??
echo 8. ??
echo x. Exit
set /p choice=Select an Option: 

if "%choice%"=="0" goto setup
if "%choice%"=="1" goto cinebench
if "%choice%"=="2" goto fhc
if "%choice%"=="3" goto MG
if "%choice%"=="4" goto IOMeter
if "%choice%"=="5" goto Prime95
if "%choice%"=="6" goto OPTION1
if "%choice%"=="7" goto OPTION2
if "%choice%"=="8" goto OPTION3
if "%choice%"=="x" goto Exit

:setup
call \\10.230.136.14\Public\Rene\Scripts\Personal\menu\submenu.bat

:cinebench
echo Cinebench
call \\10.230.136.14\Public\Rene\Scripts\Personal\Cinebench\Transfer_Run_v0.5.bat
goto MENU

:fhc
echo fhc
call \\10.230.136.14\Public\Rene\Scripts\Personal\FHC\Transfer_Run_v0.5.bat
goto MENU

:MG
echo MG
call \\10.230.136.14\Public\Rene\Scripts\Personal\HP-MeatGrinder\Transfer_Run_v0.5.bat
goto MENU

:IOMeter
echo IOMeter
pause
goto MENU

:Prime95
echo Prime95
call \\10.230.136.14\Public\Rene\Scripts\Personal\Prime95\Transfer_Run_v0.5.bat
goto MENU

:OPTION1
echo ??1
pause
goto MENU

:OPTION2
echo ??2
pause
goto MENU

:OPTION3
echo ??3
pause
goto MENU

:Exit
echo Exiting...
exit
