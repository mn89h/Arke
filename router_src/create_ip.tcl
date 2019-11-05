set_property widget {hexEdit} [ipgui::get_guiparamspec -name "address" -component [ipx::current_core] ]
set_property value 0x0000 [ipx::get_user_parameters address -of_objects [ipx::current_core]]
set_property value 0x0000 [ipx::get_hdl_parameters address -of_objects [ipx::current_core]]
set_property value_bit_string_length 16 [ipx::get_user_parameters address -of_objects [ipx::current_core]]
set_property value_bit_string_length 16 [ipx::get_hdl_parameters address -of_objects [ipx::current_core]]
set_property value_format bitString [ipx::get_user_parameters address -of_objects [ipx::current_core]]
set_property value_format bitString [ipx::get_hdl_parameters address -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports data_in_local -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports data_in_east -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports data_in_south -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports data_in_west -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports data_in_north -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports data_in_up -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports data_in_down -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports control_in_local -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports control_in_east -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports control_in_south -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports control_in_west -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports control_in_north -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports control_in_up -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports control_in_down -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports data_out_local -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports data_out_east -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports data_out_south -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports data_out_west -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports data_out_north -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports data_out_up -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports data_out_down -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports control_out_local -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports control_out_east -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports control_out_south -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports control_out_west -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports control_out_north -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports control_out_up -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports control_out_down -of_objects [ipx::current_core]]

set_property enablement_dependency {$use_data_in_local     = true} [ipx::get_ports data_in_local -of_objects [ipx::current_core]]
set_property enablement_dependency {$use_data_in_east      = true} [ipx::get_ports data_in_east -of_objects [ipx::current_core]]
set_property enablement_dependency {$use_data_in_south     = true} [ipx::get_ports data_in_south -of_objects [ipx::current_core]]
set_property enablement_dependency {$use_data_in_west      = true} [ipx::get_ports data_in_west -of_objects [ipx::current_core]]
set_property enablement_dependency {$use_data_in_north     = true} [ipx::get_ports data_in_north -of_objects [ipx::current_core]]
set_property enablement_dependency {$use_data_in_up        = true} [ipx::get_ports data_in_up -of_objects [ipx::current_core]]
set_property enablement_dependency {$use_data_in_down      = true} [ipx::get_ports data_in_down -of_objects [ipx::current_core]]
set_property enablement_dependency {$use_control_in_local  = true} [ipx::get_ports control_in_local -of_objects [ipx::current_core]]
set_property enablement_dependency {$use_control_in_east   = true} [ipx::get_ports control_in_east -of_objects [ipx::current_core]]
set_property enablement_dependency {$use_control_in_south  = true} [ipx::get_ports control_in_south -of_objects [ipx::current_core]]
set_property enablement_dependency {$use_control_in_west   = true} [ipx::get_ports control_in_west -of_objects [ipx::current_core]]
set_property enablement_dependency {$use_control_in_north  = true} [ipx::get_ports control_in_north -of_objects [ipx::current_core]]
set_property enablement_dependency {$use_control_in_up     = true} [ipx::get_ports control_in_up -of_objects [ipx::current_core]]
set_property enablement_dependency {$use_control_in_down   = true} [ipx::get_ports control_in_down -of_objects [ipx::current_core]]
set_property enablement_dependency {$use_data_out_local    = true} [ipx::get_ports data_out_local -of_objects [ipx::current_core]]
set_property enablement_dependency {$use_data_out_east     = true} [ipx::get_ports data_out_east -of_objects [ipx::current_core]]
set_property enablement_dependency {$use_data_out_south    = true} [ipx::get_ports data_out_south -of_objects [ipx::current_core]]
set_property enablement_dependency {$use_data_out_west     = true} [ipx::get_ports data_out_west -of_objects [ipx::current_core]]
set_property enablement_dependency {$use_data_out_north    = true} [ipx::get_ports data_out_north -of_objects [ipx::current_core]]
set_property enablement_dependency {$use_data_out_up       = true} [ipx::get_ports data_out_up -of_objects [ipx::current_core]]
set_property enablement_dependency {$use_data_out_down     = true} [ipx::get_ports data_out_down -of_objects [ipx::current_core]]
set_property enablement_dependency {$use_control_out_local = true} [ipx::get_ports control_out_local -of_objects [ipx::current_core]]
set_property enablement_dependency {$use_control_out_east  = true} [ipx::get_ports control_out_east -of_objects [ipx::current_core]]
set_property enablement_dependency {$use_control_out_south = true} [ipx::get_ports control_out_south -of_objects [ipx::current_core]]
set_property enablement_dependency {$use_control_out_west  = true} [ipx::get_ports control_out_west -of_objects [ipx::current_core]]
set_property enablement_dependency {$use_control_out_north = true} [ipx::get_ports control_out_north -of_objects [ipx::current_core]]
set_property enablement_dependency {$use_control_out_up    = true} [ipx::get_ports control_out_up -of_objects [ipx::current_core]]
set_property enablement_dependency {$use_control_out_down  = true} [ipx::get_ports control_out_down -of_objects [ipx::current_core]]

ipgui::move_param -component [ipx::current_core] -order 16 [ipgui::get_guiparamspec -name "use_data_in_local" -component [ipx::current_core]] -parent [ipgui::get_pagespec -name "Page 0" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 17 [ipgui::get_guiparamspec -name "use_data_in_north" -component [ipx::current_core]] -parent [ipgui::get_pagespec -name "Page 0" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 18 [ipgui::get_guiparamspec -name "use_data_in_north" -component [ipx::current_core]] -parent [ipgui::get_pagespec -name "Page 0" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 17 [ipgui::get_guiparamspec -name "use_data_in_local" -component [ipx::current_core]] -parent [ipgui::get_pagespec -name "Page 0" -component [ipx::current_core]]
ipgui::add_group -name {Ports} -component [ipx::current_core] -display_name {Ports} -layout {horizontal}
ipgui::move_group -component [ipx::current_core] -order 0 [ipgui::get_groupspec -name "Ports" -component [ipx::current_core]] -parent [ipgui::get_pagespec -name "Page 0" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 0 [ipgui::get_guiparamspec -name "use_control_in_down" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Ports" -component [ipx::current_core]]
ipgui::add_group -name {Data_In} -component [ipx::current_core] -parent [ipgui::get_groupspec -name "Ports" -component [ipx::current_core] ] -display_name {Data_In}
ipgui::add_group -name {Control_In} -component [ipx::current_core] -parent [ipgui::get_groupspec -name "Ports" -component [ipx::current_core] ] -display_name {Control_In}
ipgui::move_param -component [ipx::current_core] -order 0 [ipgui::get_guiparamspec -name "use_control_in_down" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Control_In" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 0 [ipgui::get_guiparamspec -name "use_data_in_down" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Data_In" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 1 [ipgui::get_guiparamspec -name "use_data_in_east" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Data_In" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 2 [ipgui::get_guiparamspec -name "use_data_in_local" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Data_In" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 3 [ipgui::get_guiparamspec -name "use_data_in_north" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Data_In" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 4 [ipgui::get_guiparamspec -name "use_data_in_south" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Data_In" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 5 [ipgui::get_guiparamspec -name "use_data_in_up" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Data_In" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 6 [ipgui::get_guiparamspec -name "use_data_in_west" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Data_In" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 0 [ipgui::get_guiparamspec -name "address" -component [ipx::current_core]] -parent [ipgui::get_pagespec -name "Page 0" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 1 [ipgui::get_guiparamspec -name "use_control_in_east" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Control_In" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 2 [ipgui::get_guiparamspec -name "use_control_in_local" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Control_In" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 2 [ipgui::get_guiparamspec -name "use_control_in_north" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Control_In" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 2 [ipgui::get_guiparamspec -name "use_control_in_south" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Control_In" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 2 [ipgui::get_guiparamspec -name "use_control_in_up" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Control_In" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 2 [ipgui::get_guiparamspec -name "use_control_in_west" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Control_In" -component [ipx::current_core]]
ipgui::add_group -name {Data_Out} -component [ipx::current_core] -parent [ipgui::get_groupspec -name "Ports" -component [ipx::current_core] ] -display_name {Data_Out}
ipgui::move_param -component [ipx::current_core] -order 0 [ipgui::get_guiparamspec -name "use_data_out_down" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Data_Out" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 1 [ipgui::get_guiparamspec -name "use_data_out_east" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Data_Out" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 2 [ipgui::get_guiparamspec -name "use_data_out_local" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Data_Out" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 3 [ipgui::get_guiparamspec -name "use_data_out_north" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Data_Out" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 4 [ipgui::get_guiparamspec -name "use_data_out_south" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Data_Out" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 5 [ipgui::get_guiparamspec -name "use_data_out_up" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Data_Out" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 6 [ipgui::get_guiparamspec -name "use_data_out_west" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Data_Out" -component [ipx::current_core]]
ipgui::add_group -name {Control_Out} -component [ipx::current_core] -parent [ipgui::get_groupspec -name "Ports" -component [ipx::current_core] ] -display_name {Control_Out}
ipgui::move_param -component [ipx::current_core] -order 0 [ipgui::get_guiparamspec -name "use_control_out_down" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Control_Out" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 1 [ipgui::get_guiparamspec -name "use_control_out_east" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Control_Out" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 2 [ipgui::get_guiparamspec -name "use_control_out_local" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Control_Out" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 2 [ipgui::get_guiparamspec -name "use_control_out_north" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Control_Out" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 2 [ipgui::get_guiparamspec -name "use_control_out_south" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Control_Out" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 2 [ipgui::get_guiparamspec -name "use_control_out_up" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Control_Out" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 2 [ipgui::get_guiparamspec -name "use_control_out_west" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Control_Out" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 1 [ipgui::get_guiparamspec -name "use_data_in_local" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 0 [ipgui::get_guiparamspec -name "use_data_in_local" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 1 [ipgui::get_guiparamspec -name "use_data_in_east" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 3 [ipgui::get_guiparamspec -name "use_data_in_south" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 2 [ipgui::get_guiparamspec -name "use_data_in_south" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 5 [ipgui::get_guiparamspec -name "use_data_in_west" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 4 [ipgui::get_guiparamspec -name "use_data_in_west" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 3 [ipgui::get_guiparamspec -name "use_data_in_west" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 4 [ipgui::get_guiparamspec -name "use_data_in_north" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 0 [ipgui::get_guiparamspec -name "use_control_in_local" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Control_In" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 0 [ipgui::get_guiparamspec -name "use_control_in_east" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Control_In" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 2 [ipgui::get_guiparamspec -name "use_control_in_east" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Control_In" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 1 [ipgui::get_guiparamspec -name "use_control_in_east" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Control_In" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 2 [ipgui::get_guiparamspec -name "use_control_in_south" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Control_In" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 3 [ipgui::get_guiparamspec -name "use_control_in_west" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Control_In" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 4 [ipgui::get_guiparamspec -name "use_control_in_north" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Control_In" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 5 [ipgui::get_guiparamspec -name "use_control_in_up" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Control_In" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 5 [ipgui::get_guiparamspec -name "use_data_in_up" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Data_In" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 0 [ipgui::get_guiparamspec -name "use_data_out_local" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Data_Out" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 1 [ipgui::get_guiparamspec -name "use_data_out_east" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Data_Out" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 2 [ipgui::get_guiparamspec -name "use_data_out_south" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Data_Out" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 3 [ipgui::get_guiparamspec -name "use_data_out_west" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Data_Out" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 4 [ipgui::get_guiparamspec -name "use_data_out_north" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Data_Out" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 5 [ipgui::get_guiparamspec -name "use_data_out_up" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Data_Out" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 0 [ipgui::get_guiparamspec -name "use_control_out_local" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Control_Out" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 1 [ipgui::get_guiparamspec -name "use_control_out_east" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Control_Out" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 2 [ipgui::get_guiparamspec -name "use_control_out_south" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Control_Out" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 3 [ipgui::get_guiparamspec -name "use_control_out_west" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Control_Out" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 4 [ipgui::get_guiparamspec -name "use_control_out_north" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Control_Out" -component [ipx::current_core]]
ipgui::move_param -component [ipx::current_core] -order 5 [ipgui::get_guiparamspec -name "use_control_out_up" -component [ipx::current_core]] -parent [ipgui::get_groupspec -name "Control_Out" -component [ipx::current_core]]
set_property widget {hexEdit} [ipgui::get_guiparamspec -name "address" -component [ipx::current_core] ]




use_data_in_local       : boolean := true;
use_data_in_east        : boolean := true;
use_data_in_south       : boolean := true;
use_data_in_west        : boolean := true;
use_data_in_north       : boolean := true;
use_data_in_up          : boolean := true;
use_data_in_down        : boolean := true;
use_control_in_local    : boolean := true;
use_control_in_east     : boolean := true;
use_control_in_south    : boolean := true;
use_control_in_west     : boolean := true;
use_control_in_north    : boolean := true;
use_control_in_up       : boolean := true;
use_control_in_down     : boolean := true;
use_data_out_local      : boolean := true;
use_data_out_east       : boolean := true;
use_data_out_south      : boolean := true;
use_data_out_west       : boolean := true;
use_data_out_north      : boolean := true;
use_data_out_up         : boolean := true;
use_data_out_down       : boolean := true;
use_control_out_local   : boolean := true;
use_control_out_east    : boolean := true;
use_control_out_south   : boolean := true;
use_control_out_west    : boolean := true;
use_control_out_north   : boolean := true;
use_control_out_up      : boolean := true;
use_control_out_down    : boolean := true