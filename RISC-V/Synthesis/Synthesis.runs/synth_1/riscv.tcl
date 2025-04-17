# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param synth.incrementalSynthesisCache {E:/Study Folder/Engineering/Computer Engineering/Computer Systems/Architectures/Notes/Lab/Codes/RISC-V/Synthesis/.Xil/Vivado-15608-RB17/incrSyn}
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir {E:/Study Folder/Engineering/Computer Engineering/Computer Systems/Architectures/Notes/Lab/Codes/RISC-V/Synthesis/Synthesis.cache/wt} [current_project]
set_property parent.project_path {E:/Study Folder/Engineering/Computer Engineering/Computer Systems/Architectures/Notes/Lab/Codes/RISC-V/Synthesis/Synthesis.xpr} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo {e:/Study Folder/Engineering/Computer Engineering/Computer Systems/Architectures/Notes/Lab/Codes/RISC-V/Synthesis/Synthesis.cache/ip} [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib -sv {
  {E:/Study Folder/Engineering/Computer Engineering/Computer Systems/Architectures/Notes/Lab/Codes/RISC-V/Synthesis/Synthesis.srcs/sources_1/imports/Modules/ALU.sv}
  {E:/Study Folder/Engineering/Computer Engineering/Computer Systems/Architectures/Notes/Lab/Codes/RISC-V/Synthesis/Synthesis.srcs/sources_1/imports/Modules/ALU_Ctrl.sv}
  {E:/Study Folder/Engineering/Computer Engineering/Computer Systems/Architectures/Notes/Lab/Codes/RISC-V/Synthesis/Synthesis.srcs/sources_1/imports/Modules/Branch_Adder.sv}
  {E:/Study Folder/Engineering/Computer Engineering/Computer Systems/Architectures/Notes/Lab/Codes/RISC-V/Synthesis/Synthesis.srcs/sources_1/imports/Modules/Data_memory.sv}
  {E:/Study Folder/Engineering/Computer Engineering/Computer Systems/Architectures/Notes/Lab/Codes/RISC-V/Synthesis/Synthesis.srcs/sources_1/imports/Modules/Instruction_memory.sv}
  {E:/Study Folder/Engineering/Computer Engineering/Computer Systems/Architectures/Notes/Lab/Codes/RISC-V/Synthesis/Synthesis.srcs/sources_1/imports/Modules/Mux_2x1.sv}
  {E:/Study Folder/Engineering/Computer Engineering/Computer Systems/Architectures/Notes/Lab/Codes/RISC-V/Synthesis/Synthesis.srcs/sources_1/imports/Modules/PC.sv}
  {E:/Study Folder/Engineering/Computer Engineering/Computer Systems/Architectures/Notes/Lab/Codes/RISC-V/Synthesis/Synthesis.srcs/sources_1/imports/Modules/PC_Adder.sv}
  {E:/Study Folder/Engineering/Computer Engineering/Computer Systems/Architectures/Notes/Lab/Codes/RISC-V/Synthesis/Synthesis.srcs/sources_1/imports/Modules/Registers.sv}
  {E:/Study Folder/Engineering/Computer Engineering/Computer Systems/Architectures/Notes/Lab/Codes/RISC-V/Synthesis/Synthesis.srcs/sources_1/imports/Modules/SSD.sv}
  {E:/Study Folder/Engineering/Computer Engineering/Computer Systems/Architectures/Notes/Lab/Codes/RISC-V/Synthesis/Synthesis.srcs/sources_1/imports/Modules/controller.sv}
  {E:/Study Folder/Engineering/Computer Engineering/Computer Systems/Architectures/Notes/Lab/Codes/RISC-V/Synthesis/Synthesis.srcs/sources_1/imports/Modules/imm_gen.sv}
  {E:/Study Folder/Engineering/Computer Engineering/Computer Systems/Architectures/Notes/Lab/Codes/RISC-V/Synthesis/Synthesis.srcs/sources_1/imports/Modules/riscv.sv}
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc {{E:/Study Folder/Engineering/Computer Engineering/Computer Systems/Architectures/Notes/Lab/Codes/RISC-V/Synthesis/Synthesis.srcs/constrs_1/new/IO_Map.xdc}}
set_property used_in_implementation false [get_files {{E:/Study Folder/Engineering/Computer Engineering/Computer Systems/Architectures/Notes/Lab/Codes/RISC-V/Synthesis/Synthesis.srcs/constrs_1/new/IO_Map.xdc}}]

set_param ips.enableIPCacheLiteLoad 0
close [open __synthesis_is_running__ w]

synth_design -top riscv -part xc7a100tcsg324-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef riscv.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file riscv_utilization_synth.rpt -pb riscv_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
