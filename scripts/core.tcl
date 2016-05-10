set core_name [lindex $argv 0]

set part_name [lindex $argv 1]

set elements [split $core_name _]
set project_name [join [lrange $elements 0 end-2] _]
set version [string trimleft [join [lrange $elements end-1 end] .] v]

set myip $::env(MY_RP)/myip
file delete -force $myip/$core_name 
#file delete -force $myip/$core_name $myip/$project_name.cache $myip/$project_name.hw $myip/$project_name.xpr $myip/$project_name.ip_user_files

create_project -part $part_name $project_name $myip

add_files -norecurse [glob cores/$core_name/*.v cores/$core_name/*.vhd]

ipx::package_project -import_files -root_dir $myip/$core_name

set core [ipx::current_core]

set_property VERSION $version $core
set_property NAME $project_name $core
set_property LIBRARY {user} $core
set_property VENDOR {hokim} $core
set_property VENDOR_DISPLAY_NAME {Hyunok Kim} $core
set_property COMPANY_URL {https://github.com/hokim72} $core
set_property SUPPORTED_FAMILIES {zynq Production} $core

proc core_parameter {name display_name description} {
  set core [ipx::current_core]

  set parameter [ipx::get_user_parameters $name -of_objects $core]
  set_property DISPLAY_NAME $display_name $parameter
  set_property DESCRIPTION $description $parameter

  set parameter [ipgui::get_guiparamspec -name $name -component $core]
  set_property DISPLAY_NAME $display_name $parameter
  set_property TOOLTIP $description $parameter
}

proc add_port_map {bus phys logic} {

	set map [ipx::add_port_map $phys $bus]
	set_property "PHYSICAL_NAME" $phys $map
	set_property "LOGICAL_NAME" $logic $map
}

proc add_bus {bus_name mode abs_type bus_type port_maps} {
	set core [ipx::current_core]

	set bus [ipx::add_bus_interface $bus_name $core]
	set_property "ABSTRACTION_TYPE_VLNV" $abs_type $bus
	set_property "BUS_TYPE_VLNV" $bus_type $bus
	set_property "INTERFACE_MODE" $mode $bus

	foreach port_map $port_maps {
		add_port_map $bus {*}$port_map
	}
}

proc add_bus_clock {clock_signal_name bus_inf_name {reset_signal_name ""} {reset_signal_mode "slave"}} {
    set core [ipx::current_core]

	set bus_inf_name_clean [string map {":" "_"} $bus_inf_name]
	set clock_inf_name [format "%s%s" $bus_inf_name_clean "_signal_clock"]
	set clock_inf [ipx::add_bus_interface $clock_inf_name $core]
	set_property abstraction_type_vlnv "xilinx.com:signal:clock_rtl:1.0" $clock_inf
	set_property bus_type_vlnv "xilinx.com:signal:clock:1.0" $clock_inf
	set_property display_name $clock_inf_name $clock_inf
	set clock_map [ipx::add_port_map "CLK" $clock_inf]
	set_property physical_name $clock_signal_name $clock_map

	set assoc_busif [ipx::add_bus_parameter "ASSOCIATED_BUSIF" $clock_inf]
	set_property value $bus_inf_name $assoc_busif

	if { $reset_signal_name != "" } {
		set assoc_reset [ipx::add_bus_parameter "ASSOCIATED_RESET" $clock_inf]
		set_property value $reset_signal_name $assoc_reset

		set reset_inf_name [format "%s%s" $bus_inf_name_clean "_signal_reset"]
		set reset_inf [ipx::add_bus_interface $reset_inf_name $core]
		set_property abstraction_type_vlnv "xilinx.com:signal:reset_rtl:1.0" $reset_inf
		set_property bus_type_vlnv "xilinx.com:signal:reset:1.0" $reset_inf
		set_property display_name $reset_inf_name $reset_inf
		set_property interface_mode $reset_signal_mode $reset_inf
		set reset_map [ipx::add_port_map "RST" $reset_inf]
		set_property physical_name $reset_signal_name $reset_map

		set reset_polarity [ipx::add_bus_parameter "POLARITY" $reset_inf]
		set_property value "ACTIVE_LOW" $reset_polarity
	}
}

proc set_port_dependency {port dependency} {
	set_property ENABLEMENT_DEPENDENCY $dependency [ipx::get_ports $port]
}

proc set_bus_dependency {bus dependency} {
	set core [ipx::current_core]

	set_property ENABLEMENT_DEPENDENCY $dependency [ipx::get_bus_interfaces $bus -of_objects $core]
}

source cores/$core_name/core_config.tcl

rename core_parameter {}
rename add_port_map {}
rename add_bus {}
rename add_bus_clock {}
rename set_port_dependency {}
rename set_bus_dependency {}

ipx::create_xgui_files $core
ipx::update_checksums $core
ipx::save_core $core

close_project

file delete -force $myip/$project_name.cache $myip/$project_name.hw $myip/$project_name.xpr $myip/$project_name.ip_user_files
