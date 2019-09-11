package require fileutil

# ip related stuff
proc mw_ip_files_by_dir {ip_name ip_dir} {
  # find all the VHDL and verilog files
  set hdlFiles [fileutil::findByPattern $ip_dir/ *.vhd]
  lappend hdlFiles [fileutil::findByPattern $ip_dir/ *.v]

  # flatten the list
  set hdlFiles [concat {*}$hdlFiles]

  mw_ip_files $ip_name $hdlFiles
}

proc mw_ip_create {ip_name} {
  global mw_hdl_dir
  create_project $ip_name . -force

  set proj_dir [get_property directory [current_project]]
  set proj_name [get_projects $ip_name]
  
  set_property ip_repo_paths $mw_hdl_dir/library [current_project]
  update_ip_catalog
}

proc mw_ip_files {ip_name ip_files} {

  set proj_fileset [get_filesets sources_1]
  add_files -norecurse -scan_for_includes -fileset $proj_fileset $ip_files
  ip_import_files
  set_property "top" "$ip_name" $proj_fileset
  
}

proc ip_import_files {} {
  # import all non-local files
  set fileList [get_files]
  set thisDir [pwd]
  set proj_fileset [get_filesets sources_1]
  foreach fileItem $fileList {
    if {![regexp [string tolower $thisDir] [string tolower $fileItem]]} {
      import_file -fileset $proj_fileset $fileItem
    }
  }
}

proc mw_ip_constraints {ip_name ip_constr_files} {

  set proj_filegroup [ipx::get_file_groups xilinx_anylanguagesynthesis -of_objects [ipx::current_core]]
  ipx::add_file $ip_constr_files $proj_filegroup
  set_property type {{xdc}} [ipx::get_files $ip_constr_files -of_objects $proj_filegroup]
  set_property library_name {} [ipx::get_files $ip_constr_files -of_objects $proj_filegroup]
}

proc mw_ip_ttcl {ip_name ip_constr_files} {

  set proj_filegroup [ipx::get_file_groups xilinx_anylanguagesynthesis -of_objects [ipx::current_core]]
  set files [ipx::add_file $ip_constr_files $proj_filegroup]
  set_property type ttcl $files
}

proc mw_ip_properties {ip_name} {

    mw_ip_properties_lite $ip_name
    
  
    ipx::remove_memory_map {s_axi} [ipx::current_core]
    ipx::add_memory_map {s_axi} [ipx::current_core]
    set_property slave_memory_map_ref {s_axi} [ipx::get_bus_interface s_axi [ipx::current_core]]

    ipx::add_address_block {axi_lite} [ipx::get_memory_map s_axi [ipx::current_core]]
    set_property range {65536} [ipx::get_address_block axi_lite \
        [ipx::get_memory_map s_axi [ipx::current_core]]]
}

proc mw_ip_properties_lite {ip_name} {

    ipx::package_project -root_dir .

    set_property name $ip_name [ipx::current_core]
    set_property vendor {mathworks.com} [ipx::current_core]
    set_property library {user} [ipx::current_core]
    set_property taxonomy {{/AXI_Infrastructure}} [ipx::current_core]
    set_property vendor_display_name {MathWorks} [ipx::current_core]
    set_property company_url {www.mathworks.com} [ipx::current_core]

    set i_families ""
    foreach i_part [get_parts] {
        lappend i_families [get_property FAMILY $i_part]
    }
    set i_families [lsort -unique $i_families]
    set s_families [get_property supported_families [ipx::current_core]]
    foreach i_family $i_families {
        set s_families "$s_families $i_family Production"
        set s_families "$s_families $i_family Beta"
    }
    set_property supported_families $s_families [ipx::current_core]
    ipx::save_core [ipx::current_core]

    ipx::infer_bus_interfaces {xilinx.com:interface:aximm:1.0 \
    xilinx.com:interface:axis:1.0} [ipx::current_core]
    
    #ipx::remove_bus_interface IPCORE_signal_reset [ipx::current_core]
    #ipx::remove_bus_interface IPCORE_signal_clock [ipx::current_core]
}

proc mw_set_ports_dependency {port_prefix dependency} {
	foreach port [ipx::get_ports [format "%s%s" $port_prefix "*"]] {
		set_property ENABLEMENT_DEPENDENCY $dependency $port
	}
}

proc mw_set_bus_dependency {bus prefix dependency} {
	set_property ENABLEMENT_DEPENDENCY $dependency [ipx::get_bus_interfaces -of_objects [ipx::current_core] $bus]
	mw_set_ports_dependency $prefix $dependency
}

proc mw_add_port_map {bus phys logic} {
	set map [ipx::add_port_map $phys $bus]
	set_property "PHYSICAL_NAME" $phys $map
	set_property "LOGICAL_NAME" $logic $map
}

proc mw_add_bus {bus_name bus_mode bus_abstraction_type_vlnv bus_type_vlnv port_maps} {
	set bus [ipx::add_bus_interface $bus_name [ipx::current_core]]
    set_property abstraction_type_vlnv ${bus_abstraction_type_vlnv} $bus
    set_property bus_type_vlnv ${bus_type_vlnv} $bus
    set_property interface_mode $bus_mode $bus
    
	foreach port_map $port_maps {
		mw_add_port_map $bus {*}$port_map
	}
    
    return $bus
}

proc mw_add_clock {clock_signal_name clock_inf_name {assoc_reset ""}} {
	set clock_inf [ipx::add_bus_interface $clock_inf_name [ipx::current_core]]
	set_property abstraction_type_vlnv "xilinx.com:signal:clock_rtl:1.0" $clock_inf
	set_property bus_type_vlnv "xilinx.com:signal:clock:1.0" $clock_inf
	set_property display_name $clock_inf_name $clock_inf
	set clock_map [ipx::add_port_map "CLK" $clock_inf]
	set_property physical_name $clock_signal_name $clock_map
	
	if { $assoc_reset != "" } {
		set assoc_reset_prop [ipx::add_bus_parameter "ASSOCIATED_RESET" $clock_inf]
		set_property value $assoc_reset $assoc_reset_prop
	}
	
	return $clock_inf
}

proc mw_add_reset {reset_signal_name reset_inf_name {polarity "ACTIVE_LOW"}} {
	set reset_inf [ipx::add_bus_interface $reset_inf_name [ipx::current_core]]
	set_property abstraction_type_vlnv "xilinx.com:signal:reset_rtl:1.0" $reset_inf
	set_property bus_type_vlnv "xilinx.com:signal:reset:1.0" $reset_inf
	set_property display_name $reset_inf_name $reset_inf
	set reset_map [ipx::add_port_map "RST" $reset_inf]
	set_property physical_name $reset_signal_name $reset_map
	
	set reset_polarity [ipx::add_bus_parameter "POLARITY" $reset_inf]
	set_property value $polarity $reset_polarity
	
	return $reset_inf
}

proc mw_add_bus_clock {clock_signal_name bus_inf_name {reset_signal_name ""}} {
	set bus_inf_name_clean [string map {":" "_"} $bus_inf_name]
	set clock_inf_name [format "%s%s" $bus_inf_name_clean "_signal_clock"]
	set clock_inf [mw_add_clock $clock_signal_name $clock_inf_name $reset_signal_name]

	set assoc_busif [ipx::add_bus_parameter "ASSOCIATED_BUSIF" $clock_inf]
	set_property value $bus_inf_name $assoc_busif

	if { $reset_signal_name != "" } {
		set reset_inf_name [format "%s%s" $bus_inf_name_clean "_signal_reset"]
		set reset_inf [mw_add_reset $reset_signal_name $reset_inf_name]
	}
}

