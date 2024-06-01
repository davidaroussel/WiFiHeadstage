lappend auto_path "C:/lscc/radiant/2023.2/scripts/tcl/simulation"
package require simulation_generation
set ::bali::simulation::Para(DEVICEPM) {ice40tp}
set ::bali::simulation::Para(DEVICEFAMILYNAME) {iCE40UP}
set ::bali::simulation::Para(PROJECT) {sim}
set ::bali::simulation::Para(MDOFILE) {}
set ::bali::simulation::Para(PROJECTPATH) {C:/Users/david/Desktop/WiFi Headstage/WiFiHeadstage V2/FPGA_Intan_Driver/sim}
set ::bali::simulation::Para(FILELIST) {"C:/Users/david/Desktop/WiFi Headstage/WiFiHeadstage V2/FPGA_Intan_Driver/FIFO_MEM/rtl/FIFO_MEM.v" "C:/Users/david/Desktop/WiFi Headstage/WiFiHeadstage V2/FPGA_Controller/hdl/Controller_RHD64.vhd" "C:/Users/david/Desktop/WiFi Headstage/WiFiHeadstage V2/FPGA_Controller/hdl/SPI_Master.vhd" "C:/Users/david/Desktop/WiFi Headstage/WiFiHeadstage V2/FPGA_Controller/hdl/SPI_Master_CS.vhd" "C:/Users/david/Desktop/WiFi Headstage/WiFiHeadstage V2/FPGA_Controller/stimulus/Controller_RHD64_tb.vhd" }
set ::bali::simulation::Para(GLBINCLIST) {}
set ::bali::simulation::Para(INCLIST) {"none" "none" "none" "none" "none"}
set ::bali::simulation::Para(WORKLIBLIST) {"work" "work" "work" "work" "work" }
set ::bali::simulation::Para(COMPLIST) {"VERILOG" "VHDL" "VHDL" "VHDL" "VHDL" }
set ::bali::simulation::Para(LANGSTDLIST) {"Verilog 2001" "" "" "" "" }
set ::bali::simulation::Para(SIMLIBLIST) {pmi_work ovi_ice40up}
set ::bali::simulation::Para(MACROLIST) {}
set ::bali::simulation::Para(SIMULATIONTOPMODULE) {Controller_RHD64_tb}
set ::bali::simulation::Para(SIMULATIONINSTANCE) {}
set ::bali::simulation::Para(LANGUAGE) {VHDL}
set ::bali::simulation::Para(SDFPATH)  {}
set ::bali::simulation::Para(INSTALLATIONPATH) {C:/lscc/radiant/2023.2}
set ::bali::simulation::Para(MEMPATH) {C:/Users/david/Desktop/WiFi Headstage/WiFiHeadstage V2/FPGA_Intan_Driver/FIFO_MEM}
set ::bali::simulation::Para(UDOLIST) {}
set ::bali::simulation::Para(ADDTOPLEVELSIGNALSTOWAVEFORM)  {1}
set ::bali::simulation::Para(RUNSIMULATION)  {1}
set ::bali::simulation::Para(SIMULATIONTIME)  {100}
set ::bali::simulation::Para(SIMULATIONTIMEUNIT)  {ns}
set ::bali::simulation::Para(SIMULATION_RESOLUTION)  {default}
set ::bali::simulation::Para(ISRTL)  {1}
set ::bali::simulation::Para(HDLPARAMETERS) {}
::bali::simulation::ModelSim_Run
