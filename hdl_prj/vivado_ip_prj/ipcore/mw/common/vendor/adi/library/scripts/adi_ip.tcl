set ad_hdl_dir [file normalize $::env(MW_ADI_HDL_DIR)]
source $ad_hdl_dir/library/scripts/adi_ip.tcl

proc file_is_local { fileItem } {
	set thisDir [pwd]
	set fileItem [file normalize $fileItem]
	return [regexp [string tolower $thisDir] [string tolower $fileItem]]
}

proc get_imported_file { fileItem} {
	if { [file_is_local $fileItem] } {
        return $fileItem
    }
    set proj_fileset [get_filesets sources_1]
	set f_name [file tail $fileItem]
	set this_proj [current_project]
	set import_dir "${this_proj}.srcs/${proj_fileset}/imports"
	set imported [get_files -of [get_filesets $proj_fileset] $f_name]
	if { [llength $imported] != 1 } {
		puts "ERROR: Could not find imported version of $fileItem"
		error_on_bad_command
	}
	set imported [file normalize $imported]
	set imported [regsub ".*$import_dir" $imported $import_dir]
	
	return $imported
}

proc ip_import_files {} {
	# import all non-local files
	set fileList [get_files]
	set thisDir [pwd]
	set proj_fileset [get_filesets sources_1]
	foreach fileItem $fileList {
		if { ![file_is_local $fileItem] } {
			import_file -fileset $proj_fileset $fileItem
		}
	}
}

# Overload the ADI functions to import files locally
proc adi_ip_files {ip_name ip_files} {

  global ip_constr_files
  set ip_constr_files ""

  set proj_fileset [get_filesets sources_1]
  add_files -norecurse -scan_for_includes -fileset $proj_fileset $ip_files
  set_property "top" "$ip_name" $proj_fileset
  ip_import_files
  
  foreach m_file $ip_files {
    if {[file extension $m_file] eq ".xdc"} {
      lappend ip_constr_files [get_imported_file $m_file]
    }
  }
}

proc adi_ip_ttcl {ip_name ip_constr_files} {

  set proj_filegroup [ipx::get_file_groups -of_objects [ipx::current_core] -filter {NAME =~ *synthesis*}]
  foreach m_file $ip_constr_files {
    set f [ipx::add_file [get_imported_file $m_file] $proj_filegroup]
    set_property -dict [list \
        type ttcl \
    ] $f
  }
}