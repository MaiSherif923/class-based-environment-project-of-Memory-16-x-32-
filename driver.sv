package driver_pkg;
import pack::*;
import transaction_pkg::*;
class driver ;
virtual inf_mem vif;
transaction drv_tr;
mailbox #(transaction) drv_mbx;
  // Constructor
  function new(virtual inf_mem vif_d, mailbox #(transaction) mbx);
    this.vif = vif_d;
    this.drv_mbx = mbx;
  endfunction : new

  // Task to drive stimulus
  task drive();
    forever begin
      drv_tr = new();
    $display ("[%0t] [Driver] Going to get data packet from mailbox", $time);
    $display("[%0t] DRIVER: waiting for seq_end...", $time);
    wait(pack::seq_end.triggered);
    $display("[%0t] DRIVER: got seq_end, proceeding...", $time);
    drv_mbx.get(drv_tr); 
    $display ("[%0t] [Driver] Data got from mailbox", $time);
    // Drive the interface signals
    vif.rst      <= drv_tr.rst;
    vif.W_en     <= drv_tr.W_en;
    vif.Address  <= drv_tr.Address;
    vif.Data_in  <= drv_tr.Data_in;
    @(posedge vif.clk);
    $display ("[%0t] [Driver] Driven data packet to interface,rst=%0b, W_en=%0b, Address=%0h, Data_in=%0h", $time, vif.rst, vif.W_en, vif.Address, vif.Data_in);
    -> pack::driver_done;
    end

  endtask : drive


endclass : driver
endpackage : driver_pkg