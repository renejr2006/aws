@echo off
for /f "skip=1 tokens=2 delims==" %%P in ('wmic cpu get NumberOfLogicalProcessors /format:list') do (
	set /a logicalProcessors=%%P
)
echo Number of Cores: %logicalProcessors% 
pause
