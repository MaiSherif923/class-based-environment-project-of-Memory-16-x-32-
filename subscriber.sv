package subscriber_pkg;
import pack::*;
import transaction_pkg::*;
class subscriber ;
 mailbox #(transaction) sub_mbx = new();
transaction sub_tr;

covergroup cg_subscriber;

   wr_cp: coverpoint sub_tr.W_en {
        bins write_enabled = {1};
        bins write_disabled = {0};
        bins transition_bins[] = (0 => 1, 1 => 0);
    }
  valid_out_cp:  coverpoint sub_tr.Valid_out{ 
        bins valid_true = {1};
        bins valid_false = {0};
        bins transition_bins[] = (0 => 1, 1 => 0);
    }
        coverpoint sub_tr.Address ;
    cross wr_cp, valid_out_cp
    {
         option.cross_auto_bin_max = 0;
        bins wr_valid_cross = binsof(wr_cp.write_disabled) && binsof(valid_out_cp.valid_true);
    }


endgroup 
    //sampling task
    task  sample_transaction();
    forever begin
        sub_tr = new();
        wait(pack::mon_done.triggered);
        sub_mbx.get(sub_tr);
        $display ("[%0t] [Subscriber] Data got from mailbox for coverage sampling", $time);
        void'( sub_tr.display_trn());
        cg_subscriber.sample();
        $display ("[%0t] [Subscriber] Coverage sampled for the transaction", $time);
        ->sub_done;
    end
    endtask : sample_transaction
  // Constructor
  function new(mailbox #(transaction) mbx);
    this.sub_mbx = mbx;
    cg_subscriber = new();
  endfunction : new


endclass : subscriber

endpackage : subscriber_pkg