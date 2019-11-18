##HELPERS##
#dec2bin: returns a string, e.g. dec2bin 10 => 1010 
proc dec2bin i {
    set res {} 
    while {$i>0} {
        set res [expr {$i%2}]$res
        set i [expr {$i/2}]
    }
    if {$res == {}} {set res 0}
    return $res
}

##PROGRAM##
    set projectname noc_benchmark3
    set ROUTER_IP user.org:user:Router:1.0
    set DIM_X 3
    set DIM_Y 3
    set DIM_Z 2
    set DIM_X_W [expr {round(log($DIM_X)/log(2.0))}] 
    set DIM_Y_W [expr {round(log($DIM_Y)/log(2.0))}] 
    set DIM_Z_W [expr {round(log($DIM_Z)/log(2.0))}] 
    set DATA_WIDTH 16

    set DATAMANAGER_IP user.org:user:DataManager:1.0

create_project $projectname /home/malte/$projectname -part xc7z020clg400-1
ipx::open_ipxact_file /home/malte/Arke-Legacy/router_src/component.xml
set_property widget {hexEdit} [ipgui::get_guiparamspec -name "address" -component [ipx::current_core] ]
#set data_width
set_property value {"0000000000000000"} [ipx::get_user_parameters address -of_objects [ipx::current_core]]
set_property value {"0000000000000000"} [ipx::get_hdl_parameters address -of_objects [ipx::current_core]]
set_property value_bit_string_length 16 [ipx::get_user_parameters address -of_objects [ipx::current_core]]
set_property value_bit_string_length 16 [ipx::get_hdl_parameters address -of_objects [ipx::current_core]]
set_property value_format bitString [ipx::get_user_parameters address -of_objects [ipx::current_core]]
set_property value_format bitString [ipx::get_hdl_parameters address -of_objects [ipx::current_core]]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
set_property  ip_repo_paths  /home/malte/Arke-Legacy/router_src [current_project]
set_property ip_repo_paths [concat [get_property ip_repo_paths [current_project]] {/home/malte/Arke-Legacy/datamanager_src}] [current_project]
update_ip_catalog
create_bd_design "design_1"

create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]

for {set z 0} {$z < $DIM_Z} {incr z} {
    for {set y 0} {$y < $DIM_Y} {incr y} {
        for {set x 0} {$x < $DIM_X} {incr x} {
            create_bd_cell -type ip -vlnv $ROUTER_IP Router_$x\_$y\_$z
            set xyz ""
            append xyz [format {%0*s} $DIM_X_W [dec2bin $x]]
            append xyz [format {%0*s} $DIM_Y_W [dec2bin $y]]
            append xyz [format {%0*s} $DIM_Z_W [dec2bin $z]]
            set xyz 0b[format {%0*s} $DATA_WIDTH $xyz]
            set_property -dict [list CONFIG.address $xyz] [get_bd_cells Router_$x\_$y\_$z]
            #apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK0 (100 MHz)" }  [get_bd_pins Router_$x\_$y\_$z/clk]
            
            create_bd_cell -type ip -vlnv $DATAMANAGER_IP DataManager_$x\_$y\_$z
            set filenamein /home/malte/Arke-Legacy/datamanager_src/data/fileIn$x\_$y\_$z.txt
            set_property -dict [list CONFIG.fileNameIn $filenamein] [get_bd_cells DataManager_$x\_$y\_$z]
            #apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK0 (100 MHz)" }  [get_bd_pins DataManager_$x\_$y\_$z/clk]
        }
    }
}
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1
set_property -dict [list CONFIG.CONST_WIDTH {16}] [get_bd_cells xlconstant_0]
set_property -dict [list CONFIG.CONST_WIDTH {3}]  [get_bd_cells xlconstant_1]

for {set z 0} {$z < $DIM_Z} {incr z} {
    for {set y 0} {$y < $DIM_Y} {incr y} {
        for {set x 0} {$x < $DIM_X} {incr x} {

            connect_bd_net [get_bd_pins Router_$x\_$y\_$z/data_out_local]    [get_bd_pins DataManager_$x\_$y\_$z/data_in]
            connect_bd_net [get_bd_pins Router_$x\_$y\_$z/control_out_local] [get_bd_pins DataManager_$x\_$y\_$z/control_in]
            connect_bd_net [get_bd_pins Router_$x\_$y\_$z/data_in_local]     [get_bd_pins DataManager_$x\_$y\_$z/data_out]
            connect_bd_net [get_bd_pins Router_$x\_$y\_$z/control_in_local]  [get_bd_pins DataManager_$x\_$y\_$z/control_out]
            
            if { $x+1 < $DIM_X } then {
                connect_bd_net [get_bd_pins Router_$x\_$y\_$z/data_out_east]    [get_bd_pins Router_[expr $x+1]\_$y\_$z/data_in_west]
                connect_bd_net [get_bd_pins Router_$x\_$y\_$z/control_out_east] [get_bd_pins Router_[expr $x+1]\_$y\_$z/control_in_west]
                connect_bd_net [get_bd_pins Router_$x\_$y\_$z/data_in_east]     [get_bd_pins Router_[expr $x+1]\_$y\_$z/data_out_west]
                connect_bd_net [get_bd_pins Router_$x\_$y\_$z/control_in_east]  [get_bd_pins Router_[expr $x+1]\_$y\_$z/control_out_west]
            }
            if { $y+1 < $DIM_Y } then {
                connect_bd_net [get_bd_pins Router_$x\_$y\_$z/data_out_north]    [get_bd_pins Router_$x\_[expr $y+1]\_$z/data_in_south]
                connect_bd_net [get_bd_pins Router_$x\_$y\_$z/control_out_north] [get_bd_pins Router_$x\_[expr $y+1]\_$z/control_in_south]
                connect_bd_net [get_bd_pins Router_$x\_$y\_$z/data_in_north]     [get_bd_pins Router_$x\_[expr $y+1]\_$z/data_out_south]
                connect_bd_net [get_bd_pins Router_$x\_$y\_$z/control_in_north]  [get_bd_pins Router_$x\_[expr $y+1]\_$z/control_out_south]
            }
            if { $z+1 < $DIM_Z } then {
                connect_bd_net [get_bd_pins Router_$x\_$y\_$z/data_out_up]    [get_bd_pins Router_$x\_$y\_[expr $z+1]/data_in_down]
                connect_bd_net [get_bd_pins Router_$x\_$y\_$z/control_out_up] [get_bd_pins Router_$x\_$y\_[expr $z+1]/control_in_down]
                connect_bd_net [get_bd_pins Router_$x\_$y\_$z/data_in_up]     [get_bd_pins Router_$x\_$y\_[expr $z+1]/data_out_down]
                connect_bd_net [get_bd_pins Router_$x\_$y\_$z/control_in_up]  [get_bd_pins Router_$x\_$y\_[expr $z+1]/control_out_down]
            }
            if { $x == 0 } then {
                connect_bd_net [get_bd_pins Router_$x\_$y\_$z/data_in_west]     [get_bd_pins xlconstant_0/dout]
                connect_bd_net [get_bd_pins Router_$x\_$y\_$z/control_in_west]  [get_bd_pins xlconstant_1/dout]
                #set_property -dict [list CONFIG.use_data_in_west        {false}] [get_bd_cells Router_$x\_$y\_$z]
                #set_property -dict [list CONFIG.use_control_in_west     {false}] [get_bd_cells Router_$x\_$y\_$z]
                set_property -dict [list CONFIG.use_data_out_west       {false}] [get_bd_cells Router_$x\_$y\_$z]
                set_property -dict [list CONFIG.use_control_out_west    {false}] [get_bd_cells Router_$x\_$y\_$z]
            }
            if { $x == $DIM_X-1 } then {
                connect_bd_net [get_bd_pins Router_$x\_$y\_$z/data_in_east]     [get_bd_pins xlconstant_0/dout]
                connect_bd_net [get_bd_pins Router_$x\_$y\_$z/control_in_east]  [get_bd_pins xlconstant_1/dout]
                #set_property -dict [list CONFIG.use_data_in_east        {false}] [get_bd_cells Router_$x\_$y\_$z]
                #set_property -dict [list CONFIG.use_control_in_east     {false}] [get_bd_cells Router_$x\_$y\_$z]
                set_property -dict [list CONFIG.use_data_out_east       {false}] [get_bd_cells Router_$x\_$y\_$z]
                set_property -dict [list CONFIG.use_control_out_east    {false}] [get_bd_cells Router_$x\_$y\_$z]
            }
            if { $y == 0 } then {
                connect_bd_net [get_bd_pins Router_$x\_$y\_$z/data_in_south]     [get_bd_pins xlconstant_0/dout]
                connect_bd_net [get_bd_pins Router_$x\_$y\_$z/control_in_south]  [get_bd_pins xlconstant_1/dout]
                #set_property -dict [list CONFIG.use_data_in_south        {false}] [get_bd_cells Router_$x\_$y\_$z]
                #set_property -dict [list CONFIG.use_control_in_south     {false}] [get_bd_cells Router_$x\_$y\_$z]
                set_property -dict [list CONFIG.use_data_out_south       {false}] [get_bd_cells Router_$x\_$y\_$z]
                set_property -dict [list CONFIG.use_control_out_south    {false}] [get_bd_cells Router_$x\_$y\_$z]
            }
            if { $y == $DIM_Y-1 } then {
                connect_bd_net [get_bd_pins Router_$x\_$y\_$z/data_in_north]     [get_bd_pins xlconstant_0/dout]
                connect_bd_net [get_bd_pins Router_$x\_$y\_$z/control_in_north]  [get_bd_pins xlconstant_1/dout]
                #set_property -dict [list CONFIG.use_data_in_north        {false}] [get_bd_cells Router_$x\_$y\_$z]
                #set_property -dict [list CONFIG.use_control_in_north     {false}] [get_bd_cells Router_$x\_$y\_$z]
                set_property -dict [list CONFIG.use_data_out_north       {false}] [get_bd_cells Router_$x\_$y\_$z]
                set_property -dict [list CONFIG.use_control_out_north    {false}] [get_bd_cells Router_$x\_$y\_$z]
            }
            if { $z == 0 } then {
                connect_bd_net [get_bd_pins Router_$x\_$y\_$z/data_in_down]     [get_bd_pins xlconstant_0/dout]
                connect_bd_net [get_bd_pins Router_$x\_$y\_$z/control_in_down]  [get_bd_pins xlconstant_1/dout]
                #set_property -dict [list CONFIG.use_data_in_down        {false}] [get_bd_cells Router_$x\_$y\_$z]
                #set_property -dict [list CONFIG.use_control_in_down     {false}] [get_bd_cells Router_$x\_$y\_$z]
                set_property -dict [list CONFIG.use_data_out_down       {false}] [get_bd_cells Router_$x\_$y\_$z]
                set_property -dict [list CONFIG.use_control_out_down    {false}] [get_bd_cells Router_$x\_$y\_$z]
            }
            if { $z == $DIM_Z-1 } then {
                connect_bd_net [get_bd_pins Router_$x\_$y\_$z/data_in_up]     [get_bd_pins xlconstant_0/dout]
                connect_bd_net [get_bd_pins Router_$x\_$y\_$z/control_in_up]  [get_bd_pins xlconstant_1/dout]
                #set_property -dict [list CONFIG.use_data_in_up        {false}] [get_bd_cells Router_$x\_$y\_$z]
                #set_property -dict [list CONFIG.use_control_in_up     {false}] [get_bd_cells Router_$x\_$y\_$z]
                set_property -dict [list CONFIG.use_data_out_up       {false}] [get_bd_cells Router_$x\_$y\_$z]
                set_property -dict [list CONFIG.use_control_out_up    {false}] [get_bd_cells Router_$x\_$y\_$z]
            }
        }
    }
}
create_bd_port -dir I -type clk clkin
set_property CONFIG.FREQ_HZ 100000000 [get_bd_ports clkin]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/clkin (100 MHz)" }  [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Manual_Source {Auto}}  [get_bd_pins proc_sys_reset_0/ext_reset_in]

set_property -dict [list CONFIG.PCW_USE_M_AXI_GP0 {0}] [get_bd_cells processing_system7_0]
update_compile_order -fileset sources_1
make_wrapper -files [get_files /home/malte/noc_benchmark3/noc_benchmark3.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse /home/malte/noc_benchmark3/noc_benchmark3.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.v

#system reset and clkin port, then connection automation