# Add the clocking core
set util_mw_clkconstr [create_bd_cell -type ip \
    -vlnv mathworks.com:user:util_mw_clkconstr:* util_mw_clkconstr]

mw_disconnect_pin util_ad9361_divclk/clk_out
mw_connect_pin util_mw_clkconstr/clk_out util_ad9361_divclk_clk_out
mw_connect_pin util_mw_clkconstr/clk util_ad9361_divclk/clk_out

set_property CONFIG.CLKOUT0_REQUESTED_OUT_FREQ $DUT_DATA_RATE_MHZ $util_mw_clkconstr

# Fixup the constraints
set clk_tcl [add_files -norecurse -fileset sources_1 $mw_ad9361/common/mw_clk_constr.tcl]
set_property PROCESSING_ORDER LATE $clk_tcl

mw_cleanup_orphan_nets

regenerate_bd_layout
