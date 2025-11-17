package scoreboard_pkg;
import pack::*;
import transaction_pkg::*;
class Scoreboard ;
 mailbox #(transaction) sb_mbx;
transaction sb_tr;
logic [Data_Width-1 : 0] Data_out_ref;
logic Valid_out_ref; 
logic [Data_Width-1 : 0] Memory_ref [0 : (2**Addr_Width)-1];

    //sampling task
    task  SB();
        forever begin
         sb_tr = new();
        wait(pack::mon_done.triggered);   
        sb_mbx.get(sb_tr);
        $display ("[%0t] [Scoreboard] Data got from mailbox for scoreboard", $time);
        void'( sb_tr.display_trn());
        golden_reference(sb_tr);
        check_transaction(sb_tr);
        -> sb_done;
        end
    endtask 
  // Constructor
  function new(mailbox #(transaction) mbx);
    this.sb_mbx = mbx;
    // sb_tr =new();
    total_err_cnt = 0;
    total_correct_cnt = 0;
    valid_out_ecnt = 0;
    Data_out_ref_ecnt = 0;
    Data_out_ref = 0;
    Valid_out_ref = 1'b0;
    Memory_ref = '{default:0};
  endfunction : new

  //golden reference method
    task golden_reference(transaction sb_mbx);
 
        if( sb_mbx.rst == 1) begin
            Data_out_ref = Memory_ref[sb_mbx.Address];
        end
        else begin
            Data_out_ref = 0;
        end

     if (sb_mbx.rst ==0) begin
            Valid_out_ref = 1'b0;
            Memory_ref = '{default:0};
        end
        else if (sb_mbx.W_en) begin
           Valid_out_ref = 1'b0;
           Memory_ref[sb_mbx.Address] = sb_mbx.Data_in; 
        end
        else begin
           Valid_out_ref = 1'b1;
        end


    // pastaddr = sb_mbx.Address;
    endtask : golden_reference

  //scoreboard checking method
    task check_transaction(transaction sb_tr);
        if ((sb_tr.Data_out !== Data_out_ref) || (sb_tr.Valid_out !== Valid_out_ref)) begin
            total_err_cnt++;
            $display ("[%0t] [Scoreboard] Mismatch detected! ", $time);
             if (sb_tr.Data_out !== Data_out_ref) begin
                $display ("[%0t] [Scoreboard] Data_out mismatch: Expected = %0h, Actual = %0h", $time, Data_out_ref, sb_tr.Data_out);    
             Data_out_ref_ecnt++;
            end
             if (sb_tr.Valid_out !== Valid_out_ref) begin
                    $display ("[%0t] [Scoreboard] Valid_out mismatch: Expected = %0b, Actual = %0b", $time, Valid_out_ref, sb_tr.Valid_out);
                valid_out_ecnt++;   
             end
                        

        end
        else begin
            $display ("[%0t] [Scoreboard] Transaction matches the reference model. Expected Data_out = %0h, Actual Data_out = %0h, Expected valid_out = %0b, Actual valid_out = %0b ", $time, Data_out_ref, sb_tr.Data_out, Valid_out_ref, sb_tr.Valid_out);
            total_correct_cnt++;
        end
    endtask : check_transaction


endclass : Scoreboard

endpackage : scoreboard_pkg