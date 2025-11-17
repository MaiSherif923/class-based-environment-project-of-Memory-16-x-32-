package envirmoent;
import pack::*;
import transaction_pkg::*;
import driver_pkg::*;
import monitor_pkg::*;
import scoreboard_pkg::*;
import subscriber_pkg::*;
import Sequencer_pkg::*;
class environment;
mailbox #(transaction) trn_mbx = new();
mailbox #(transaction) mon_mbx = new(); //between monitor and subscriber
mailbox #(transaction) mon_mbx_sb = new(); //between monitor and scoreboard
virtual inf_mem env_vif;
//transaction seq_tr = new();
Sequencer sequencer_inst;
driver driver_inst;
monitor monitor_inst;
Scoreboard scoreboard_inst;
subscriber subscriber_inst;

// Constructor
  function new(virtual inf_mem vif);
    this.env_vif = vif;
     sequencer_inst = new(trn_mbx);
     driver_inst = new(env_vif,trn_mbx);
     monitor_inst = new(env_vif, mon_mbx, mon_mbx_sb);
     scoreboard_inst = new(mon_mbx_sb);
     subscriber_inst = new(mon_mbx);
  endfunction : new

    // Task to start environment components
    task run_env();

        fork
            sequencer_inst.Generator();
            driver_inst.drive();
            monitor_inst.monitor_signals();
            scoreboard_inst.SB();
            subscriber_inst.sample_transaction();
        join_any

    endtask : run_env

endclass : environment;

    
endpackage