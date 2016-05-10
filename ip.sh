#vivado -nolog -nojournal -mode batch -source $MY_RP/scripts/core.tcl -tclargs axi_cfg_register_v1_0 xc7z010clg400-1
#vivado -nolog -nojournal -mode batch -source $MY_RP/scripts/core.tcl -tclargs axi_sts_register_v1_0 xc7z010clg400-1
#vivado -nolog -nojournal -mode batch -source $MY_RP/scripts/core.tcl -tclargs axis_red_pitaya_adc_v1_0 xc7z010clg400-1
#vivado -nolog -nojournal -mode batch -source $MY_RP/scripts/core.tcl -tclargs axis_counter_v1_0 xc7z010clg400-1
vivado -nolog -nojournal -mode batch -source $MY_RP/scripts/core.tcl -tclargs axis_ram_writer_v1_0 xc7z010clg400-1
