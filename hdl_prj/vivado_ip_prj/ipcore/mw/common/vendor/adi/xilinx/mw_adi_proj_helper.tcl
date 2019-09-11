set adi_xil_dir [file dirname [info script]]
source $adi_xil_dir/mw_adi_env.tcl
source $adi_xil_dir/mw_adi_ip_helper.tcl

set adi_board_has_hdmi true

if { ![info exists mw_adi_boardname] } {
    if { [info exists boardName] } {
        set mw_adi_boardname $boardName
    } else {
        set mw_adi_boardname "NOBOARDSET"
    }
}

source $ad_hdl_dir/projects/scripts/adi_project.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl
if { [file exists $adi_vendor_dir/boards/$mw_adi_boardname/system_bd.tcl] } {
    source $adi_vendor_dir/boards/$mw_adi_boardname/system_bd.tcl
}

proc mw_adi_proj {} {
    
    global adi_vendor_dir
    global mw_adi_boardname
    
    add_files -norecurse -fileset sources_1 $adi_vendor_dir/boards/$mw_adi_boardname/system_constr.xdc
    set_property target_language Verilog [current_project]
    
}

proc mw_adi_bd_cleanup {} {
    global adi_board_has_hdmi
    
    if { $adi_board_has_hdmi == true } {
        # Remove the HDMI components
        delete_bd_objs [get_bd_cells axi_hdmi_dma] \
            [get_bd_cells axi_hdmi_core] \
            [get_bd_cells axi_hdmi_clkgen] \
            [get_bd_cells axi_spdif_tx_core] \
            [get_bd_cells axi_hp0_interconnect] \
            [get_bd_ports hdmi_hsync] \
            [get_bd_ports hdmi_vsync] \
            [get_bd_ports hdmi_data_e] \
            [get_bd_ports hdmi_out_clk] \
            [get_bd_ports hdmi_data] \
            [get_bd_ports spdif]
            
        mw_create_const "intr_concat_gnd" 1 0
        mw_disconnect_pin sys_concat_intc/In15
        mw_connect_pin const_intr_concat_gnd sys_concat_intc/In15
        
        mw_disconnect_pin sys_ps7/S_AXI_HP0_ACLK
        set_property CONFIG.PCW_USE_S_AXI_HP0 0 [get_bd_cells sys_ps7]
    }
        
    mw_adi_bd_board_cleanup
}

proc mw_adi_add_status_led {} { 
    set led_driver_name led_driver
    set port [ create_bd_port -dir O -from 0 -to 0 STATUS_LED]
    set $led_driver_name [ create_bd_cell -type ip -vlnv mathworks.com:user:util_mw_led_driver:1.0 led_driver]
    mw_connect_pin $led_driver_name/led $port
    mw_connect_pin $led_driver_name/clk_ps7 sys_ps7/FCLK_CLK0
    mw_connect_pin $led_driver_name/clk_rf util_mw_clkconstr/clk_out
    mw_connect_pin $led_driver_name/rst util_ad9361_divclk_reset/peripheral_reset
}
