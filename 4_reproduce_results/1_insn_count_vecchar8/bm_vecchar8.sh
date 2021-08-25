set -u

path_to_root=../../
bm_file_prefix=superopt-input-bm/input_bm_0108_ab7e41e/
cp ${path_to_root}dependencies/superopt_vecchar8/z3server.out .
main_exe="./main_ebpf_vecchar8.out"
cp ${path_to_root}dependencies/superopt_vecchar8/main_ebpf.out $main_exe
mkdir -p src/isa/ebpf
cp ${path_to_root}dependencies/superopt_vecchar8/src/isa/ebpf/inst.runtime src/isa/ebpf/inst.runtime

fast_mode=0
repeat_cnt=10

USAGE="Usage: $0 output_dir [--fast]"
if [ "$#" -lt 1 ]; then 
    echo $USAGE
    exit 1
fi

output_prefix="$1"
if ! mkdir $output_prefix; then 
    echo "Failed to create $output_prefix"
    exit 1
fi

if [ "$#" -eq 2 ]; then 
    if [ "$2" = "--fast" ]; then
        echo "Running fast benchmarks"
        repeat_cnt=3
        fast_mode=1
    else
        echo $USAGE
        exit 1
    fi
fi

LD_LIBRARY_PATH="$HOME/z3_installs/default/lib"
MIMALLOC_PATH="/usr/local/lib/mimalloc-1.7/libmimalloc.so.1.7"
PRELOAD_PFX="LD_PRELOAD=$MIMALLOC_PATH LD_LIBRARY_PATH=$LD_LIBRARY_PATH"

for x in $(seq $repeat_cnt); do 
	echo "socket/1... $x/$repeat_cnt"
	# socket/1
	bm_file=${bm_file_prefix}ebpf_samples/sockex3_kern_socket-1
	output_dir="${output_prefix}/socket-1/$x/"
	mkdir -p "$output_dir"
	k2_cmd="env $PRELOAD_PFX $main_exe --bm_from_file --desc ${bm_file}.desc --bytecode ${bm_file}.insns --map ${bm_file}.maps -k 1 --is_win --port 8000 --logger_level 0 --w_e 0.5 --w_p 1.5 --st_ex 0 --st_eq 0 --st_avg 0 --st_perf 0 --st_when_to_restart 0 --st_when_to_restart_niter 0 --st_start_prog 0 --p_inst_operand 0.33333333 --p_inst 0.33333333 --p_inst_as_nop 0.15 --reset_win_niter 5000 --win_s_list 1 --win_e_list 9 --path_res $output_dir -n 750000"
	$k2_cmd > "${output_dir}/log.txt"
done
exit 1

for x in $(seq $repeat_cnt); do 
	# sys_enter_open
	echo "sys_enter_open... $x/$repeat_cnt"
	bm_file=${bm_file_prefix}ebpf_samples/syscall_tp_kern_tracepoint-syscalls-sys_enter_open
	output_dir="${output_prefix}/sys_enter_open/$x/"
	mkdir -p "$output_dir"
	k2_cmd="env $PRELOAD_PFX $main_exe --bm_from_file --desc ${bm_file}.desc --bytecode ${bm_file}.insns --map ${bm_file}.maps -k 1 --is_win --port 8000 --logger_level 0 --w_e 0.5 --w_p 1.5 --st_ex 0 --st_eq 0 --st_avg 0 --st_perf 0 --st_when_to_restart 0 --st_when_to_restart_niter 0 --st_start_prog 0 --p_inst_operand 0.4 --p_inst 0.4 --p_inst_as_nop 0.15 --reset_win_niter 80000 --win_s_list 10,10,0 --win_e_list 12,12,3 --path_res $output_dir -n 300000"
	$k2_cmd > "${output_dir}/log.txt"
done

for x in $(seq $repeat_cnt); do 
	# xdp_exception
	echo "xdp_exception... $x/$repeat_cnt"
	bm_file=${bm_file_prefix}ebpf_samples/xdp_monitor_kern_tracepoint-xdp-xdp_exception
	output_dir="${output_prefix}/xdp_exception/$x/"
	mkdir -p "$output_dir"
	k2_cmd="env $PRELOAD_PFX $main_exe --bm_from_file --desc ${bm_file}.desc --bytecode ${bm_file}.insns --map ${bm_file}.maps -k 1 --is_win --port 8000 --logger_level 0 --w_e 0.5 --w_p 1.5 --st_ex 0 --st_eq 0 --st_avg 1 --st_perf 0 --st_when_to_restart 0 --st_when_to_restart_niter 0 --st_start_prog 0 --p_inst_operand 0.4 --p_inst 0.4 --p_inst_as_nop 0.15 --reset_win_niter 5000 --win_s_list 12 --win_e_list 14 --path_res $output_dir -n 1250000"
	$k2_cmd > "${output_dir}/log.txt"
done

if [ $fast_mode -eq 1 ]; then
    exit 0
fi

for x in $(seq $repeat_cnt); do 
	# socket/0
	echo "socket/0... $x/$repeat_cnt"
	bm_file=${bm_file_prefix}ebpf_samples/sockex3_kern_socket-0
	output_dir="${output_prefix}/socket-0/$x/"
	mkdir -p "$output_dir"
	k2_cmd="env $PRELOAD_PFX $main_exe --bm_from_file --desc ${bm_file}.desc --bytecode ${bm_file}.insns --map ${bm_file}.maps -k 1 --is_win --port 8000 --logger_level 0 --w_e 0.5 --w_p 1.5 --st_ex 0 --st_eq 0 --st_avg 0 --st_perf 0 --st_when_to_restart 0 --st_when_to_restart_niter 0 --st_start_prog 0 --p_inst_operand 0.33333333 --p_inst 0.33333333 --p_inst_as_nop 0.15 --reset_win_niter 5000 --win_s_list 1 --win_e_list 6 --path_res $output_dir -n 1250000"
	$k2_cmd > "${output_dir}/log.txt"
done

for x in $(seq $repeat_cnt); do 
	# xdp_redirect_err
	echo "xdp_redirect_err... $x/$repeat_cnt"
	bm_file=${bm_file_prefix}ebpf_samples/xdp_monitor_kern_tracepoint-xdp-xdp_redirect_err
	output_dir="${output_prefix}/xdp_redirect_err/$x/"
	mkdir -p "$output_dir"
	k2_cmd="env $PRELOAD_PFX $main_exe --bm_from_file --desc ${bm_file}.desc --bytecode ${bm_file}.insns --map ${bm_file}.maps -k 1 --is_win --port 8000 --logger_level 0 --w_e 0.5 --w_p 5 --st_ex 0 --st_eq 0 --st_avg 1 --st_perf 0 --st_when_to_restart 0 --st_when_to_restart_niter 0 --st_start_prog 0 --p_inst_operand 0.33333333 --p_inst 0.33333333 --p_inst_as_nop 0.15 --reset_win_niter 50000 --win_s_list 12 --win_e_list 14 --path_res $output_dir -n 2500000"
	$k2_cmd > "${output_dir}/log.txt"
done

for x in $(seq $repeat_cnt); do 
	# xdp1_kern/xdp1
	echo "xdp1_kern/xdp1... $x/$repeat_cnt"
	bm_file=${bm_file_prefix}ebpf_samples/xdp1_kern_xdp1
	output_dir="${output_prefix}/xdp1_kern-xdp1/$x/"
	mkdir -p "$output_dir"
	k2_cmd="env $PRELOAD_PFX $main_exe --bm_from_file --desc ${bm_file}.desc --bytecode ${bm_file}.insns --map ${bm_file}.maps -k 1 --is_win --port 8000 --logger_level 0 --w_e 0.5 --w_p 1.5 --st_ex 0 --st_eq 0 --st_avg 1 --st_perf 0 --st_when_to_restart 0 --st_when_to_restart_niter 0 --st_start_prog 0 --p_inst_operand 0.33333333 --p_inst 0.33333333 --p_inst_as_nop 0.15 --reset_win_niter 80000 --win_s_list 56,56,5,48 --win_e_list 58,58,8,49 --path_res $output_dir -n 2500000"
	$k2_cmd > "${output_dir}/log.txt"
done

for x in $(seq $repeat_cnt); do 
	# xdp_map_access
	echo "xdp_map_access... $x/$repeat_cnt"
	bm_file=${bm_file_prefix}simple_fw/xdp_map_access_kern_xdp_map_acces
	output_dir="${output_prefix}/xdp_map_access/$x/"
	mkdir -p $output_dir
	k2_cmd="env $PRELOAD_PFX $main_exe --bm_from_file --desc ${bm_file}.desc --bytecode ${bm_file}.insns --map ${bm_file}.maps -k 1 --is_win --port 8000 --logger_level 0 --w_e 0.5 --w_p 1.5 --st_ex 1 --st_eq 0 --st_avg 1 --st_perf 0 --st_when_to_restart 0 --st_when_to_restart_niter 0 --st_start_prog 0 --p_inst_operand 0.4 --p_inst 0.4 --p_inst_as_nop 0.15 --reset_win_niter 50000 --win_s_list 2,8 --win_e_list 5,9 --path_res $output_dir -n 5000000"
	$k2_cmd > "${output_dir}/log.txt"
done

for x in $(seq $repeat_cnt); do 
	# xdp_devmap_xmit
	echo "xdp_devmap_xmit... $x/$repeat_cnt"
	bm_file=${bm_file_prefix}ebpf_samples/xdp_monitor_kern_tracepoint-xdp-xdp_devmap_xmit
	output_dir="${output_prefix}/xdp_devmap_xmit/$x/"
	mkdir -p "$output_dir"
	k2_cmd="env $PRELOAD_PFX $main_exe --bm_from_file --desc ${bm_file}.desc --bytecode ${bm_file}.insns --map ${bm_file}.maps -k 1 --is_win --port 8000 --logger_level 0 --w_e 0.5 --w_p 1.5 --st_ex 1 --st_eq 0 --st_avg 1 --st_perf 0 --st_when_to_restart 0 --st_when_to_restart_niter 0 --st_start_prog 0 --p_inst_operand 0.33333333 --p_inst 0.33333333 --p_inst_as_nop 0.15 --reset_win_niter 80000 --win_s_list 15,31,12,21,26,1 --win_e_list 18,33,14,23,28,2 --path_res $output_dir -n 2250000"
	$k2_cmd > "${output_dir}/log.txt"
done


for x in $(seq $repeat_cnt); do 
	# xdp_cpumap_enqueue
	echo "xdp_cpumap_enqueue... $x/$repeat_cnt"
	bm_file=${bm_file_prefix}ebpf_samples/xdp_monitor_kern_tracepoint-xdp-xdp_cpumap_enqueue
	output_dir="${output_prefix}/xdp_cpumap_enqueue/$x/"
	mkdir -p "$output_dir"
	k2_cmd="env $PRELOAD_PFX $main_exe --bm_from_file --desc ${bm_file}.desc --bytecode ${bm_file}.insns --map ${bm_file}.maps -k 1 --is_win --port 8000 --logger_level 0 --w_e 0.5 --w_p 5 --st_ex 1 --st_eq 0 --st_avg 1 --st_perf 0 --st_when_to_restart 0 --st_when_to_restart_niter 0 --st_start_prog 0 --p_inst_operand 0.4 --p_inst 0.4 --p_inst_as_nop 0.15 --reset_win_niter 50000 --win_s_list 22,22,14,18 --win_e_list 24,24,16,20 --path_res $output_dir -n 2000000"
	$k2_cmd > "${output_dir}/log.txt"
done

for x in $(seq $repeat_cnt); do 
	# xdp_fw
	echo "xdp_fw... $x/$repeat_cnt"
	bm_file=${bm_file_prefix}simple_fw/xdp_fw_kern_xdp_fw
	output_dir="${output_prefix}/xdp_fw/$x/"
	mkdir -p "$output_dir"
	k2_cmd="env $PRELOAD_PFX $main_exe --bm_from_file --desc ${bm_file}.desc --bytecode ${bm_file}.insns --map ${bm_file}.maps -k 1 --is_win --port 8000 --logger_level 0 --w_e 0.5 --w_p 5 --st_ex 0 --st_eq 0 --st_avg 0 --st_perf 0 --st_when_to_restart 0 --st_when_to_restart_niter 0 --st_start_prog 0 --p_inst_operand 0.33333333 --p_inst 0.33333333 --p_inst_as_nop 0.15 --reset_win_niter 50000 --win_s_list 10,2,52 --win_e_list 13,5,55 --path_res $output_dir -n 700000"
	$k2_cmd > "${output_dir}/log.txt"
done

for x in $(seq $repeat_cnt); do 
	# xdp_pktcntr
	echo "xdp_pktcntr... $x/$repeat_cnt"
	bm_file=${bm_file_prefix}katran/xdp_pktcntr_xdp-pktcntr
	output_dir="${output_prefix}/xdp_pktcntr/$x/"
	mkdir -p "$output_dir"
	k2_cmd="env $PRELOAD_PFX $main_exe --bm_from_file --desc ${bm_file}.desc --bytecode ${bm_file}.insns --map ${bm_file}.maps -k 1 --is_win --port 8000 --logger_level 0 --w_e 0.5 --w_p 1.5 --st_ex 0 --st_eq 0 --st_avg 1 --st_perf 0 --st_when_to_restart 0 --st_when_to_restart_niter 0 --st_start_prog 0 --p_inst_operand 0.4 --p_inst 0.4 --p_inst_as_nop 0.15 --reset_win_niter 80000 --win_s_list 17,17,0 --win_e_list 19,19,2 --path_res $output_dir -n 5000000"
	$k2_cmd > "${output_dir}/log.txt"
done
