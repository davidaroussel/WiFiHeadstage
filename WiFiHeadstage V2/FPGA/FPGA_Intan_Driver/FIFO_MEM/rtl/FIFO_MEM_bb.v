/*******************************************************************************
    Verilog netlist generated by IPGEN Lattice Radiant Software (64-bit)
    2023.2.1.288.0
    Soft IP Version: 1.4.0
    2025 05 06 14:41:01
*******************************************************************************/
/*******************************************************************************
    Wrapper Module generated per user settings.
*******************************************************************************/
module FIFO_MEM (clk_i, rst_i, wr_en_i, rd_en_i, wr_data_i, full_o, empty_o,
    almost_full_o, almost_empty_o, data_cnt_o, rd_data_o)/* synthesis syn_black_box syn_declare_black_box=1 */;
    input  clk_i;
    input  rst_i;
    input  wr_en_i;
    input  rd_en_i;
    input  [31:0]  wr_data_i;
    output  full_o;
    output  empty_o;
    output  almost_full_o;
    output  almost_empty_o;
    output  [7:0]  data_cnt_o;
    output  [31:0]  rd_data_o;
endmodule