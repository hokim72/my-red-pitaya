#!/usr/bin/tclsh
set myDir [file dirname $argv0]

exec xvlog $::env(MY_RP)/myip/axis_red_pitaya_adc_v1_0/src/axis_red_pitaya_adc.v >&@stdout
exec xvlog -svlog ${myDir}/axis_red_pitaya_adc_tb.sv >&@stdout

exec xelab work.axis_red_pitaya_adc_tb -debug typical -L secureip -L unisims_ver -L unimacrover -R >&@stdout

