# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "cnt_significant_bit" -parent ${Page_0}
  ipgui::add_param $IPINST -name "cntwidth" -parent ${Page_0}


}

proc update_PARAM_VALUE.cnt_significant_bit { PARAM_VALUE.cnt_significant_bit } {
	# Procedure called to update cnt_significant_bit when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.cnt_significant_bit { PARAM_VALUE.cnt_significant_bit } {
	# Procedure called to validate cnt_significant_bit
	return true
}

proc update_PARAM_VALUE.cntwidth { PARAM_VALUE.cntwidth } {
	# Procedure called to update cntwidth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.cntwidth { PARAM_VALUE.cntwidth } {
	# Procedure called to validate cntwidth
	return true
}


proc update_MODELPARAM_VALUE.cntwidth { MODELPARAM_VALUE.cntwidth PARAM_VALUE.cntwidth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.cntwidth}] ${MODELPARAM_VALUE.cntwidth}
}

proc update_MODELPARAM_VALUE.cnt_significant_bit { MODELPARAM_VALUE.cnt_significant_bit PARAM_VALUE.cnt_significant_bit } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.cnt_significant_bit}] ${MODELPARAM_VALUE.cnt_significant_bit}
}

