#fehlerbehaftet

startgroup
create_bd_cell -type ip -vlnv esa.informatik.tu-darmstadt.de:user:arke_noc_router:1.0 arke_noc_router_0
endgroup
startgroup
create_bd_cell -type ip -vlnv esa.informatik.tu-darmstadt.de:user:arke_noc_router:1.0 arke_noc_router_1
endgroup
startgroup
create_bd_cell -type ip -vlnv esa.informatik.tu-darmstadt.de:user:arke_noc_router:1.0 arke_noc_router_2
endgroup
startgroup
create_bd_cell -type ip -vlnv esa.informatik.tu-darmstadt.de:user:arke_noc_pe_ifc:1.0 arke_noc_pe_ifc_0
endgroup
startgroup
create_bd_cell -type ip -vlnv esa.informatik.tu-darmstadt.de:user:arke_noc_mem_ifc:1.0 arke_noc_mem_ifc_0
endgroup
startgroup
create_bd_cell -type ip -vlnv esa.informatik.tu-darmstadt.de:user:arke_noc_arch_ifc:1.0 arke_noc_arch_ifc_0
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_interconnect:2.1 axis_interconnect_0
endgroup
set_property -dict [list CONFIG.use_data_in_south {false} CONFIG.use_data_in_west {false} CONFIG.use_data_in_north {false} CONFIG.use_data_in_up {false} CONFIG.use_data_in_down {false} CONFIG.use_control_in_south {false} CONFIG.use_control_in_west {false} CONFIG.use_control_in_north {false} CONFIG.use_control_in_up {false} CONFIG.use_control_in_down {false} CONFIG.use_data_out_south {false} CONFIG.use_data_out_west {false} CONFIG.use_data_out_north {false} CONFIG.use_data_out_up {false} CONFIG.use_data_out_down {false} CONFIG.use_control_out_south {false} CONFIG.use_control_out_west {false} CONFIG.use_control_out_north {false} CONFIG.use_control_out_up {false} CONFIG.use_control_out_down {false}] [get_bd_cells arke_noc_router_0]
set_property -dict [list CONFIG.use_data_in_south {false} CONFIG.use_data_in_north {false} CONFIG.use_data_in_up {false} CONFIG.use_data_in_down {false} CONFIG.use_control_in_south {false} CONFIG.use_control_in_north {false} CONFIG.use_control_in_up {false} CONFIG.use_control_in_down {false} CONFIG.use_data_out_south {false} CONFIG.use_data_out_north {false} CONFIG.use_data_out_up {false} CONFIG.use_data_out_down {false} CONFIG.use_control_out_south {false} CONFIG.use_control_out_north {false} CONFIG.use_control_out_up {false} CONFIG.use_control_out_down {false}] [get_bd_cells arke_noc_router_1]
set_property -dict [list CONFIG.use_data_in_east {false} CONFIG.use_data_in_south {false} CONFIG.use_data_in_north {false} CONFIG.use_data_in_up {false} CONFIG.use_data_in_down {false} CONFIG.use_control_in_east {false} CONFIG.use_control_in_south {false} CONFIG.use_control_in_north {false} CONFIG.use_control_in_up {false} CONFIG.use_control_in_down {false} CONFIG.use_data_out_east {false} CONFIG.use_data_out_south {false} CONFIG.use_data_out_north {false} CONFIG.use_data_out_up {false} CONFIG.use_data_out_down {false} CONFIG.use_control_out_east {false} CONFIG.use_control_out_south {false} CONFIG.use_control_out_north {false} CONFIG.use_control_out_up {false} CONFIG.use_control_out_down {false}] [get_bd_cells arke_noc_router_2]
delete_bd_objs [get_bd_intf_nets arch/target_ip_00_000_m_axi_maxi_arr] [get_bd_nets arch/design_interconnect_aresetn_1] [get_bd_intf_nets arch/out_0_M000_AXI] [get_bd_cells arch/out_0]
delete_bd_objs [get_bd_intf_nets arch/S_ARCH_1]
set_property -dict [list CONFIG.NUM_MI {1}] [get_bd_cells axis_interconnect_0]
create_bd_cell -type hier tIP0
move_bd_cells [get_bd_cells tIP0] [get_bd_cells arke_noc_pe_ifc_0]
move_bd_cells [get_bd_cells tIP0] [get_bd_cells axis_interconnect_0]
move_bd_cells [get_bd_cells arch] [get_bd_cells tIP0]
move_bd_cells [get_bd_cells arch/tIP0] [get_bd_cells arch/target_ip_00_000]
move_bd_cells [get_bd_cells arch] [get_bd_cells arke_noc_router_0]
move_bd_cells [get_bd_cells arch] [get_bd_cells arke_noc_router_1]
move_bd_cells [get_bd_cells arch] [get_bd_cells arke_noc_router_2]
move_bd_cells [get_bd_cells arch] [get_bd_cells arke_noc_arch_ifc_0]
move_bd_cells [get_bd_cells arch] [get_bd_cells arke_noc_mem_ifc_0]
connect_bd_net [get_bd_pins arch/arke_noc_router_0/data_in_local] [get_bd_pins arch/arke_noc_arch_ifc_0/dataOut]
connect_bd_net [get_bd_pins arch/arke_noc_router_0/data_in_east] [get_bd_pins arch/arke_noc_mem_ifc_0/dataOut]
connect_bd_net [get_bd_pins arch/arke_noc_router_0/control_in_local] [get_bd_pins arch/arke_noc_arch_ifc_0/controlOut]
connect_bd_net [get_bd_pins arch/arke_noc_router_0/control_in_east] [get_bd_pins arch/arke_noc_mem_ifc_0/controlOut]
connect_bd_net [get_bd_pins arch/arke_noc_router_0/data_out_local] [get_bd_pins arch/arke_noc_arch_ifc_0/dataIn]
connect_bd_net [get_bd_pins arch/arke_noc_router_0/data_out_east] [get_bd_pins arch/arke_noc_arch_ifc_0/controlIn]
delete_bd_objs [get_bd_nets arch/arke_noc_router_0_data_out_east]
connect_bd_net [get_bd_pins arch/arke_noc_router_0/data_out_east] [get_bd_pins arch/arke_noc_mem_ifc_0/dataIn]
connect_bd_net [get_bd_pins arch/arke_noc_router_0/control_out_local] [get_bd_pins arch/arke_noc_arch_ifc_0/controlIn]
connect_bd_net [get_bd_pins arch/arke_noc_router_0/control_out_east] [get_bd_pins arch/arke_noc_mem_ifc_0/controlIn]
connect_bd_intf_net [get_bd_intf_pins arch/S_ARCH] [get_bd_intf_pins arch/arke_noc_arch_ifc_0/AXI]
delete_bd_objs [get_bd_cells arch/tIP0/axis_interconnect_0]
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 arch/tIP0/axi_interconnect_0
endgroup
set_property -dict [list CONFIG.NUM_MI {1}] [get_bd_cells arch/tIP0/axi_interconnect_0]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins arch/tIP0/axi_interconnect_0/M00_AXI] [get_bd_intf_pins arch/tIP0/arke_noc_pe_ifc_0/A4F_AXI]
connect_bd_intf_net [get_bd_intf_pins arch/tIP0/target_ip_00_000/m_axi_maxi_arr] -boundary_type upper [get_bd_intf_pins arch/tIP0/axi_interconnect_0/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins arch/tIP0/arke_noc_pe_ifc_0/A4L_AXI] [get_bd_intf_pins arch/tIP0/target_ip_00_000/s_axi_AXILiteS]
connect_bd_net [get_bd_pins arch/tIP0/arke_noc_pe_ifc_0/dataOut] [get_bd_pins arch/arke_noc_router_1/data_in_local]
connect_bd_net [get_bd_pins arch/tIP0/arke_noc_pe_ifc_0/controlOut] [get_bd_pins arch/arke_noc_router_1/control_in_local]
connect_bd_net [get_bd_pins arch/tIP0/arke_noc_pe_ifc_0/dataIn] [get_bd_pins arch/arke_noc_router_1/data_out_local]
connect_bd_net [get_bd_pins arch/tIP0/arke_noc_pe_ifc_0/controlIn] [get_bd_pins arch/arke_noc_router_1/control_out_local]
connect_bd_intf_net [get_bd_intf_pins arch/M_MEM_0] [get_bd_intf_pins arch/arke_noc_mem_ifc_0/AXI]
delete_bd_objs [get_bd_nets arch/arke_noc_router_0_data_out_east]
delete_bd_objs [get_bd_nets arch/arke_noc_router_0_control_out_east]
delete_bd_objs [get_bd_nets arch/arke_noc_mem_ifc_0_dataOut]
delete_bd_objs [get_bd_nets arch/arke_noc_mem_ifc_0_controlOut]
connect_bd_net [get_bd_pins arch/arke_noc_mem_ifc_0/controlOut] [get_bd_pins arch/arke_noc_router_2/control_in_local]
connect_bd_net [get_bd_pins arch/arke_noc_mem_ifc_0/dataOut] [get_bd_pins arch/arke_noc_router_2/data_in_local]
connect_bd_net [get_bd_pins arch/arke_noc_mem_ifc_0/dataIn] [get_bd_pins arch/arke_noc_router_2/data_out_local]
connect_bd_net [get_bd_pins arch/arke_noc_mem_ifc_0/controlIn] [get_bd_pins arch/arke_noc_router_2/control_out_local]
connect_bd_net [get_bd_pins arch/arke_noc_router_1/data_out_east] [get_bd_pins arch/arke_noc_router_2/data_in_west]
connect_bd_net [get_bd_pins arch/arke_noc_router_1/control_out_east] [get_bd_pins arch/arke_noc_router_2/control_in_west]
connect_bd_net [get_bd_pins arch/arke_noc_router_2/control_out_west] [get_bd_pins arch/arke_noc_router_1/control_in_east]
connect_bd_net [get_bd_pins arch/arke_noc_router_2/data_out_west] [get_bd_pins arch/arke_noc_router_1/data_in_east]
connect_bd_net [get_bd_pins arch/arke_noc_router_0/data_out_east] [get_bd_pins arch/arke_noc_router_1/data_in_west]
connect_bd_net [get_bd_pins arch/arke_noc_router_0/control_out_east] [get_bd_pins arch/arke_noc_router_1/control_in_west]
connect_bd_net [get_bd_pins arch/arke_noc_router_1/data_out_west] [get_bd_pins arch/arke_noc_router_0/data_in_east]
connect_bd_net [get_bd_pins arch/arke_noc_router_1/control_out_west] [get_bd_pins arch/arke_noc_router_0/control_in_east]
connect_bd_net [get_bd_pins arch/design_clk] [get_bd_pins arch/arke_noc_arch_ifc_0/clk]
connect_bd_net [get_bd_pins arch/design_clk] [get_bd_pins arch/arke_noc_router_0/clk]
connect_bd_net [get_bd_pins arch/design_clk] [get_bd_pins arch/arke_noc_router_1/clk]
connect_bd_net [get_bd_pins arch/design_clk] [get_bd_pins arch/arke_noc_router_2/clk]
connect_bd_net [get_bd_pins arch/design_clk] [get_bd_pins arch/arke_noc_mem_ifc_0/clk]
connect_bd_net [get_bd_pins arch/tIP0/design_clk] [get_bd_pins arch/tIP0/arke_noc_pe_ifc_0/clk]
connect_bd_net [get_bd_pins arch/design_peripheral_aresetn] [get_bd_pins arch/arke_noc_arch_ifc_0/rst]
connect_bd_net [get_bd_pins arch/design_peripheral_aresetn] [get_bd_pins arch/arke_noc_router_0/rst]
connect_bd_net [get_bd_pins arch/design_peripheral_aresetn] [get_bd_pins arch/arke_noc_router_1/rst]
connect_bd_net [get_bd_pins arch/design_peripheral_aresetn] [get_bd_pins arch/tIP0/axi_interconnect_0/ARESETN] -boundary_type upper
connect_bd_net [get_bd_pins arch/design_peripheral_aresetn] [get_bd_pins arch/tIP0/arke_noc_pe_ifc_0/rst]
connect_bd_net [get_bd_pins arch/design_peripheral_aresetn] [get_bd_pins arch/arke_noc_router_2/rst]
connect_bd_net [get_bd_pins arch/design_peripheral_aresetn] [get_bd_pins arch/arke_noc_mem_ifc_0/rst]
connect_bd_net [get_bd_pins arch/design_clk] [get_bd_pins arch/tIP0/axi_interconnect_0/ACLK] -boundary_type upper
connect_bd_net [get_bd_pins arch/design_clk] [get_bd_pins arch/tIP0/axi_interconnect_0/S00_ACLK] -boundary_type upper
connect_bd_net [get_bd_pins arch/design_clk] [get_bd_pins arch/tIP0/axi_interconnect_0/M00_ACLK] -boundary_type upper