#!/bin/bash
path_prefix=1_hello_world/
path_to_root=../
k2_path=dependencies/superopt/
k2_to_root=../../
benchmark=benchmark.k2
echo "Benchmark is" $benchmark
output_file=$benchmark.out
if [ ! -d "output" ]; then
  mkdir output
fi
cd $path_to_root; cd $k2_path
translater_cmd="./input_translater/k2_inst_translater.out ${k2_to_root}${path_prefix}$benchmark ${k2_to_root}${path_prefix}benchmark.insns"
$translater_cmd
echo "Running K2 to optimize benchmark..."
k2_cmd="./main_ebpf.out --bm_from_file --desc ${k2_to_root}${path_prefix}benchmark.desc --bytecode ${k2_to_root}${path_prefix}benchmark.insns --map ${k2_to_root}${path_prefix}benchmark.maps  -k 1 --is_win --port 8000 --logger_level 1 --w_e 0.5 --w_p 1.5 --st_ex 0 --st_eq 0 --st_avg 1 --st_perf 0 --st_when_to_restart 0 --st_when_to_restart_niter 0 --st_start_prog 0 --p_inst_operand 0.33333333 --p_inst 0.33333333 --p_inst_as_nop 0.15 --reset_win_niter 5000 --win_s_list 0 --win_e_list 1 --path_res ${k2_to_root}${path_prefix}output/ -n 50000"
$k2_cmd > ${k2_to_root}${path_prefix}output/log.txt
cd $k2_to_root; cd $path_prefix
echo "Finish running:"
grep "original" output/log.txt
echo "best program found by K2: "
grep "top 1 " output/log.txt
echo "Optimized program is stored in" $output_file
mv output/output0.desc $output_file
grep "compiling" output/log.txt
rm -rf output
rm -rf benchmark.insns
