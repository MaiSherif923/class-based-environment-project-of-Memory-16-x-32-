package Sequencer_pkg;  
import pack::*;
import transaction_pkg::*;
class Sequencer;

mailbox #(transaction) trn_mbx;
transaction seq_tr; //= new();
function new(mailbox #(transaction) mbx);
    trn_mbx = mbx;
endfunction : new


task Generator();
$display("[%0t] SEQUENCER STARTED", $time);

    test_finished = 0;

    repeat (500) begin
        seq_tr = new();  

        assert(seq_tr.randomize()) else $fatal("Randomization failed");

        $display("[%0t] [Generator] Putting transaction into mailbox", $time);
        trn_mbx.put(seq_tr);

        $display("[%0t] SEQUENCER: about to trigger seq_end", $time);
        -> pack::seq_end;
        $display("[%0t] SEQUENCER: triggered seq_end", $time);

        void'(seq_tr.display_trn());
        
        @(pack::driver_done);
    end

    test_finished = 1;
endtask


endclass : Sequencer
endpackage : Sequencer_pkg