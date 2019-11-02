# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "fileNameIn" -parent ${Page_0}
  ipgui::add_param $IPINST -name "fileNameOut" -parent ${Page_0}


}

proc update_PARAM_VALUE.fileNameIn { PARAM_VALUE.fileNameIn } {
	# Procedure called to update fileNameIn when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.fileNameIn { PARAM_VALUE.fileNameIn } {
	# Procedure called to validate fileNameIn
	return true
}

proc update_PARAM_VALUE.fileNameOut { PARAM_VALUE.fileNameOut } {
	# Procedure called to update fileNameOut when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.fileNameOut { PARAM_VALUE.fileNameOut } {
	# Procedure called to validate fileNameOut
	return true
}


proc update_MODELPARAM_VALUE.fileNameIn { MODELPARAM_VALUE.fileNameIn PARAM_VALUE.fileNameIn } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.fileNameIn}] ${MODELPARAM_VALUE.fileNameIn}
}

proc update_MODELPARAM_VALUE.fileNameOut { MODELPARAM_VALUE.fileNameOut PARAM_VALUE.fileNameOut } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.fileNameOut}] ${MODELPARAM_VALUE.fileNameOut}
}

