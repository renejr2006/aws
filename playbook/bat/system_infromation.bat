@echo off
setlocal enabledelayedexpansion
set "logfile=Systen_Info.log"
echo =============================================================================
echo                          System Information
echo =============================================================================
set "totalSize="
set "freeSpace="
set "usedSpace="

for /f "tokens=2 delims==" %%i in ('wmic diskdrive get size /format:value') do (
	set size=%%i
	set /a size_gb=!size:~0,-9!
	echo Drive Size: !size! bytes
	echo Drive Size: !size_gb! GB
)

echo -----------------------------------------------------------------------------
echo -----------------------------------------------------------------------------
for /f "tokens=2 delims==" %%i in ('wmic computersystem get manufacturer /value') do (
	set "ServerMake=%%i"
)
echo Server Make:                             %ServerMake%

for /f "tokens=2 delims==" %%i in ('wmic computersystem get model /value') do (
	set "ServerType=%%i"
)
echo Server Type:                             %ServerType%

echo -----------------------------------------------------------------------------

for /f "tokens=3*" %%i in ('systeminfo ^| findstr /C:"Install Date"') do (
	set "install_date=%%j"
)
echo Install Date:                            %install_date%
echo System Name:                             %COMPUTERNAME%

for /f "tokens=2 delims==" %%I in ('wmic os get caption /value') do set OS_Name=%%I
for /f "tokens=2 delims==" %%J in ('wmic os get version /value') do set OS_VERSION=%%J
echo OS Name:                                 %OS_NAME%
echo OS Version:                              %OS_VERSION%
for /f "tokens=2*" %%i in ('systeminfo ^| findstr /C:"System Type"') do (
	set "system_type=%%j"
)
echo System Type:                             %system_type%
for /f "tokens=2*" %%i in ('systeminfo ^| findstr /C:"System Locale"') do (
	set "system_locale=%%j"
)
echo System Locale:                           %system_locale%
echo -----------------------------------------------------------------------------
rem for /f "skip=1 tokens=*" %%B in ('wmic bios get biosversion') do (
rem 	if not defined BIOSVersion set BIOSVersion=%%B
rem )
rem echo BIOS Version: %BIOSVersion%
for /f "tokens=2 delims==" %%I in ('wmic bios get smbiosbiosversion /value') do set BIOS_VERSION=%%I
echo BIOS Version:                            %BIOS_VERSION%


echo -----------------------------------------------------------------------------

for /f "tokens=2 delims==" %%i in ('wmic computersystem get NumberOfProcessors /value') do (
	set "NumProcessors=%%i"
)

if "%NumProcessors%"=="1" (
	echo CPUs Detected:                           1
) else if "%NumProcessors%"=="2" (
	echo CPUS Detected:                           2
) else (
	echo CPUs Detected:               %NumProcessors% CPUs
)


set /a count=0
for /f "tokens=2 delims==" %%i in ('wmic cpu get ProcessorId /value') do (
	echo CPU %count% Serial Number:                     %%i
	set /a count+=1
)

for /f "tokens=2 delims==" %%i in ('wmic cpu get Description /value') do (
	set "CPUDescription=%%i"

)
echo CPU Description:                         %CPUDescription%
for /f "tokens=2 delims==" %%i in ('wmic cpu get Name /value') do (
	set "CPUName=%%i"
)
echo OPN Number:                              %CPUName%

for /f "skip=1 tokens=2 delims==" %%P in ('wmic cpu get NumberOfLogicalProcessors /format:list') do (
	set /a logicalProcessors=%%P
)
echo Number of Cores:                         %logicalProcessors% 

set logicalProcessors=0 

for /f "skip=1 tokens=2 delims==" %%P in ('wmic cpu get NumberOfLogicalProcessors /format:list') do (
	if not "%%P"=="" (
		set /a logicalProcessors+=%%P
	)
)
echo Number of Logical Processors:            %logicalProcessors% 

for /f "tokens=2 delims==" %%T in ('wmic path Win32_Process get ThreadCount /format:list') do (
	set /a totalThreads+=%%T
)

echo Threads:                                 %totalThreads%
echo -----------------------------------------------------------------------------
powershell -command "$memory = Get-WmiObject Win32_PhysicalMemory | Select-Object -Property Manufacturer, PartNumber, Capacity, Speed, ConfiguredClockSpeed; $output = $memory | ForEach-Object { \"Manufacturer: $($_.Manufacturer.Trim()) Size: $([math]::Round($_.Capacity /1GB, 2))GB Part Number $($_.PartNumber.Trim()) Part Number: $($_.PartNumber.Trim()) Speed: $($_.Speed) Configured Clock Speed: $($_.ConfiguredClockSpeed)\" }; $output" > temp_memory_info.txt

type temp_memory_info.txt
del temp_memory_info.txt

set count=0
for /f "skip=1 tokens=1" %%A in ('wmic memorychip get memorytype') do (
	if "%%A" neq "" set /a count+=1
)
echo Number of Memory Modules Installed:      %count%
for /f "tokens=2 delims==" %%D in ('wmic computersystem get totalphysicalmemory /value') do set TotalMemory=%%D 
powershell -command "$memoryGB = [math]::Round((%TotalMemory% / 1GB), 2); Write-Output $memoryGB" > temp_memory.txt
set /p TotalMemoryGB=<temp_memory.txt
del temp_memory.txt
echo total memory:                            %TotalMemoryGB% GB
for /f "tokens=3*" %%i in ('systeminfo ^| findstr /C:"Total Physical Memory"') do (
	set "install_date=%%j"
	set "total_physical_memory=%%j"
)
echo Total Physical Memory:                   %total_physical_memory%
echo.
for /f "skip=1 tokens=1, 2, 3, 4 delims=," %%A in ('wmic memorychip get devicelocator^,banklabel /format:csv') do (
	if not "%%A"=="" (
		set "slot=%%A"
		set "locator=%%B"
		set "bank=%%C"
		echo DIMM Locator:                            !locator!
		echo DIMM Bank:                               !bank!
	)
)

echo -----------------------------------------------------------------------------
set "nicName="
for /f "tokens=2 delims==" %%a in ('wmic nic where "NetEnabled=True" get Name /value') do (
	set "nicName=%%a"

)
echo NIC Name:                                !nicName!
for /f "tokens=2 delims=:" %%A in ('ipconfig ^| findstr /i "IPv4"') do set IPADDRESS=%%A
echo IP Address:                             %IPADDRESS%

for /f "tokens=3 delims= " %%C in ('getmac /v /fo list ^| findstr /i "Physical Address"') do set MACAddress=%%C
echo MAC Address:                             %MACAddress%
echo -----------------------------------------------------------------------------
echo Device Manager Issues
:: Initialize counters 
set "ProblematicDevices=0"

:: Retrieve device information with problems
for /f "skip=1 tokens=1,2 delims=," %%A in ('wmic path Win32_PnPSignedDriver get DeviceName,Status /format:csv') do (
rem for /f "skip=1 tokens=1,2,* delims=," %%A in ('wmic path Win32_PnPSignedDriver get DeviceID^,Status /format:csv') do (
	if not "%%A"=="" (
		set "device=%%A"
		set "status=%%B"
		if /i "!status!" neq "OK" (
			echo Device: !device!
			echo Status: !status!
		)
	)
)
	:: Check if the device has a problem
	if "!Status!"=="Error" (
		set /a ProblematicDevices+=1
		echo Device with problem: !DeviceID!
	)
)
:: Report the number of problematic devices 

echo Total number of devices with problems: %ProblematicDevices%



echo -----------------------------------------------------------------------------
endlocal
pause


rem all cpu information
set  /a count=1
for /f "skip=1 tokens=1,* delims==" %%i in ('wmic cpu get /format:list') do (
	if "%%i" neq "" (
		echo %%i=%%j
		if "%%i"=="ProcessorId=" (
			echo CPU %count%:
			echo %%i=%%j
			set /a count+=1
		)
	)
)


rem all cpu information by designation P0/P1
set /a count=1
for /f "skip=1 tokens=*" %%i in ('wmic cpu get SocketDesignation /value') do (
	if "%%i" neq "" (
		echo CPU %count% SocketDesignation: %%i
		set /a count+=1
	)
)
