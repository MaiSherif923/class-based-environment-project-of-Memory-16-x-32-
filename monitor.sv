package monitor_pkg;
import pack::*;
import transaction_pkg::*;
class monitor;
 virtual inf_mem vif;
 mailbox #(transaction) mon_mbx ;
 mailbox #(transaction) mon_mbx_sb;
 transaction mon_tr;
  // Constructor
  function new(virtual inf_mem vif_m, mailbox #(transaction) mbx,  mailbox #(transaction) mbx_sb);
    this.vif = vif_m;
    this.mon_mbx = mbx;
    this.mon_mbx_sb = mbx_sb;
  endfunction : new

    // Task to monitor signals
    task monitor_signals;
        forever begin
          mon_tr = new();
            @(pack::driver_done);
            // @(posedge vif.clk);
            mon_tr.rst      = vif.rst;
            mon_tr.W_en     = vif.W_en;
            mon_tr.Address  = vif.Address;
            mon_tr.Data_in  = vif.Data_in;
            mon_tr.Data_out = vif.Data_out;
            mon_tr.Valid_out= vif.Valid_out;
            $display ("[%0t] [Monitor] Captured data packet from interface", $time);
            void'(mon_tr.display_trn());
            mon_mbx.put(mon_tr);
            mon_mbx_sb.put(mon_tr);
            $display ("[%0t] [Monitor] Data packet put into mailbox", $time);
            -> pack::mon_done;
        end




        endtask : monitor_signals



endclass : monitor
endpackage : monitor_pkg