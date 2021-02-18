@echo off
set xv_path=C:\\Xilinx\\Vivado\\2015.2\\bin
call %xv_path%/xsim convLayerMulti_TB_behav -key {Behavioral:sim_1:Functional:convLayerMulti_TB} -tclbatch convLayerMulti_TB.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
