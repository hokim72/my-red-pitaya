#!/usr/bin/tclsh
set myDir [file dirname $argv0]

exec xvlog $::env(MY_RP)/myip/axis_counter_v1_0/src/axis_counter.v >&@stdout
exec xvlog -svlog ${myDir}/axis_counter_tb.sv >&@stdout

exec xelab work.axis_counter_tb -debug typical -L secureip -L unisims_ver -L unimacrover -R >&@stdout

