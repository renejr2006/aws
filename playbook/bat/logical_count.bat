@echo off
set logicalProcessors=0 

for /f "skip=1 tokens=2 delims==" %%P in ('wmic cpu get NumberOfLogicalProcessors /format:list') do (
	if not "%%P"=="" (
		set /a logicalProcessors+=%%P
	)
)
echo Number of Logical Processors: %logicalProcessors% 
pause
