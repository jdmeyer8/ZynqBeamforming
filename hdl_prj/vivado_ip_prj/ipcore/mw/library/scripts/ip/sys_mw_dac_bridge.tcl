
# fifos and dac bridge controller

proc p_sys_mw_dac_bridge {p_name m_name data_width num_chan} {

	set p_instance [get_bd_cells $p_name]
	set c_instance [current_bd_instance .]

	current_bd_instance $p_instance

    set m_instance [create_bd_cell -type hier $m_name]

    current_bd_instance $m_instance
        
    create_bd_pin -dir I clk
    create_bd_pin -dir I rst
    
    for {set chan 0} {$chan < $num_chan} {incr chan} {
        create_bd_pin -dir I dac_enable_${chan}
        create_bd_pin -dir I dac_valid_${chan}
        create_bd_pin -dir O -from [expr ($data_width-1)] -to 0 dac_data_${chan}
    }

    create_bd_pin -dir I dmac_valid_in
    create_bd_pin -dir O dmac_rd_en
    
    set fifo_width [expr $data_width * $num_chan]
    create_bd_pin -dir I -from [expr ($fifo_width-1)] -to 0 dmac_data_in
  
      create_bd_pin -dir I bridge_valid_in
    create_bd_pin -dir I bridge_enable_in
  
    for {set chan 0} {$chan < $num_chan} {incr chan} {
        create_bd_pin -dir I -from [expr ($data_width-1)] -to 0 bridge_in_${chan}
    }
    
    create_bd_pin -dir O bridge_valid_out
    create_bd_pin -dir O bridge_enable_out
    
    for {set chan 0} {$chan < $num_chan} {incr chan} {
        create_bd_pin -dir O -from [expr ($data_width-1)] -to 0 bridge_out_${chan}
    }
    
    # Connect dmac_valid_in to bridge_valid_out
    connect_bd_net -boundary_type lower -net dmac_valid_in [get_bd_pins dmac_valid_in]
    connect_bd_net -boundary_type lower -net dmac_valid_in [get_bd_pins bridge_valid_out]
    
    # Connect bridge_enable_in to dmac_rd_en
    connect_bd_net -boundary_type lower -net bridge_enable_in [get_bd_pins bridge_enable_in]
    connect_bd_net -boundary_type lower -net bridge_enable_in [get_bd_pins dmac_rd_en]
  
    set dac_bridge_ctl [create_bd_cell -type ip -vlnv mathworks.com:user:util_mw_dac_bridge_ctl:* dac_bridge_ctl]
    set_property -dict [list \
        CONFIG.DATA_WIDTH $data_width \
        CONFIG.NUM_CHAN $num_chan] $dac_bridge_ctl
        
    for {set chan 0} {$chan < $num_chan} {incr chan} {
        connect_bd_net [get_bd_pins dac_bridge_ctl/bridge_in_${chan}] [get_bd_pins bridge_in_${chan}]
        connect_bd_net [get_bd_pins dac_bridge_ctl/bridge_out_${chan}] [get_bd_pins bridge_out_${chan}]
        connect_bd_net [get_bd_pins dac_bridge_ctl/dac_data_${chan}] [get_bd_pins dac_data_${chan}]
        connect_bd_net [get_bd_pins dac_bridge_ctl/dac_valid_${chan}] [get_bd_pins dac_valid_${chan}]
        connect_bd_net [get_bd_pins dac_bridge_ctl/dac_enable_${chan}] [get_bd_pins dac_enable_${chan}]
    }    
  
    connect_bd_net [get_bd_pins clk] [get_bd_pins dac_bridge_ctl/clk]
    connect_bd_net [get_bd_pins rst] [get_bd_pins dac_bridge_ctl/rst]
    connect_bd_net [get_bd_pins dmac_data_in] [get_bd_pins dac_bridge_ctl/dmac_in]
    connect_bd_net [get_bd_pins bridge_valid_in] [get_bd_pins dac_bridge_ctl/bridge_valid_in]
    connect_bd_net [get_bd_pins bridge_enable_out] [get_bd_pins dac_bridge_ctl/bridge_enable_out]

    
    current_bd_instance $c_instance
    return $m_instance
}

