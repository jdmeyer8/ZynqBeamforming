set vClk [get_clocks -quiet "VirtClk_*"]

if { [llength ${vClk}] > 0 } {
    set period_ns [get_property period $vClk]
    
    set clk_in_pin [get_pins -hierarchical *util_mw_clkconstr*/clk]
    set clk_in [get_clocks clk_div_sel*]
    if { [llength $clk_in] == 0 } {
        set clk_net [get_nets -of_objects [get_pins ${clk_in_pin}]]
        create_clock -period $period_ns $clk_net
    } else {
        set groupCmd "set_clock_groups -logically_exclusive"
        foreach clk $clk_in {
            set name [get_property NAME $clk]
            set net [get_nets -of_objects [get_clocks ${clk}]]
            create_clock -name $name -period $period_ns $net
            set groupCmd "$groupCmd -group {$name}"
        }
        if { [llength $clk_in] > 1 } {
            eval $groupCmd
        }
		set clk_in_1 [get_clocks clk_fpga_0]
		if { [llength $clk_in_1] == 1 } {	
			set groupCmd_1 "set_clock_groups -asynchronous"
			set groupCmd_1 "$groupCmd_1 -group {$clk_in}"
			set groupCmd_1 "$groupCmd_1 -group {$clk_in_1}"
			eval $groupCmd_1
		}	
		
    }
}
