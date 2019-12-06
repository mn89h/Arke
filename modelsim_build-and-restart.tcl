proc build-and-run {} {
vcom router_src/Arke_pkg.vhd
vcom axi-nic_src/NIC_pkg.vhd
vcom axi-nic_src/FIFO_pkg.vhd
vcom axi-nic_src/AXI4_Lite_Slave.vhd
vcom axi-nic_src/AXI4_Lite_Master.vhd
vcom axi-nic_src/AXI4_Lite_Slave_tb.vhd
vcom axi-nic_src/Arch_Ifc.vhd
vcom axi-nic_src/Arch_Ifc_tb.vhd
vcom axi-nic_src/Core_Ifc.vhd
vcom axi-nic_src/Core_Ifc_tb.vhd
restart -f
run 350
}

build-and-run