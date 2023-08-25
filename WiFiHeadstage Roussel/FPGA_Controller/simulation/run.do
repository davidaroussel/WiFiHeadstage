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

vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/SPI_Master.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/SPI_Master_CS.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/stimulus/SPI_Master_CS_tb.vhd"

vsim -L igloo -L presynth  -t 1ps presynth.SPI_Master_CS_TB
add wave /SPI_Master_CS_TB/*
run 10000ns
