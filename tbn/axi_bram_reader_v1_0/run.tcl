#!/usr/bin/tclsh
set myDir [file dirname $argv0]

source $::env(MY_RP)/tbn/blk_mem_gen_v8_3_1/blk_mem_gen_v8_3_1.tcl

exec xvhdl $::env(MY_RP)/tbn/blk_mem_gen_v8_3_1/blk_mem_gen.vhd >&@stdout
exec xvlog $::env(MY_RP)/myip/axi_bram_reader_v1_0/src/axi_bram_reader.v >&@stdout
exec xvlog $::env(XILINX_VIVADO)/data/verilog/src/glbl.v >&@stdout
exec xvlog -svlog $::env(MY_RP)/tbn/bfm/axi_master_model_v1.sv >&@stdout
exec xvlog -svlog ${myDir}/axi_bram_reader_tb.sv >&@stdout

exec xelab work.axi_bram_reader_tb -debug typical  -L secureip -L unisims_ver -L unimacro_ver -R >&@stdout
