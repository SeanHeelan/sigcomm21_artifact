#!/bin/bash

OUTPUT_DIR="$HOME/k2_benchmark_output/"
pushd 1_insn_count_default
sh ./bm_default.sh $OUTPUT_DIR/default_output
popd

pushd 1_insn_count_mimalloc
sh ./bm_mimalloc.sh $OUTPUT_DIR/mimalloc_output
popd

pushd 1_insn_count_vecchar8
sh ./bm_vecchar8.sh $OUTPUT_DIR/vecchar8_output
popd
