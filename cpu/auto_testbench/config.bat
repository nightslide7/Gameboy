@echo off
if defined AUTO_TESTBENCH_CONF (
    echo config.bat already run.
)
if not defined AUTO_TESTBENCH_CONF (
    set "PATH=%PATH%;C:\Users\Joseph\Documents\F13\18545\gbdk\bin"
    call C:\Xilinx\14.3\ISE_DS\settings64.bat
    
    set AUTO_TESTBENCH_CONF=1
    )
@echo on