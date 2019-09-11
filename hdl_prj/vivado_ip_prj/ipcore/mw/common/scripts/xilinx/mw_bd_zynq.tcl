proc mw_default_bd_zynq { {core_freq 50.0} } {
    set curdir [pwd]
    cd [mw_get_proj_dir]

    # create board design
    create_bd_design "system"

    # GND and VCC nets    
    set const_vcc_inst [mw_create_const vcc 1 1]

    set const_gnd_inst [mw_create_const gnd 1 0]

    # Create the CPU interconnect
    set axi_cpu_interconnect [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:* axi_cpu_interconnect]
    set_property -dict [list CONFIG.NUM_MI {1}] $axi_cpu_interconnect
    set_property -dict [list CONFIG.S00_HAS_REGSLICE {4}] $axi_cpu_interconnect
    mw_project_set axi_cpu_interconnect $axi_cpu_interconnect
    
    # instance: sys_cpu
    mw_zynq_add_cpu

    set core_clkwiz [mw_create_clockwiz core sys_100m_clk proc_100m_resetn $core_freq]

    set sys_core_clk_source [get_bd_pins core_clkwiz/clk_out1]
    connect_bd_net -net sys_core_clk $sys_core_clk_source
    mw_project_set ipcore_clk_net [get_bd_nets sys_core_clk]

    set sys_core_rstgen [mw_rstsync sys_core sys_core_clk proc_100m_resetn core_clkwiz/locked]
    set sys_100m_rstgen [mw_rstsync sys_100m sys_100m_clk proc_100m_resetn]
    set sys_200m_rstgen [mw_rstsync sys_200m sys_200m_clk proc_200m_resetn]
    mw_project_set ipcore_rstn_net [get_bd_nets sys_core_resetn]
    mw_project_set ipcore_rst_net [get_bd_nets sys_core_reset]
    
    # interface connections
    connect_bd_net -net /sys_100m_clk [get_bd_pins axi_cpu_interconnect/ACLK]
    connect_bd_net -net /sys_100m_resetn [get_bd_pins axi_cpu_interconnect/ARESETN]

    connect_bd_net -net /sys_100m_clk [get_bd_pins axi_cpu_interconnect/S00_ACLK]
    connect_bd_net -net /sys_100m_resetn [get_bd_pins axi_cpu_interconnect/S00_ARESETN]

    connect_bd_net -net /sys_core_clk [get_bd_pins axi_cpu_interconnect/M00_ACLK]
    connect_bd_net -net /sys_core_resetn [get_bd_pins axi_cpu_interconnect/M00_ARESETN]

    
    cd $curdir
}

proc mw_zynq_add_cpu {} {
    switch [mw_project_get cpu_type] {
        zynqmp_arm {
            mw_zynqmp_add_ps
        }
        zynq7_arm {
            mw_zynq_add_ps7
        }
    }
}

proc mw_zynqmp_add_ps {} {
    
    set sys_cpu  [create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:* sys_cpu]
    apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e -config {apply_board_preset "1"} $sys_cpu    
    set_property CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {100} $sys_cpu
    set_property CONFIG.PSU__USE__IRQ0 {1} $sys_cpu
    set_property CONFIG.PSU__USE__M_AXI_GP0 {1} $sys_cpu
    set_property CONFIG.PSU__USE__M_AXI_GP1 {0} $sys_cpu
    mw_project_set sys_cpu $sys_cpu
    
    # interrupt concat
    set intr_concat [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:* intr_concat]
    set_property -dict [list CONFIG.NUM_PORTS {8}] $intr_concat
    mw_create_const "intr_concat_gnd" 1 0
    for {set i 0} {$i < 8} {incr i} {
        connect_bd_net -net const_intr_concat_gnd [get_bd_pins intr_concat/In${i}]
    }
    connect_bd_net [get_bd_pins intr_concat/dout] [get_bd_pins sys_cpu/pl_ps_irq0]
    
    # system reset/clock definitions
    connect_bd_net -net sys_100m_clk [get_bd_pins sys_cpu/pl_clk0]
    connect_bd_net -net proc_100m_resetn [get_bd_pins sys_cpu/pl_resetn0]
    
    
    set proc_clkwiz [mw_create_clockwiz proc sys_100m_clk proc_100m_resetn 200]
    connect_bd_net -net sys_200m_clk [get_bd_pins proc_clkwiz/clk_out1]
    mw_rstsync proc_200m sys_200m_clk proc_100m_resetn proc_clkwiz/locked
    
    # Clocks and interconnects
    connect_bd_net -net /sys_100m_clk [get_bd_pins sys_cpu/maxihpm0_fpd_aclk]
    connect_bd_intf_net -intf_net axi_cpu_interconnect_s00_axi [get_bd_intf_pins axi_cpu_interconnect/S00_AXI] [get_bd_intf_pins sys_cpu/M_AXI_HPM0_FPD]
    
    mw_project_set sys_addr_cntrl_space [get_bd_addr_spaces sys_cpu/Data]
    
}

proc mw_zynq_add_ps7 {} {
    
    set sys_cpu  [create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:* sys_cpu]
    apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "1"} $sys_cpu
    mw_project_set sys_cpu $sys_cpu
    
    set_property -dict [list CONFIG.PCW_USE_M_AXI_GP0 {1}] $sys_cpu
    set_property -dict [list CONFIG.PCW_EN_CLK1_PORT {1}] $sys_cpu
    set_property -dict [list CONFIG.PCW_EN_RST1_PORT {1}] $sys_cpu
    set_property -dict [list CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100.0}] $sys_cpu
    set_property -dict [list CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {200.0}] $sys_cpu
    set_property -dict [list CONFIG.PCW_USE_FABRIC_INTERRUPT {1}] $sys_cpu
    set_property -dict [list CONFIG.PCW_IRQ_F2P_INTR {1}] $sys_cpu
    set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1}] $sys_cpu
    set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_IO {32}] $sys_cpu
    set_property -dict [list CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0}] $sys_cpu

    # interrupt concat
    set intr_concat [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:* intr_concat]
    set_property -dict [list CONFIG.NUM_PORTS {16}] $intr_concat
    mw_create_const "intr_concat_gnd" 1 0
    for {set i 0} {$i < 16} {incr i} {
        connect_bd_net -net const_intr_concat_gnd [get_bd_pins intr_concat/In${i}]
    }
    connect_bd_net [get_bd_pins intr_concat/dout] [get_bd_pins sys_cpu/IRQ_F2P]

    # system reset/clock definitions
    connect_bd_net -net sys_100m_clk [get_bd_pins sys_cpu/FCLK_CLK0]
    connect_bd_net -net sys_200m_clk [get_bd_pins sys_cpu/FCLK_CLK1]
    connect_bd_net -net proc_100m_resetn [get_bd_pins sys_cpu/FCLK_RESET0_N]
    connect_bd_net -net proc_200m_resetn [get_bd_pins sys_cpu/FCLK_RESET1_N]
    
    # Clocks and interconnects
    connect_bd_net -net /sys_100m_clk [get_bd_pins sys_cpu/M_AXI_GP0_ACLK]
    connect_bd_intf_net -intf_net axi_cpu_interconnect_s00_axi [get_bd_intf_pins axi_cpu_interconnect/S00_AXI] [get_bd_intf_pins sys_cpu/M_AXI_GP0]
    
    mw_project_set sys_addr_cntrl_space [get_bd_addr_spaces sys_cpu/Data]
}

proc mw_add_cpu_axi_slave {{port 0} {ic_name {}} {clk sys_core_clk} {rstn sys_core_resetn}} {
    set cpu_type [mw_project_get cpu_type]
    set cpu_name [get_property "name" [mw_get_cpu]]
    switch $cpu_type {
        zynqmp_arm {
            set gpport [expr {$port + 2}]
            set_property -dict [list CONFIG.PSU__USE__S_AXI_GP${gpport} {1}] [mw_get_cpu]
            set slave_clk_pin [get_bd_pins ${cpu_name}/saxihp${port}_fpd_aclk]
            set slave_intf_pin [get_bd_intf_pins ${cpu_name}/S_AXI_HP${port}_FPD]
            set slave_seg [get_bd_addr_segs ${cpu_name}/SAXIGP${gpport}/HP${port}_DDR_LOW]
        }
        zynq7_arm {
            set_property -dict [list CONFIG.PCW_USE_S_AXI_HP${port} {1}] [mw_get_cpu]
            set slave_clk_pin [get_bd_pins ${cpu_name}/S_AXI_HP${port}_ACLK]
            set slave_intf_pin [get_bd_intf_pins ${cpu_name}/S_AXI_HP${port}]
            set slave_seg [get_bd_addr_segs ${cpu_name}/S_AXI_HP${port}/HP${port}_DDR_LOWOCM]
        }
        default {
            mw_error "Unsupported CPU type: $cpu_type"
        }
    }
    
    mw_connect_pin $clk $slave_clk_pin

    if { [llength $ic_name] == 0 } {
        set ic_name axi_cpu_slave_ic_${port}
    }

    set ic [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:* $ic_name]
    set_property -dict [list CONFIG.NUM_MI {1}] $ic
    set_property -dict [list CONFIG.S00_HAS_REGSLICE {4}] $ic
    set_property -dict [list CONFIG.M00_HAS_REGSLICE {4}] $ic

    mw_connect_pin ${clk} ${ic_name}/ACLK
    mw_connect_pin ${rstn} ${ic_name}/ARESETN
    
    mw_connect_pin ${clk} ${ic_name}/M00_ACLK
    mw_connect_pin ${rstn} ${ic_name}/M00_ARESETN
    mw_connect_pin ${ic_name}/M00_AXI $slave_intf_pin
    
    return [list $ic $slave_seg ]
}