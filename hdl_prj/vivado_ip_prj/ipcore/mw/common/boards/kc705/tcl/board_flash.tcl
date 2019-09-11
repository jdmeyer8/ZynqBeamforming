
proc kc705_build_mcs { } {
    global MCSFILE
    global PRJNAME
    set bitFile system_wrapper.bit
    set bitPath [get_property DIRECTORY [current_project]]/${PRJNAME}.runs/impl_1/${bitFile}
    
    
    
    file copy -force $bitPath ./$bitFile
    write_cfgmem -force -format MCS -size 128 -interface BPIx16 -loadbit "up 0x00000000 $bitFile" $MCSFILE
}

proc kc705_program_mcs {} {
    global MCSFILE
    
    set hwDev [lindex [get_hw_devices] 0]
    current_hw_device $hwDev
    refresh_hw_device -update_hw_probes false $hwDev
    set bpiDev [create_hw_cfgmem -hw_device $hwDev -mem_dev  [lindex [get_cfgmem_parts {28f00ap30t-bpi-x16}] 0]]
    
    set_property PROGRAM.BLANK_CHECK  0 $bpiDev
    set_property PROGRAM.ERASE  1 $bpiDev
    set_property PROGRAM.CFG_PROGRAM  1 $bpiDev
    set_property PROGRAM.VERIFY  1 $bpiDev
    set_property PROGRAM.ADDRESS_RANGE  {use_file} $bpiDev
    set_property PROGRAM.FILES $MCSFILE $bpiDev
    set_property PROGRAM.UNUSED_PIN_TERMINATION {pull-none} $bpiDev
    set_property PROGRAM.BPI_RS_PINS {25:24} $bpiDev
    set_property PROGRAM.BLANK_CHECK  0 $bpiDev
    set_property PROGRAM.ERASE  1 $bpiDev
    set_property PROGRAM.CFG_PROGRAM  1 $bpiDev
    set_property PROGRAM.VERIFY  1 $bpiDev
    
    create_hw_bitstream -hw_device $hwDev [get_property PROGRAM.HW_CFGMEM_BITFILE $hwDev]
    program_hw_devices $hwDev

    program_hw_cfgmem -hw_cfgmem [get_property PROGRAM.HW_CFGMEM $hwDev]
}

proc kc705_program_bit {} {
    global PRJNAME
    
    set hwDev [lindex [get_hw_devices] 0]
    set implDir [get_property DIRECTORY [current_project]]/${PRJNAME}.runs/impl_1
    
    set_property PROGRAM.FILE ${implDir}/system_wrapper.bit $hwDev
    set_property PROBES.FILE  ${implDir}/debug_nets.ltx $hwDev
    program_hw_devices $hwDev

}

proc connect_hw {} {
    global TGTDEV
    open_hw
    #connect_hw_server -host localhost -port 60001 -url localhost:3121
    catch { 
        connect_hw_server -url localhost:3121
        
        set tgts [get_hw_targets]
        foreach tgt $tgts {
            current_hw_target $tgt
            set_property PARAM.FREQUENCY 15000000 $tgt
            open_hw_target
            if {  [llength [get_hw_devices ${TGTDEV}]] > 0 } {
                break
            }
            close_hw_target
        }
    }
}

proc disconnect_hw {} {
    disconnect_hw_server
    close_hw
}

set TGTDEV xc7k325t_0
set PRJNAME [get_property NAME [current_project]]
set MCSFILE [get_property DIRECTORY [current_project]]/system_wrapper.mcs
kc705_build_mcs
connect_hw
kc705_program_mcs
kc705_program_bit
disconnect_hw
