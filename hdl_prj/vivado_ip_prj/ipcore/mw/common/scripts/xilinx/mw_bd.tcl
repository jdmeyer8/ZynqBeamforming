source $commonDir/scripts/xilinx/mw_bd_zynq.tcl
source $commonDir/scripts/xilinx/mw_bd_fpga.tcl

proc mw_default_bd { {core_freq 50.0} } {
    switch [mw_project_get cpu_type] {
        zynqmp_arm -
        zynq7_arm {
            mw_default_bd_zynq $core_freq
        }
        kintex7_pcie {
            mw_default_bd_pcie $core_freq
        }
    }
}

proc mw_create_clockwiz { name srcclk srcrst clk_freq } {
    set clkwiz_name "${name}_clkwiz"
    set clkwiz [create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:* $clkwiz_name]
    set_property -dict [list CONFIG.PRIM_SOURCE {Global_buffer}] $clkwiz
    set_property -dict [list CONFIG.RESET_TYPE {ACTIVE_LOW}] $clkwiz
    set_property -dict [list CONFIG.CLKOUT1_REQUESTED_OUT_FREQ $clk_freq] $clkwiz
    connect_bd_net -net [mw_getnet $srcclk] [get_bd_pins $clkwiz_name/clk_in1]
    connect_bd_net -net [mw_getnet $srcrst] [get_bd_pins $clkwiz_name/resetn]

    return $clkwiz

}

proc mw_create_dummy_slave { {ic_port 0} } {

    set dummy_name axi_gpio_dummy_0
    set dummy_obj [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:* $dummy_name]
    set_property -dict [list CONFIG.C_GPIO_WIDTH {1} CONFIG.C_ALL_OUTPUTS {1}] $dummy_obj
    set_property -dict [list CONFIG.C_GPIO2_WIDTH {1} CONFIG.C_IS_DUAL {1} CONFIG.C_ALL_INPUTS_2 {1}] $dummy_obj

    mw_connect_pin [mw_project_get ipcore_clk_net] $dummy_name/s_axi_aclk
    mw_connect_pin [mw_project_get ipcore_rstn_net] $dummy_name/s_axi_aresetn
    mw_connect_pin $dummy_name/gpio_io_o $dummy_name/gpio2_io_i
    
    mw_add_cpu_slave $dummy_name [mw_project_get mw_ip_baseaddr] $ic_port
    
    return $dummy_obj
}

proc mw_add_axi_dma {name {rd_en 1} {wr_en 1}} {
    set axi_dma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:* $name ]
    set_property -dict [ list CONFIG.c_sg_include_stscntrl_strm {0}  ] $axi_dma

    if {!$rd_en} {
        set_property -dict [list CONFIG.c_include_mm2s {0}] $axi_dma
    }

    if {!$wr_en} {
        set_property -dict [list CONFIG.c_include_s2mm {0}] $axi_dma
    }

    return $axi_dma
}

proc mw_get_sys_addr_cntrl_space {} {
    set addr_space [mw_project_get sys_addr_cntrl_space]
    
    if { [llength $addr_space] == 0 } {
        set sys_cpu [mw_get_cpu]
        set addr_space [get_bd_addr_spaces -of_objects $sys_cpu]
    }
    
    if { [llength $addr_space] == 0 } {
        set addr_space [get_bd_addr_spaces -filter "PATH =~ [mw_get_cpu]/Data"]
    }
    
    return $addr_space
}


proc mw_bd_export {filename} {
    save_bd_design
    #validate block design is commented since vivado 2017.4 error out unconnected AXI Master interface g1732687 
    #validate_bd_design

    write_bd_tcl [mw_get_output_dir]/$filename
}

proc mw_add_ic_slave_port { ic } {
    set ic_name [get_property NAME $ic]
    
    set NUM_SI [get_property CONFIG.NUM_SI $ic]
    set NUM_SI [expr $NUM_SI + 1]
    set SI_IDX [format %02d [expr $NUM_SI -1]]
    set_property -dict [list CONFIG.NUM_SI $NUM_SI] $ic
    set_property -dict [list CONFIG.S${SI_IDX}_HAS_REGSLICE {4}] $ic
}

proc mw_add_interconnect_slave {ic_name bd_slave {ic_port "auto"} {regslice 4} {datafifo 0}} {

    set ic_obj [get_bd_cells $ic_name]
    set slave_info [mw_s_axi_info $bd_slave]
    set dst_port [get_bd_intf_pins [lindex $slave_info 0]]
    set clk_net [get_bd_nets -of_objects [lindex $slave_info 1]]
    set rst_net [get_bd_nets -of_objects [lindex $slave_info 2]]

    set NUM_MI [get_property CONFIG.NUM_MI $ic_obj]
    if {$ic_port == "auto"} {
        set ic_port $NUM_MI
    }
    if { $NUM_MI <= $ic_port } {
        set NUM_MI [expr $ic_port + 1]
        set_property -dict [list CONFIG.NUM_MI $NUM_MI] $ic_obj
    }
    set MI_IDX [format %02d $ic_port]

    set_property -dict [list CONFIG.M${MI_IDX}_HAS_REGSLICE $regslice] $ic_obj
    set_property -dict [list CONFIG.M${MI_IDX}_HAS_DATA_FIFO $datafifo] $ic_obj 

    set m_clk_pin [get_bd_pins ${ic_name}/M${MI_IDX}_ACLK]
    set m_rst_pin [get_bd_pins ${ic_name}/M${MI_IDX}_ARESETN]

    mw_disconnect_pin ${ic_name}/M${MI_IDX}_AXI
    mw_disconnect_pin $m_clk_pin
    mw_disconnect_pin $m_rst_pin
    connect_bd_net -net $clk_net $m_clk_pin
    connect_bd_net -net $rst_net $m_rst_pin
    
    connect_bd_intf_net [get_bd_intf_pins ${ic_name}/M${MI_IDX}_AXI] $dst_port

}

proc mw_add_cpu_slave {bd_slave offset {ic_port "auto"} {regslice 4} {datafifo 0}} {
    mw_add_interconnect_slave [mw_project_get axi_cpu_interconnect] $bd_slave $ic_port $regslice $datafifo 
    
    set slave_info [mw_s_axi_info $bd_slave]
    set addr_seg [lindex $slave_info 3]
    # Minimum range is 4k
    set range [expr max([get_property RANGE $addr_seg],4096)]
    create_bd_addr_seg -range $range -offset $offset [mw_get_sys_addr_cntrl_space]  $addr_seg  SEG_data_${bd_slave}
}

proc mw_s_axi_info {bd_cell_name} {
    set bd_cell [get_bd_cells $bd_cell_name]
    set s_axi [get_bd_intf_pins -filter \
    "MODE == Slave  && VLNV == xilinx.com:interface:aximm_rtl:1.0" \
    -of_objects $bd_cell]
    set s_axi_pin [lrange [split $s_axi "/"] end end]
    set s_axi_clk [get_bd_pins -filter "TYPE == clk && (CONFIG.ASSOCIATED_BUSIF == ${s_axi_pin} || \
    CONFIG.ASSOCIATED_BUSIF =~ ${s_axi_pin}:* || CONFIG.ASSOCIATED_BUSIF =~ *:${s_axi_pin} || \
    CONFIG.ASSOCIATED_BUSIF =~ *:${s_axi_pin}:*)" -quiet -of_objects $bd_cell]
    set s_axi_clk [get_bd_pins [mw_list_reduce $s_axi_clk ".*${s_axi_pin}.*"]]
    set s_axi_rst [get_bd_pins -filter "TYPE == rst && (CONFIG.ASSOCIATED_BUSIF == ${s_axi_pin} || \
    CONFIG.ASSOCIATED_BUSIF =~ ${s_axi_pin}:* || CONFIG.ASSOCIATED_BUSIF =~ *:${s_axi_pin} || \
    CONFIG.ASSOCIATED_BUSIF =~ *:${s_axi_pin}:*)" -quiet -of_objects $bd_cell]
    if {($s_axi_clk ne "") && ($s_axi_rst eq "")} {
        set s_axi_rst [get_property CONFIG.ASSOCIATED_RESET [get_bd_pins ${s_axi_clk}]]
        if {$s_axi_rst ne ""} {
            set s_axi_rst [get_bd_pins ${bd_cell_name}/$s_axi_rst]
        }
        if {$s_axi_rst eq ""} {
            # Find a reset pin with the same root
            set clkPin [lrange [split $s_axi_clk "/"] end end]
            set clkRoot ""
            regexp -all "(.*?)_?\[:alpha:\]*clk.*" $clkPin -> clkRoot
            set s_axi_rst [get_bd_pins -of_objects $bd_cell -regexp -filter [subs -nobackslashes -nocommands {NAME =~ ".*${clkRoot}.*re?se?t.*"}]]
        }
    }
    if {$s_axi_rst eq ""} {
        # Find any reset pin
        set s_axi_rst [get_bd_pins -of_objects $bd_cell -regexp -filter {NAME =~ ".*re?se?t.*"}]
    }
    set s_axi_rst [get_bd_pins [mw_list_reduce $s_axi_rst ".*${s_axi_pin}.*"]]

    set s_addr_seg [get_bd_addr_segs -of_objects [get_bd_intf_pins $s_axi]]

    return [list $s_axi $s_axi_clk $s_axi_rst $s_addr_seg]
}

proc mw_create_const {name width value} {
    set const_name const_${name}
    set const_block [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:* $const_name]
    set_property -dict [list CONFIG.CONST_WIDTH $width] $const_block
    set_property -dict [list CONFIG.CONST_VAL $value] $const_block
    connect_bd_net -net $const_name [get_bd_pins ${const_name}/dout]
    
    return $const_block
}

proc mw_logic {name op in1 {out {}} {in2 {}} {size 1} } {
    set lname logic_${op}_${name}
    
    set logic_cell [create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:* $lname]
    set_property -dict [list CONFIG.C_SIZE $size] $logic_cell
    set_property -dict [list CONFIG.C_OPERATION $op] $logic_cell
    connect_bd_net -net [mw_getnet $in1] [get_bd_pins $lname/Op1]
    if { [llength $in2] > 0 } {
        connect_bd_net -net [mw_getnet $in2] [get_bd_pins $lname/Op2]
    }
    if { [llength $out] > 0 } {
        connect_bd_net -net [mw_getnet $out] [get_bd_pins $lname/Res]
    } else {
        connect_bd_net -net ${lname}_Res [get_bd_pins $lname/Res]
    }
    return [mw_getnet [get_bd_pins $lname/Res]]
}

proc mw_list_reduce {lst filter} {
    if { [llength $lst] > 1 } {
        set found_item [lsearch -inline -regexp $lst ${filter}]
        if {[llength $found_item] > 0} {
            set lst [lindex $found_item 0]
        } else {
            set lst [lindex $found_item 0]    
        }
    }
    return $lst
}

proc mw_get_cpu {} {
    set sys_cpu [mw_project_get sys_cpu]
    if { [llength $sys_cpu] == 0 } {
        set sys_cpu [get_bd_cells -hierarchical -filter {VLNV=~"xilinx.com:ip:processing_system7:*" || VLNV=~"xilinx.com:ip:zynq_ultra_ps_e:*"}]
    }
    return $sys_cpu
}

proc mw_get_intr_concat {{intr_num 0}} {
    set intr_concat [mw_project_get intr_concat]
    set cpu_type [mw_project_get cpu_type]
    
    if {[llength $intr_concat] == 0} {
        # Find the INTC if needed
        set cpu_name [get_property "name" [mw_get_cpu]]
        switch $cpu_type {
            zynqmp_arm {
                if { $intr_num < 8 } {
                    set intr_ports ${cpu_name}/pl_ps_irq0
                } else {
                    set intr_ports ${cpu_name}/pl_ps_irq1
                }
            }
            zynq7_arm {
                set intr_ports ${cpu_name}/IRQ_F2P
            }
            kintex7_pcie {
                set intr_ports 
            }
            default {
                mw_error "Unsupported CPU type: $cpu_type"
            }
        }
        set irq_src [get_bd_pins -of_objects [mw_getnet $intr_ports] -filter {DIR == O}]
        set intr_concat [get_bd_cells -of_objects $irq_src]
    }
    switch $cpu_type {
        #Remap the interrupt number if needed
        zynqmp_arm {
            if { $intr_num >= 8 } {
                set intr_num [expr $intr_num - 8]
            }
        }
    }
    return [list $intr_concat $intr_num]
}

proc mw_connect_intr {src_pin intr_num} {
    set intr_info [mw_get_intr_concat $intr_num]
    set intr_concat [lindex $intr_info 0]
    set intr_num [lindex $intr_info 1]
    set intr_concat_name [get_property "name" $intr_concat]
    
    set intr_pin ${intr_concat_name}/In${intr_num}
    mw_disconnect_pin $intr_pin
    mw_connect_pin $src_pin $intr_pin
}

proc mw_rstsync {name sync_clk {ext_rst {} } {locked {} } } {
    set rstgen_name ${name}_rstgen
    set rstgen [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:* $rstgen_name]
    set_property -dict [list CONFIG.C_EXT_RST_WIDTH {1}] $rstgen

    connect_bd_net -net [mw_getnet $sync_clk] [get_bd_pins ${rstgen_name}/slowest_sync_clk]
    if { [llength $ext_rst] > 0 } {
        connect_bd_net -net [mw_getnet $ext_rst] [get_bd_pins ${rstgen_name}/ext_reset_in]
    }
    if { [llength $locked] > 0 } {
        connect_bd_net -net [mw_getnet $locked] [get_bd_pins ${rstgen_name}/dcm_locked]
    }

    connect_bd_net -net ${name}_resetn [get_bd_pins ${rstgen_name}/peripheral_aresetn]
    connect_bd_net -net ${name}_interconnect_resetn [get_bd_pins ${rstgen_name}/interconnect_aresetn]
    connect_bd_net -net ${name}_reset [get_bd_pins ${rstgen_name}/peripheral_reset]

    return $rstgen
}

proc mw_getnet {pin_net {create_net true}} {
    # check if its a pin or port
    set pin [mw_get_pin_port $pin_net]
    if { [llength $pin] == 0 } {
        # check if its a net
        set net [mw_get_net_from_name $pin_net]
        if { [llength $net] == 0 } {
            mw_error "Could not find pin/port/net: ${pin_net}"
        } else {
            return $net
        }
    }
    # Found a pin or port, check if it's connected
    set net [mw_get_net_of_pin $pin]    
    # check if there's already a net attached
    if { [llength $net] > 0 || ! $create_net} {
        return $net
    } else {
        # create and attach a new net
        
        set netName [join [list [regsub {^[^[:alpha:]]} [regsub -all {/} $pin {_}] {}] "_net"] ""]
        if { [mw_is_intf $pin] } {
            set net [create_bd_intf_net ${netName}_intf]
            connect_bd_intf_net -intf_net $net $pin
        } else {
            set net [create_bd_net $netName]
            connect_bd_net -net $net $pin
        }
        return $net
    }
}

proc mw_cleanup_orphans {{netlimit 1}} {
    set cleaned 1
    set iters 0
    while {$cleaned > 0 && $iters < 5} {
        set cleaned [mw_cleanup_orphan_cells]
        incr cleaned [mw_cleanup_orphan_nets $netlimit]
        incr iters
    }
}

proc mw_cleanup_orphan_nets {{netlimit 1}} {
    set netlimit [expr $netlimit + 1]
    set allNets [get_bd_nets]
    set cleaned 0
    foreach net $allNets {
        set pins [get_bd_pins -quiet -of_objects $net]
        set ports [get_bd_ports -quiet -of_objects $net]
        set numConnections [expr [llength $pins] + [llength $ports]]
        if { $numConnections < $netlimit} {
            puts "Deleting orphan net $net"
            delete_bd_objs $net
            incr cleaned
        }
    }
    
    set allNets [get_bd_intf_nets]
    foreach net $allNets {
        set pins [get_bd_intf_pins -quiet -of_objects $net]
        set ports [get_bd_intf_ports -quiet -of_objects $net]
        set numConnections [expr [llength $pins] + [llength $ports]]
        if { $numConnections < $netlimit} {
            puts "Deleting orphan net $net"
            delete_bd_objs $net
            incr cleaned
        }
    }
    
    return $cleaned
}

proc mw_cleanup_orphan_cells {} {
    set allCells [get_bd_cells]
    set cleaned 0
    foreach cell $allCells {
        if {[mw_cell_is_dangling $cell]} {
            puts "Removing orphan cell $cell"
            delete_bd_objs $cell
            incr cleaned
        }
    }
    return $cleaned
}

proc mw_cell_is_dangling {cell_name} {
    set cell [get_bd_cells $cell_name]
    set opins [get_bd_pins -of_objects $cell -filter {DIR == O} -quiet]
    set onets [get_bd_nets -of_objects $opins -quiet]
    set ipins [get_bd_pins -of_objects $onets -filter {DIR == I} -quiet]
    
    if {[llength $ipins] > 0} {
        return false
    }
    
    set ifpins [get_bd_intf_pins -of_objects $cell -quiet]
    set ifnets [get_bd_intf_nets -of_objects $ifpins -quiet]
    foreach ifn $ifnets {
        set if_pins [get_bd_intf_pins -of_objects $ifn]
        if {[llength $if_pins] > 1} {
            return false
        }
    }
    
    return true
}

proc mw_is_intf {pin_net} {
    set ipin [get_bd_intf_pins -quiet $pin_net]
    set iports [get_bd_intf_ports -quiet $pin_net]
    set inets [get_bd_intf_nets -quiet $pin_net]
    set intf [expr [llength $ipin] + [llength $iports] + [llength $inets]]
    if { $intf > 0 } {
        return true 
    } else {
        return false
    }
}

proc mw_get_net_of_pin {pin} {
    set pin [mw_get_pin_port $pin]
    set net [get_bd_nets -of_objects $pin -quiet]
    if { [llength $net] == 0 } {
        set net [get_bd_intf_nets -of_objects $pin -quiet]
    }
    return $net
}

proc mw_get_net_from_name {net_name} {    
    set net [get_bd_nets -quiet $net_name]
    if { [llength $net] == 0 } {
        set net [get_bd_intf_nets -quiet $net_name]
    }
    return $net
}

proc mw_get_pin_port {pin_port} {
    # check if its a port
    set pin [get_bd_ports -quiet $pin_port]
    if { [llength $pin] == 0 } {
        # check if its a pin
        set pin [get_bd_pins -quiet $pin_port]
    }
    
    if { [llength $pin] == 0 } {
        # check if its a intf pin
        set pin [get_bd_intf_pins -quiet $pin_port]
    }
    
    if { [llength $pin] == 0 } {
        # check if its a intf port
        set pin [get_bd_intf_ports -quiet $pin_port]
    }
    
    return $pin
}

proc mw_is_input {pin_port} {
    set pin [mw_get_pin_port $pin_port]
    if { [llength $pin] == 0 } {
        return 0
    }
    set dir [get_property DIR $pin]
    if {$dir == "I"} {
        return 1
    } else {
        return 0
    }    
}

proc mw_is_net {pin_net} {
    set net [mw_getnet $pin_net false]
    if { [llength $net] > 0 } {
        return true
    } else {
        return false
    }
}

proc mw_connect_pin {pin_net1 pin_net2} {
    
    set isNet1 [mw_is_net $pin_net1]
    set isNet2 [mw_is_net $pin_net2]
    
    if { $isNet1 && $isNet2 } {
        mw_error "$pin_net1 and $pin_net2 both have existing nets"
    }
    
    if { [mw_is_intf $pin_net1] } {
        # Cannot have dangling nets on intf pins
        connect_bd_intf_net [mw_get_pin_port $pin_net1] [mw_get_pin_port $pin_net2]
        return
    }
    
    if { ! ($isNet1 || $isNet2) } {
        # No nets are attached, both are unconnected pins
        if { [mw_is_input $pin_net1] } {
            # Attach a net to the output pin
            set netArg [mw_getnet $pin_net2]
            # Connect to the input pin
            set pinArg [mw_get_pin_port $pin_net1]
        } else {
            # Attach a net to the output pin
            set netArg [mw_getnet $pin_net1]
            # Connect to the input pin
            set pinArg [mw_get_pin_port $pin_net2]
        }
    } elseif { $isNet1 } {
        # Pin1 has a net attached
        set netArg [mw_getnet $pin_net1]
        # Connect to the other net
        set pinArg [mw_get_pin_port $pin_net2]
    } else {
        # Pin2 has a net attached
        set netArg [mw_getnet $pin_net2]
        # Connect to the other net
        set pinArg [mw_get_pin_port $pin_net1]
    }
    connect_bd_net -net $netArg $pinArg
}

proc mw_is_connected {pin} {
    set pin_obj [mw_get_pin_port $pin]
    set net [get_bd_nets -quiet -of_objects $pin_obj]
    set intf_net [get_bd_intf_nets -quiet -of_objects $pin_obj]
    set numConnections [expr [llength $net] + [llength $intf_net]]
    if { $numConnections > 0 } {
        return 1
    } else {
        return 0
    }
}

proc mw_disconnect_pin {pin} {
    set pin_obj [mw_get_pin_port $pin]
    if { [mw_is_connected $pin_obj] } {
        set net [mw_get_net_of_pin $pin_obj]
        if {[mw_is_intf $pin_obj]} {
            set pins [get_bd_intf_pins -quiet -of_objects $net]
            set ports [get_bd_intf_ports -quiet -of_objects $net]
        } else {
            set pins [get_bd_pins -quiet -of_objects $net]
            set ports [get_bd_ports -quiet -of_objects $net]
        }
        set numConnections [expr [llength $pins] + [llength $ports]]
        if { $numConnections == 1 } {
            delete_bd_objs $net
        } else {
            if {[mw_is_intf $pin_obj]} {
                disconnect_bd_intf_net $net $pin_obj
            } else {
                disconnect_bd_net $net $pin_obj
            }
        }
    }
}

proc mw_bd_set_project_defaults {} {
    mw_project_set ipcore_clk_net [get_bd_nets sys_core_clk]
    mw_project_set ipcore_rstn_net [get_bd_nets sys_core_resetn]
    mw_project_set ipcore_rst_net [get_bd_nets sys_core_reset]
    mw_project_set axi_cpu_interconnect [get_bd_cells axi_cpu_interconnect]
    mw_project_set sys_cpu [mw_get_cpu]
    mw_project_set sys_addr_cntrl_space [mw_get_sys_addr_cntrl_space]
}

proc mw_bd_save {} {
    regenerate_bd_layout
    save_bd_design
    #removing validate_bd_design for issues with Vivado 2017.4 regarding
    #unconnected AXI4 master connnection
    #validate_bd_design
    save_bd_design
}

