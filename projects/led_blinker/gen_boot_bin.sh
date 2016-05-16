#vivado -nolog -nojournal -mode batch -source $MY_RP/scripts/hwdef.tcl -tclargs led_blinker
tclsh $MY_RP/scripts/boot.tcl led_blinker
