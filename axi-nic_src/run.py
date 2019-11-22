from vunit import VUnit

prj = VUnit.from_argv()

lib = prj.add_library("lib")
lib.add_source_files("/home/malte/2019_MN/Arke/axi-nic_src/*.vhd")

prj.main()
