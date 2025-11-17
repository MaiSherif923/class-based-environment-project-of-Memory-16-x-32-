import envirmoent::*;
import pack::*;
module Tbench;
bit clk;
inf_mem imem(clk);
virtual inf_mem vif;
environment env_inst;
Mem dut(imem.clk, imem.rst, imem.W_en, imem.Address, imem.Data_in, imem.Data_out, imem.Valid_out);
  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10 time units clock period
  end

  // Instantiate environment
  initial begin
    vif = imem;
    env_inst = new(vif);

    
            $display("[%0t] TB: environment started", $time);
            env_inst.run_env();
            $display("[%0t] TB: environment finished", $time);
            if (test_finished) begin
              wait(sb_done.triggered);
              wait(sub_done.triggered);
                $display("[%0t] TEST Completed, total error count = %0d, total correct count = %0d, valid_err_cnt = %0d, data_out_err = %0d", $time, total_err_cnt, total_correct_cnt, valid_out_ecnt, Data_out_ref_ecnt);
                $stop;
          end
  end

    




endmodule : Tbench