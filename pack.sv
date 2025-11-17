package pack;
parameter Addr_Width = 4;
parameter Data_Width = 32;
integer  total_correct_cnt, total_err_cnt, Data_out_ref_ecnt, valid_out_ecnt;
bit test_finished;
event seq_end, driver_done, mon_done, sb_done, sub_done;
endpackage : pack