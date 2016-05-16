#!/usr/bin/tclsh
set myDir [file dirname $argv0]

source ${myDir}/axis_dwidth_converter_v1_1_6.tcl
#exec xvlog $::env(XILINX_VIVADO)/data/verilog/src/glbl.v >&@stdout
exec xvlog ${myDir}/axis_dwidth_converter.v >&@stdout
exec xvlog $::env(MY_RP)/myip/axis_counter_v1_0/src/axis_counter.v >&@stdout
exec xvlog -svlog ${myDir}/axis_dwidth_converter_tb.sv >&@stdout

exec xelab work.axis_dwidth_converter_tb -debug typical -L secureip -L unisims_ver -L unimacrover -R >&@stdout
