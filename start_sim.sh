export PATH=$PATH:/home/malte/opt/intelFPGA/16.1/modelsim_ase/linuxaloem
vcom simulation/DataManager.vhd
LD_LIBRARY_PATH=/home/malte/opt/intelFPGA/16.1/modelsim_ase/lib vsim simulation/NoC_tb.vhd

