quietly set ACTELLIBNAME IGLOO
quietly set PROJECT_DIR "C:/Users/David/Desktop/WiFi Headstage GIT/WiFiHeadstage/WiFiHeadstage Roussel/FPGA_Controller"

if {[file exists postsynth/_info]} {
   echo "INFO: Simulation library postsynth already exists"
} else {
   file delete -force postsynth 
   vlib postsynth
}
vmap postsynth postsynth
vmap igloo "C:/Microsemi/Libero_SoC_v11.9/Designer/lib/modelsim/precompiled/vhdl/igloo"

vcom -2008 -explicit  -work postsynth "${PROJECT_DIR}/synthesis/Controller_Dual_SPI.vhd"
vcom -2008 -explicit  -work postsynth "${PROJECT_DIR}/stimulus/Controller_Dual_SPI_tb.vhd"

vsim -L igloo -L postsynth  -t 1ps postsynth.Controller_Dual_SPI_tb
add wave /Controller_Dual_SPI_tb/*
run 50000ns
