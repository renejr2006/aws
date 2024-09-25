@echo off
setlocal

set "sDir=\\10.227.1.147\Public\Rene\test\"
set "dDir=%CD%\Desktop\"

copy "%sdir%/*.zip" "%dDir%"

echo ZIP files copied Successfully
endlocal
