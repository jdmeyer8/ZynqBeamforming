# Check for external GPIOs
set LEDPort [get_bd_ports GPLEDs]
set DIPPort [get_bd_ports DIPSwitches]
set PBPort  [get_bd_ports PushButtons]
set hasPBs  0
set hasDIPs 0
set hasLEDs 0
if { $LEDPort ne ""} { set hasLEDs 1 }
if { $DIPPort ne ""} { set hasDIPs 3 }
if { $PBPort  ne ""} { set hasPBs  9 }


if { $hasLEDs || $hasDIPs || $hasPBs } {

    set ioSum [expr {$hasLEDs + $hasDIPs + $hasPBs}]
    if { $boardName == "zed" } {
        set LED_OFFSET 19
        set DIP_OFFSET 11
        set PB_OFFSET  0
        set LED_WIDTH  7
        set DIP_WIDTH  8
        set PB_WIDTH   5
        if { $ioSum == 13 } {
            set ioBufStr1 "    .dio_t ({gpio_t[50:49], gpio_t[46:27], gpio_t[10:5]}),"
            set ioBufStr2 "    .dio_i ({gpio_o[50:49], gpio_o[46:27], gpio_o[10:5]}),"
            set ioBufStr3 "    .dio_o ({gpio_i[50:49], gpio_i[46:27], gpio_i[10:5]}),"
            set ioBufStr4 "              gpio_bd[31:27], gpio_bd[10:5]\}));"
        } elseif { $ioSum == 12 } {
            set ioBufStr1 "    .dio_t ({gpio_t[50:49], gpio_t[46:27], gpio_t[25:19], gpio_t[10:5]}),"
            set ioBufStr2 "    .dio_i ({gpio_o[50:49], gpio_o[46:27], gpio_o[25:19], gpio_o[10:5]}),"
            set ioBufStr3 "    .dio_o ({gpio_i[50:49], gpio_i[46:27], gpio_i[25:19], gpio_i[10:5]}),"
            set ioBufStr4 "              gpio_bd[31:27], gpio_bd[25:19], gpio_bd[10:5]\}));"
        } elseif { $ioSum == 10 } {
            set ioBufStr1 "    .dio_t ({gpio_t[50:49], gpio_t[46:27], gpio_t[18:5]}),"
            set ioBufStr2 "    .dio_i ({gpio_o[50:49], gpio_o[46:27], gpio_o[18:5]}),"
            set ioBufStr3 "    .dio_o ({gpio_i[50:49], gpio_i[46:27], gpio_i[18:5]}),"
            set ioBufStr4 "              gpio_bd[31:27], gpio_bd[18:5]\}));"
        } elseif { $ioSum == 9  } {
            set ioBufStr1 "    .dio_t ({gpio_t[50:49], gpio_t[46:27], gpio_t[25:5]}),"
            set ioBufStr2 "    .dio_i ({gpio_o[50:49], gpio_o[46:27], gpio_o[25:5]}),"
            set ioBufStr3 "    .dio_o ({gpio_i[50:49], gpio_i[46:27], gpio_i[25:5]}),"
            set ioBufStr4 "              gpio_bd[31:27], gpio_bd[25:5]\}));"
        } elseif { $ioSum == 4  } {
            set ioBufStr1 "    .dio_t ({gpio_t[50:49], gpio_t[46:27], gpio_t[10:0]}),"
            set ioBufStr2 "    .dio_i ({gpio_o[50:49], gpio_o[46:27], gpio_o[10:0]}),"
            set ioBufStr3 "    .dio_o ({gpio_i[50:49], gpio_i[46:27], gpio_i[10:0]}),"
            set ioBufStr4 "              gpio_bd[31:27], gpio_bd[10:0]\}));"
        } elseif { $ioSum == 3  } {
            set ioBufStr1 "    .dio_t ({gpio_t[50:49], gpio_t[46:27], gpio_t[25:19], gpio_t[10:0]}),"
            set ioBufStr2 "    .dio_i ({gpio_o[50:49], gpio_o[46:27], gpio_o[25:19], gpio_o[10:0]}),"
            set ioBufStr3 "    .dio_o ({gpio_i[50:49], gpio_i[46:27], gpio_i[25:19], gpio_i[10:0]}),"
            set ioBufStr4 "              gpio_bd[31:27], gpio_bd[25:19], gpio_bd[10:0]\}));"
        } elseif { $ioSum == 1  } {
            set ioBufStr1 "    .dio_t ({gpio_t[50:49], gpio_t[46:27], gpio_t[18:0]}),"
            set ioBufStr2 "    .dio_i ({gpio_o[50:49], gpio_o[46:27], gpio_o[18:0]}),"
            set ioBufStr3 "    .dio_o ({gpio_i[50:49], gpio_i[46:27], gpio_i[18:0]}),"
            set ioBufStr4 "              gpio_bd[31:27], gpio_bd[18:0]\}));"
        }  
    } elseif { $boardName == "zc706" } {
        if { $project == "fmcomms2" } { 
            set startBit 14 
        } elseif { $project == "fmcomms5" } { 
            set startBit 59 
        }
        set LED_OFFSET 7
        set DIP_OFFSET 0
        set PB_OFFSET  4
        set LED_WIDTH  3
        set DIP_WIDTH  4
        set PB_WIDTH   3
        if { $ioSum == 13 } {
            set ioBufStr1 "    .dio_t (gpio_t[$startBit:11]),"
            set ioBufStr2 "    .dio_i (gpio_o[$startBit:11]),"
            set ioBufStr3 "    .dio_o (gpio_i[$startBit:11]),"
            set ioBufStr4 "            gpio_bd[14:11]));"
        } elseif { $ioSum == 12 } {
            set ioBufStr1 "    .dio_t ({gpio_t[$startBit:11], gpio_t[9:7]}),"
            set ioBufStr2 "    .dio_i ({gpio_o[$startBit:11], gpio_o[9:7]}),"
            set ioBufStr3 "    .dio_o ({gpio_i[$startBit:11], gpio_i[9:7]}),"
            set ioBufStr4 "            gpio_bd[$14:11], gpio_bd[9:7]\}));"
        } elseif { $ioSum == 10 } {
            set ioBufStr1 "    .dio_t ({gpio_t[$startBit:11], gpio_t[3:0]}),"
            set ioBufStr2 "    .dio_i ({gpio_o[$startBit:11], gpio_o[3:0]}),"
            set ioBufStr3 "    .dio_o ({gpio_i[$startBit:11], gpio_i[3:0]}),"
            set ioBufStr4 "            gpio_bd[14:11], gpio_bd[3:0]\}));"
        } elseif { $ioSum == 9  } {
            set ioBufStr1 "    .dio_t ({gpio_t[$startBit:11], gpio_t[9:7], gpio_t[3:0]}),"
            set ioBufStr2 "    .dio_i ({gpio_o[$startBit:11], gpio_o[9:7], gpio_o[3:0]}),"
            set ioBufStr3 "    .dio_o ({gpio_i[$startBit:11], gpio_i[9:7], gpio_i[3:0]}),"
            set ioBufStr4 "            gpio_bd[14:11], gpio_bd[9:7], gpio_bd[3:0]\}));"
        } elseif { $ioSum == 4  } {
            set ioBufStr1 "    .dio_t ({gpio_t[$startBit:11], gpio_t[6:4]}),"
            set ioBufStr2 "    .dio_i ({gpio_o[$startBit:11], gpio_o[6:4]}),"
            set ioBufStr3 "    .dio_o ({gpio_i[$startBit:11], gpio_i[6:4]}),"
            set ioBufStr4 "            gpio_bd[14:11], gpio_bd[6:4]\}));"
        } elseif { $ioSum == 3  } {
            set ioBufStr1 "    .dio_t ({gpio_t[$startBit:11], gpio_t[9:4]}),"
            set ioBufStr2 "    .dio_i ({gpio_o[$startBit:11], gpio_o[9:4]}),"
            set ioBufStr3 "    .dio_o ({gpio_i[$startBit:11], gpio_i[9:4]}),"
            set ioBufStr4 "            gpio_bd[14:11], gpio_bd[9:4]\}));"
        } elseif { $ioSum == 1  } {
            set ioBufStr1 "    .dio_t ({gpio_t[$startBit:11], gpio_t[6:0]}),"
            set ioBufStr2 "    .dio_i ({gpio_o[$startBit:11], gpio_o[6:0]}),"
            set ioBufStr3 "    .dio_o ({gpio_i[$startBit:11], gpio_i[6:0]}),"
            set ioBufStr4 "            gpio_bd[14:11], gpio_bd[6:0]\}));"
        }  
    } elseif { $boardName == "ccfmc_lvds" } {
        set LED_OFFSET 5
        set DIP_OFFSET 8 
        set PB_OFFSET  0
        set LED_WIDTH  3
        set DIP_WIDTH  4 
        set PB_WIDTH   4
        if { $ioSum == 13 } {
            set ioBufStr1 "   .dio_t (gpio_t[20:12]),"
            set ioBufStr2 "   .dio_i (gpio_o[20:12]),"
            set ioBufStr3 "   .dio_o (gpio_i[20:12]),"
            set ioBufStr4 "   .dio_p (gpio_bd[20:12]));"
        } elseif { $ioSum == 12 } {
            set ioBufStr1 "   .dio_t ({gpio_t[20:12], gpio_t[7:5]}),"
            set ioBufStr2 "   .dio_i ({gpio_o[20:12], gpio_o[7:5]}),"
            set ioBufStr3 "   .dio_o ({gpio_i[20:12], gpio_i[7:5]}),"
            set ioBufStr4 "   .dio_p ({gpio_bd[20:12], gpio_bd[7:5]}));"
        } elseif { $ioSum == 10 } {
            set ioBufStr1 "   .dio_t (gpio_t[20:8]),"
            set ioBufStr2 "   .dio_i (gpio_o[20:8]),"
            set ioBufStr3 "   .dio_o (gpio_i[20:8]),"
            set ioBufStr4 "   .dio_p (gpio_bd[20:8]));"
        } elseif { $ioSum == 9  } {
            set ioBufStr1 "   .dio_t (gpio_t[20:5]),"
            set ioBufStr2 "   .dio_i (gpio_o[20:5]),"
            set ioBufStr3 "   .dio_o (gpio_i[20:5]),"
            set ioBufStr4 "   .dio_p (gpio_bd[20:5]));"
        } elseif { $ioSum == 4  } {
            set ioBufStr1 "   .dio_t ({gpio_t[20:12], gpio_t[3:0]}),"
            set ioBufStr2 "   .dio_i ({gpio_o[20:12], gpio_o[3:0]}),"
            set ioBufStr3 "   .dio_o ({gpio_i[20:12], gpio_i[3:0]}),"
            set ioBufStr4 "   .dio_p ({gpio_bd[20:12], gpio_bd[3:0]}));"
        } elseif { $ioSum == 3  } {
            set ioBufStr1 "   .dio_t ({gpio_t[20:12], gpio_t[7:5], gpio_t[3:0]}),"
            set ioBufStr2 "   .dio_i ({gpio_o[20:12], gpio_o[7:5], gpio_o[3:0]}),"
            set ioBufStr3 "   .dio_o ({gpio_i[20:12], gpio_i[7:5], gpio_i[3:0]}),"
            set ioBufStr4 "   .dio_p ({gpio_bd[20:12], gpio_bd[7:5], gpio_bd[3:0]}));"
        } elseif { $ioSum == 1  } {
            set ioBufStr1 "   .dio_t ({gpio_t[20:8], gpio_t[3:0]}),"
            set ioBufStr2 "   .dio_i ({gpio_i[20:8], gpio_i[3:0]}),"
            set ioBufStr3 "   .dio_o ({gpio_o[20:8], gpio_o[3:0]}),"
            set ioBufStr4 "   .dio_p ({gpio_bd[20:8], gpio_bd[3:0]}));"
        }  
    }
    
    set dutConstrFile [ get_files -of [get_filesets {constrs_1}] ]
    remove_files -fileset constrs_1 $dutConstrFile

    set firstLED $LED_OFFSET
    set lastLED [ expr {$LED_OFFSET + $LED_WIDTH - 1} ]
    set firstDIP $DIP_OFFSET
    set lastDIP [ expr {$DIP_OFFSET + $DIP_WIDTH - 1} ]
    set firstPB  $PB_OFFSET
    set lastPB  [ expr {$PB_OFFSET + $PB_WIDTH - 1} ]
    
    set ledStr ""
    set dipStr ""
    set pbStr  ""
    set dw 0
    set minOff 0
    set maxOff 0
    # Create insertion string, and calculate required GPIO datawidth
    if { $hasLEDs } { 
        set ledStr "    .GPLEDs (gpio_bd[$lastLED:$firstLED]),\n" 
        set dw [ expr { $dw + $LED_WIDTH } ]
    }
    if { $hasDIPs } { 
        set dipStr "    .DIPSwitches (gpio_bd[$lastDIP:$firstDIP]),\n" 
        set dw [ expr { $dw + $DIP_WIDTH } ]
    }
    if { $hasPBs } { 
        set pbStr "    .PushButtons (gpio_bd[$lastPB:$firstPB]),\n"
        set dw [ expr { $dw + $PB_WIDTH } ]
    }
    set insertStr $ledStr$dipStr$pbStr 
 
    # find system_top.v
    set foundIOBuf 0
    set sysTop [ get_files system_top.v ]
    set topF [ open $sysTop r+ ]
    set newTop [ open $sysTop.new w ]
    while {[gets $topF line] >= 0} {
        if { [string first "system_wrapper i_system_wrapper" $line] != -1 } {
             puts $newTop $line 
             puts $newTop $insertStr
        } elseif { [string first "i_iobuf_bd" $line] != -1 } {
             regexp {[0-9]+} $line oldDw
             set newDW [ expr { $oldDw - $dw } ]
             set newLine "   ad_iobuf #(.DATA_WIDTH($newDW)) i_iobuf_bd ("
             puts $newTop $newLine
             set foundIOBuf 1
        } elseif { [string first ", gpio_t" $line] != -1 &&  $foundIOBuf == 1 } {
            puts $newTop $ioBufStr1 
        } elseif { [string first ", gpio_i" $line] != -1 &&  $foundIOBuf == 1 } {
            puts $newTop $ioBufStr2 
        } elseif { [string first ", gpio_o" $line] != -1 &&  $foundIOBuf == 1 } {
            puts $newTop $ioBufStr3
        } elseif { [string first "gpio_bd" $line] != -1 &&  $foundIOBuf == 1 } {
            puts $newTop $ioBufStr4
            set foundIOBuf 0
        } else {
            puts $newTop $line
        }
    }
    close $newTop
    close $topF

    file rename -force $sysTop $sysTop.old
    file rename -force $sysTop.new $sysTop
}
