# ip

source ../scripts/mw_env.tcl
source $mw_hdl_dir/library/scripts/mw_ip.tcl

mw_ip_create util_mw_bypass_user_logic
mw_ip_files util_mw_bypass_user_logic [list \
    "util_mw_bypass_user_logic.v" \
    "util_mw_bypass_user_logic_axi_lite.v" \
    "util_mw_bypass_user_logic_dut.v" \
    "util_mw_bypass_user_logic_axi_lite_module.v" \
    "util_mw_bypass_user_logic_src_util_mw_bypass_user_logic.v" \
    "util_mw_bypass_user_logic_addr_decoder.v"]

mw_ip_properties_lite util_mw_bypass_user_logic


set_property driver_value 0 [ipx::get_ports *dut_data_in* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *bypass_data_in* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *dut_valid_in* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *bypass_valid_in* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *mux_data_out* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *mux_valid_out* -of_objects [ipx::current_core]]

# Data ports
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_CHAN')) > 1} \
  [ipx::get_ports *data_*_1* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_CHAN')) > 2} \
  [ipx::get_ports *data*_2* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_CHAN')) > 3} \
  [ipx::get_ports *data*_3* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_CHAN')) > 4} \
  [ipx::get_ports *data*_4* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_CHAN')) > 5} \
  [ipx::get_ports *data*_5* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_CHAN')) > 6} \
  [ipx::get_ports *data*_6* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_CHAN')) > 7} \
  [ipx::get_ports *data*_7* -of_objects [ipx::current_core]]  

# Valid ports
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_CHAN')) > 2} \
  [ipx::get_ports *_valid_*_1* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_CHAN')) > 4} \
  [ipx::get_ports *_valid_*_2* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_CHAN')) > 6} \
  [ipx::get_ports *_valid_*_3* -of_objects [ipx::current_core]]

ipx::create_xgui_files [ipx::current_core]

ipx::save_core [ipx::current_core]
