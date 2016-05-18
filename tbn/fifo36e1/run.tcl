#!/usr/bin/tclsh
set myDir [file dirname $argv0]

exec xvlog $::env(XILINX_VIVADO)/data/verilog/src/glbl.v >&@stdout
exec xvlog -svlog ${myDir}/fifo36e1_tb.sv >&@stdout

exec xelab work.fifo36e1_tb -debug typical -L secureip -L unisims_ver -L unimacrover -R >&@stdout

