if {[catch {

# define run engine funtion
source [file join {C:/lscc/radiant/2023.2} scripts tcl flow run_engine.tcl]
# define global variables
global para
set para(gui_mode) 1
set para(prj_dir) "C:/Users/david/Desktop/WiFi Headstage/WiFiHeadstage V2/FPGA/FPGA_Intan_Driver"
# synthesize IPs
# synthesize VMs
# propgate constraints
file delete -force -- FPGA_Intan_Driver_impl_1_cpe.ldc
run_engine_newmsg cpe -f "FPGA_Intan_Driver_impl_1.cprj" "PLL_SPI.cprj" "FIFO_MEM.cprj" -a "iCE40UP"  -o FPGA_Intan_Driver_impl_1_cpe.ldc
# synthesize top design
file delete -force -- FPGA_Intan_Driver_impl_1.vm FPGA_Intan_Driver_impl_1.ldc
run_engine_newmsg synthesis -f "FPGA_Intan_Driver_impl_1_lattice.synproj"
run_postsyn [list -a iCE40UP -p iCE40UP5K -t SG48 -sp High-Performance_1.2V -oc Industrial -top -w -o FPGA_Intan_Driver_impl_1_syn.udb FPGA_Intan_Driver_impl_1.vm] [list {C:/Users/david/Desktop/WiFi Headstage/WiFiHeadstage V2/FPGA/FPGA_Intan_Driver/impl_1/FPGA_Intan_Driver_impl_1.ldc}]

} out]} {
   runtime_log $out
   exit 1
}
