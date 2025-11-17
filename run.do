vlib work
vlog +define+SIM -f file.list +cover -covercells
vsim -voptargs=+acc work.Tbench -cover
##coverage save Tbench.ucdb -onexit 
add wave -position insertpoint  \
sim:/Tbench/imem/Address \
sim:/Tbench/imem/clk \
sim:/Tbench/imem/Data_in \
sim:/Tbench/imem/Data_out \
sim:/Tbench/imem/rst \
sim:/Tbench/imem/Valid_out \
sim:/Tbench/imem/W_en
add wave -position end  sim:/pack::total_correct_cnt
add wave -position end  sim:/pack::total_err_cnt
run -all
##quit -sim
##vcover report top_fifo.ucdb -details -annotate -all -output coverageFIFO_rpt.txt