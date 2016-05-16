#!/usr/bin/tclsh
set myDir [file dirname $argv0]

source ${myDir}/blk_mem_gen_v8_3_1.tcl

exec xvhdl ${myDir}/blk_mem_gen.vhd >&@stdout
exec xvlog -svlog ${myDir}/blk_mem_gen_tb.sv >&@stdout

exec xelab work.blk_mem_gen_tb -debug typical  -L secureip -L unisims_ver -L unimacro_ver -R >&@stdout
