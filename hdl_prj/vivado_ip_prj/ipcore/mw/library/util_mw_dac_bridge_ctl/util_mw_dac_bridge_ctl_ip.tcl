# ip

source ../scripts/mw_env.tcl
source $mw_hdl_dir/library/scripts/mw_ip.tcl

mw_ip_create util_mw_dac_bridge_ctl
mw_ip_files util_mw_dac_bridge_ctl [list \
    "util_mw_dac_bridge_ctl.v" ]

mw_ip_properties_lite util_mw_dac_bridge_ctl


set_property driver_value 0 [ipx::get_ports *bridge_in* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *dac_enable_* -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports *dac_valid_* -of_objects [ipx::current_core]]

set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_CHAN')) > 1} \
  [ipx::get_ports *_1* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_CHAN')) > 2} \
  [ipx::get_ports *_2* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_CHAN')) > 3} \
  [ipx::get_ports *_3* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_CHAN')) > 4} \
  [ipx::get_ports *_4* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_CHAN')) > 5} \
  [ipx::get_ports *_5* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_CHAN')) > 6} \
  [ipx::get_ports *_6* -of_objects [ipx::current_core]]
set_property enablement_dependency {spirit:decode(id('MODELPARAM_VALUE.NUM_CHAN')) > 7} \
  [ipx::get_ports *_7* -of_objects [ipx::current_core]]

ipx::create_xgui_files [ipx::current_core]

ipx::save_core [ipx::current_core]

