if {[catch {

# define run engine funtion
source [file join {C:/lscc/radiant/2023.2} scripts tcl flow run_engine.tcl]
# define global variables
global para
set para(gui_mode) 1
set para(prj_dir) "C:/Users/david/Desktop/WiFi Headstage/WiFiHeadstage V2/Passthrough"
# synthesize IPs
# synthesize VMs
# synthesize top design
file delete -force -- Passthrough_impl_1.vm Passthrough_impl_1.ldc
run_engine_newmsg synthesis -f "Passthrough_impl_1_lattice.synproj"
run_postsyn [list -a iCE40UP -p iCE40UP5K -t SG48 -sp High-Performance_1.2V -oc Industrial -top -w -o Passthrough_impl_1_syn.udb Passthrough_impl_1.vm] [list {C:/Users/david/Desktop/WiFi Headstage/WiFiHeadstage V2/Passthrough/impl_1/Passthrough_impl_1.ldc}]

} out]} {
   runtime_log $out
   exit 1
}