
proc if_define {name} {
	ipx::create_abstraction_definition hokim user ${name}_rtl 1.0
	ipx::create_bus_definition hokim user $name 1.0

	set_property xml_file_name ${name}_rtl.xml [ipx::current_busabs]
	set_property xml_file_name ${name}.xml [ipx::current_busdef]
	set_property bus_type_vlnv hokim:user:${name}:1.0 [ipx::current_busabs]

	ipx::save_abstraction_definition [ipx::current_busabs]
	ipx::save_bus_definition [ipx::current_busdef]
}

proc if_ports {dir width name {type none}} {
	ipx::add_bus_abstraction_port $name [ipx::current_busabs]
	set m_intf [ipx::get_bus_abstraction_ports $name -of_objects [ipx::current_busabs]]
	set_property master_presence required $m_intf
	set_property slave_presence required $m_intf
	set_property master_width $width $m_intf
	set_property slave_width $width $m_intf

	set m_dir "in"
	set s_dir "out"
	if {$dir eq "output"} {
		set m_dir "out"
		set s_dir "in"
	}

#set_property master_direction $m_dir $m_intf
#set_property slave_direction $s_dir $m_intf
	set_property slave_direction "in" $m_intf

	if {$type ne "none"} {
		set_property is_${type} true $m_intf
	}

	ipx::save_bus_definition [ipx::current_busdef]
	ipx::save_abstraction_definition [ipx::current_busabs]
}
