
# fifos and adc bridge controller

proc p_sys_mw_adc_bridge {p_name m_name data_width num_chan} {

    set p_instance [get_bd_cells $p_name]
    set c_instance [current_bd_instance .]

    current_bd_instance $p_instance

    set m_instance [create_bd_cell -type hier $m_name]

    current_bd_instance $m_instance
        
    for {set chan 0} {$chan < $num_chan} {incr chan} {
        create_bd_pin -dir I -from [expr ($data_width-1)] -to 0 adc_data_${chan}
        create_bd_pin -dir I adc_valid_${chan}
        create_bd_pin -dir I adc_enable_${chan}
    }

    create_bd_pin -dir O dmac_wr_en
    create_bd_pin -dir O dmac_sync
    
    set dmac_width [expr $data_width * $num_chan]
    create_bd_pin -dir O -from [expr ($dmac_width-1)] -to 0 dmac_data_out
      
    create_bd_pin -dir I bridge_valid_in
    create_bd_pin -dir I bridge_sync_in
    create_bd_pin -dir O bridge_valid_out
    create_bd_pin -dir O bridge_enable_out
    for {set chan 0} {$chan < $num_chan} {incr chan} {
        create_bd_pin -dir I -from [expr ($data_width-1)] -to 0 bridge_in_${chan}
        create_bd_pin -dir O -from [expr ($data_width-1)] -to 0 bridge_out_${chan}
    }
    
    connect_bd_net -boundary_type lower -net bridge_valid_in [get_bd_pins bridge_valid_in]
    connect_bd_net -boundary_type lower -net bridge_sync_in [get_bd_pins bridge_sync_in]
    
    connect_bd_net -boundary_type lower -net bridge_valid_in [get_bd_pins dmac_wr_en]
    connect_bd_net -boundary_type lower -net bridge_sync_in [get_bd_pins dmac_sync]

  
    set adc_bridge_ctl [create_bd_cell -type ip -vlnv mathworks.com:user:util_mw_adc_bridge_ctl:* adc_bridge_ctl]
    set_property -dict [list \
        CONFIG.DATA_WIDTH $data_width \
        CONFIG.NUM_CHAN $num_chan] $adc_bridge_ctl
  
    for {set chan 0} {$chan < $num_chan} {incr chan} {
        connect_bd_net [get_bd_pins adc_bridge_ctl/bridge_in_${chan}] [get_bd_pins bridge_in_${chan}]
        connect_bd_net [get_bd_pins adc_bridge_ctl/bridge_out_${chan}] [get_bd_pins bridge_out_${chan}]
        connect_bd_net [get_bd_pins adc_bridge_ctl/adc_data_${chan}] [get_bd_pins adc_data_${chan}]
        connect_bd_net [get_bd_pins adc_bridge_ctl/adc_enable_${chan}] [get_bd_pins adc_enable_${chan}]
        connect_bd_net [get_bd_pins adc_bridge_ctl/adc_valid_${chan}] [get_bd_pins adc_valid_${chan}]
    }    
  
    connect_bd_net [get_bd_pins bridge_valid_out] [get_bd_pins adc_bridge_ctl/bridge_out_valid]
    connect_bd_net [get_bd_pins bridge_enable_out] [get_bd_pins adc_bridge_ctl/bridge_out_enable]
    connect_bd_net [get_bd_pins dmac_data_out] [get_bd_pins adc_bridge_ctl/dmac_out]
    
    current_bd_instance $c_instance
    return $m_instance
}

