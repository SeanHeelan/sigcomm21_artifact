#!/usr/bin/env python3

# Compare the output of two versions of K2 across multiple benchmarks. Expects
# input folders in the following format:
#
#   version0/
#       benchmark0/
#           version0_benchmark0_run0/
#           version0_benchmark0_run1/
#           ...
#       benchmark1/
#           ...
#
#   version1/
#       benchmark0/
#           version1_benchmark0_run0/
#           version1_benchmark0_run1/
#           ...
#       benchmark1/
#           ...
#
# For each benchmark the average runtime for each benchmark will be computed
# and printed, as well as some other summary statistics on the variance between
# run.
#
# Author: sean@optimyze.cloud
# Date: 6 August 2021

import sys
import pathlib
import statistics

from dataclasses import dataclass

from prettytable import PrettyTable

@dataclass
class BenchmarkRunResult:
    path: pathlib.Path
    time: float


@dataclass
class BenchmarkResult:
    path: pathlib.Path
    name: str
    avgTime: float


def get_benchmark_run_result(p):
    """p is a path to an output directory created for k2, containing a log.txt
    file.
    """

    print("\t\tProcessing %s ..." % p)
    with open(p / "log.txt") as fd:
        data = fd.readlines()

    for line in data:
        if 'compiling' in line:
            return BenchmarkRunResult(
                    path=p, time=float(line.split(' ')[-2]))

    print("%s does not contain a log.txt" % p)
    sys.exit(-1)


def process_version(v):
    v_res = {}
    print("Processing version %s ..." % v)
    for benchmark in v.glob("*"):
        print("\tProcessing benchmark %s ..." % benchmark)
        runs = [get_benchmark_run_result(p) for p in benchmark.glob("*")]
        t = statistics.mean([r.time for r in runs])
        v_res[benchmark.name] = BenchmarkResult(
                path=benchmark, name=benchmark.name, avgTime=t)

    return v_res


def pretty_print(v0_path, v1_path, v0_res, v1_res):
    t = PrettyTable()
    t.title = "%s vs %s" % (v0_path.name, v1_path.name)

    # Get benchmark names
    bms = [r for r in v0_res.keys()]
    t.add_column('Benchmark', bms)

    # Get benchmark times
    times = []
    for name in bms:
        v0_data = v0_res[name]
        v1_data = v1_res[name]
        times.append(v0_data.avgTime / v1_data.avgTime)

    t.add_column("Time (%)", times)
    print(t)


def compare(v0_path, v1_path):
    v0_res = process_version(v0_path)
    v1_res = process_version(v1_path)

    if len(v0_res) != len(v1_res):
        print("Different number of benchmarks in each version: %d vs %d" %
                len(v0_res), len(v1_res))
        sys.exit(-1)

    pretty_print(v0_path, v1_path, v0_res, v1_res)


def main():
    if len(sys.argv) != 3:
        print("usage: %s <version0_output_path> <version1_output_path>" %
                sys.argv[0])
        sys.exit(1)

    v0_path = pathlib.Path(sys.argv[1])
    v1_path = pathlib.Path(sys.argv[2])

    print("Comparing %s and %s ..." % (v0_path, v1_path))

    compare(v0_path, v1_path)

if __name__ == "__main__":
    main()
