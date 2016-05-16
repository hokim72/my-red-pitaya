#!/usr/bin/tclsh
set myDir [file dirname $argv0]

source ${myDir}/c_counter_binary_v12_0_8.tcl

exec xvhdl ${myDir}/bcntr.vhd >&@stdout
exec xvlog -svlog ${myDir}/bcntr_tb.sv >&@stdout

exec xelab work.bcntr_tb -debug typical  -L secureip -L unisims_ver -L unimacro_ver -R >&@stdout
