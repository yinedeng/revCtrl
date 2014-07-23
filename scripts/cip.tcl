# get the directory where this script resides
set thisDir [file dirname [info script]]
# source common utilities
source $thisDir/utils.tcl

# create the directories to package the IP cleanly
if {![file exists ./cip]} {
   file mkdir ./cip
}
if {![file exists ./cip/bft]} {
   file mkdir ./cip/bft
}
if {![file exists ./cip/bft/bftLib]} {
   file mkdir ./cip/bft/bftLib
}
file copy [glob ../hdl/bft/*.v*] ./cip/bft/
file copy [glob ../hdl/bft/bftLib/*.vhdl] ./cip/bft/bftLib/

# Create project
create_project bft ./bft/ -part xc7z020clg484-1

add_files -norecurse [glob ../hdl/bft/*.v*]
add_files -norecurse [glob ../hdl/bft/bftLib/*.vhdl]
set_property library bftLib [get_files */round_*.vhdl]
set_property library bftLib [get_files */bft_package.vhdl]
set_property library bftLib [get_files */core_transform.vhdl]

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

ipx::package_project -root_dir ./cip/bft

# if everything is successful "touch" a file so make will not it's done
touch {.cip.done}
