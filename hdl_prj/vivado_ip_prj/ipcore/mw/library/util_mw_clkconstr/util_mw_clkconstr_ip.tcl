# ip

source ../scripts/mw_env.tcl
source $mw_hdl_dir/library/scripts/mw_ip.tcl

mw_ip_create util_mw_clkconstr
mw_ip_files util_mw_clkconstr [list \
  "util_mw_clkconstr_constr.ttcl" \
    "util_mw_clkconstr.v" ]

mw_ip_properties_lite util_mw_clkconstr

mw_ip_ttcl util_mw_clkconstr [list \
  "util_mw_clkconstr_constr.ttcl" ]

mw_add_bus clk_out master "xilinx.com:signal:clock_rtl:1.0" "xilinx.com:signal:clock:1.0" \
	[list {"clk_out" "CLK"}]

ipx::create_xgui_files [ipx::current_core]

ipx::save_core [ipx::current_core]

