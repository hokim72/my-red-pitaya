set project_name [lindex $argv 0]

open_project proj/$project_name.xpr

if {[get_property PROGRESS [get_runs synth_1]] != "100%"} {
	launch_runs synth_1
	wait_on_run synth_1
}

write_hwdef -force -file proj/$project_name.hwdef

close_project
