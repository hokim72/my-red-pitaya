#!/usr/bin/tclsh
set myDir [file dirname $argv0]

exec xvlog $::env(XILINX_VIVADO)/data/verilog/src/glbl.v >&@stdout
exec xvlog -svlog $::env(MY_RP)/tbn/bfm/axi_master_model_v1.sv >&@stdout
#exec xvlog $::env(MY_RP)/myip/axi_cfg_register_v1_0/src/axi_cfg_register.v >&@stdout
exec xvlog $::env(MY_RP)/myip/axi_cfg_register_v2_0/src/axi_cfg_register.v >&@stdout
exec xvlog $::env(MY_RP)/myip/axi_sts_register_v1_0/src/axi_sts_register.v >&@stdout
exec xvlog -svlog ${myDir}/axi_sts_register_tb.sv >&@stdout

exec xelab work.axi_sts_register_tb -debug typical -L secureip -L unisims_ver -L unimacrover -R >&@stdout

