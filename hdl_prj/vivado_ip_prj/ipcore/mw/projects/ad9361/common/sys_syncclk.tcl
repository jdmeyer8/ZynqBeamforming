# clock crossing for synchronous (phase aligned) clocks

proc p_sys_syncclk {p_name m_name n_ports p_width c_ratio} {

    set p_instance [get_bd_cells $p_name]
    set c_instance [current_bd_instance .]

    current_bd_instance $p_instance

    set m_instance [create_bd_cell -type hier $m_name]
    current_bd_instance $m_instance

    create_bd_pin -dir I wr_clk
    create_bd_pin -dir I wr_rstn
    create_bd_pin -dir I wr_valid
    for {set i 0} {$i < $n_ports} {incr i} {
        create_bd_pin -dir I -from [expr ($p_width-1)] -to 0 wr_data_$i
    }

    create_bd_pin -dir I rd_clk
    create_bd_pin -dir I rd_rstn
    create_bd_pin -dir O rd_valid
    for {set i 0} {$i < $n_ports} {incr i} {
        create_bd_pin -dir O -from [expr ($p_width-1)] -to 0 rd_data_$i
    }

    connect_bd_net -net wr_clk      [get_bd_pins wr_clk]
    connect_bd_net -net wr_rstn     [get_bd_pins wr_rstn]
    connect_bd_net -net wr_valid    [get_bd_pins wr_valid]    

    connect_bd_net -net rd_clk      [get_bd_pins rd_clk]
    connect_bd_net -net rd_rstn     [get_bd_pins rd_rstn]

    for {set i 0} {$i < $n_ports} {incr i} {
        set regsync [create_bd_cell -type ip -vlnv mathworks.com:user:util_regsync:* regsync_$i]
        set_property -dict [list CONFIG.BUS_WIDTH $p_width] $regsync
        set_property -dict [list CONFIG.CLK_RATIO $c_ratio] $regsync

        connect_bd_net -net wr_clk  [get_bd_pins regsync_$i/wr_clk]
        connect_bd_net -net wr_rstn  [get_bd_pins regsync_$i/wr_rstn]
        connect_bd_net -net wr_valid  [get_bd_pins regsync_$i/wr_valid]
        connect_bd_net [get_bd_pins wr_data_$i] [get_bd_pins regsync_$i/wr_data] 


        connect_bd_net -net rd_clk      [get_bd_pins regsync_$i/rd_clk]
        connect_bd_net -net rd_rstn      [get_bd_pins regsync_$i/rd_rstn]
        connect_bd_net [get_bd_pins rd_data_$i] [get_bd_pins regsync_$i/rd_data]
    }
    connect_bd_net [get_bd_pins rd_valid] [get_bd_pins regsync_0/rd_valid]

  current_bd_instance $c_instance
}

