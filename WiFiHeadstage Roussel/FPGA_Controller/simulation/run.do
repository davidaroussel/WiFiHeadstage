quietly set ACTELLIBNAME IGLOO
quietly set PROJECT_DIR "C:/Users/David/Desktop/WiFi Headstage GIT/WiFiHeadstage/WiFiHeadstage Roussel/FPGA_Controller"

if {[file exists presynth/_info]} {
   echo "INFO: Simulation library presynth already exists"
} else {
   file delete -force presynth 
   vlib presynth
}
vmap presynth presynth
vmap igloo "C:/Microsemi/Libero_SoC_v11.9/Designer/lib/modelsim/precompiled/vhdl/igloo"

vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/smartgen/FIFO/FIFO.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/SPI_Master.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/SPI_Master_CS.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/Controller.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/stimulus/Controller_tb.vhd"

vsim -L igloo -L presynth  -t 1ps presynth.Controller_tb
add wave /Controller_tb/*
run 50000ns
