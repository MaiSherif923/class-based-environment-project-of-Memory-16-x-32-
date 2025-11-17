import pack::*;
interface inf_mem(input clk);
    bit rst; // Asynchronous active-low reset
    bit W_en;
    bit [Addr_Width-1 : 0] Address;
    bit [Data_Width-1: 0] Data_in;
    logic [Data_Width-1 : 0] Data_out;
    logic Valid_out;



endinterface