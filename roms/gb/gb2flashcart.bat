@echo off
setlocal

if [%1]==[] goto usage
if [%2]==[] goto usage

if not exist %1 (
    echo %1 doesn't exist
    goto exit
)

if not exist bootstrap.dat (
    echo bootstrap.dat doesn't exist. Kindly provide one.
    goto exit
)

echo Generating data file from ROM...
perl hex2dat.pl %1 %~n1.dat

echo Concatenating bootstrap to ROM...
type bootstrap.dat %~n1.dat > %~n1.concat.dat

echo Generating Flash file from data file...
perl dat2hex.pl %~n1.concat.dat %~n1.hex

promgen -r %~n1.hex -p mcs -data_width 16 -w -o %~n2.mcs

goto exit

:usage
echo Usage: %0 ^<input gameboy file^> ^<output mcs file^>

:exit
endlocal
exit /B