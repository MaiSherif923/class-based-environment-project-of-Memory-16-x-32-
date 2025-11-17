

package transaction_pkg;
import pack::*;
class transaction;

   rand bit rst; // Asynchronous active-low reset
   rand bit W_en;
   rand bit [Addr_Width-1 : 0] Address;
   rand bit [Data_Width-1: 0] Data_in;
    logic [Data_Width-1 : 0] Data_out;
    logic Valid_out;
    constraint rst_c { rst dist {0:=2, 1:=98 };} // 10% reset, 90% normal operation

    function display_trn(); 
        $display("at time [%0t] rst=%0b, W_en=%0b, Address=%0h, Data_in=%0h", $time, rst, W_en, Address, Data_in);
    endfunction : display_trn

endclass : transaction
endpackage : transaction_pkg