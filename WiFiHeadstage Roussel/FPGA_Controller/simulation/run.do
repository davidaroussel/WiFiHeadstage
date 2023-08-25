quietly set ACTELLIBNAME IGLOO
quietly set PROJECT_DIR "C:/Users/david/Desktop/WiFiHeadstage GIT/WiFiHeadstage/WiFiHeadstage Roussel/FPGA_Controller"

if {[file exists presynth/_info]} {
   echo "INFO: Simulation library presynth already exists"
} else {
   file delete -force presynth 
   vlib presynth
}
vmap presynth presynth
vmap igloo "C:/Microsemi/Libero_SoC_v11.9/Designer/lib/modelsim/precompiled/vhdl/igloo"

vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/smartgen/FIFO/FIFO.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/stimulus/FIFO_tb.vhd"

vsim -L igloo -L presynth  -t 1ps presynth.FIFO_tb
add wave /FIFO_tb/*
run 10000ns
