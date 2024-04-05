new_project \
    -name {Controller_Dual_SPI} \
    -location {C:\Users\David\Desktop\WiFi Headstage GIT\WiFiHeadstage\WiFiHeadstage Roussel\FPGA_Controller\designer\impl1\Controller_Dual_SPI_fp} \
    -mode {single}
set_programming_file -file {C:\Users\David\Desktop\WiFi Headstage GIT\WiFiHeadstage\WiFiHeadstage Roussel\FPGA_Controller\designer\impl1\Controller_Dual_SPI.pdb}
set_programming_action -action {PROGRAM}
run_selected_actions
save_project
close_project
