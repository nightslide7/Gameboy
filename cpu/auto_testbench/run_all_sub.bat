@echo off
setlocal

if [%1]==[] goto usage
if not [%~x1]==[.s] goto usage

if not exist %1 (
    echo %1 doesn't exist
    goto exiterror
)

if exist %~n1\nul (
    if not exist %~n1\run_all.bat (
        echo %~n1 already a directory, remove before proceeding
        goto exiterror
    ) else (
        goto verification
    )
)

echo Creating test directory %~n1...
mkdir %~n1
echo Copying testbench files from util\ to %~n1\...
copy util\* %~n1\*
echo Copying assembly file %1 to %~n1\...
copy %1 %~n1\%~n1%~x1

:verification
echo Running verification routine...
pushd %~n1
call run_all.bat %~n1%~x1
popd
echo Verification complete!

goto exitcorrect




:usage
echo Usage: %0 ^<input assembly file^>
goto exiterror

:exiterror
set AUTO_TESTBENCH_ERROR=1
goto exitall

:exitcorrect
set AUTO_TESTBENCH_ERROR=0
goto exitall

:exitall
endlocal
exit /B %AUTO_TESTBENCH_ERROR%