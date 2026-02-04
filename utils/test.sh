#!/bin/bash

ROOTDIR="$(dirname "$(realpath "$0")")"


# trap to kill all subprocesses
trap "pkill -P $$; exit" SIGINT SIGTERM

# commandline arguments
timeout="0"
if [ $# -eq 6 ]; then
    TasksFile="$1"
    ExecDir="$2"
    LogDir="$3"
    NcpusToUse="$4"
    NrunsToAvg="$5"
    timeout="$6"
else
    echo "Usage: $0 tasks_for_exec exec_dir output_dir_relative_to_exec_dir use_n_CPU_cores num_runs_to_avg timeout"
    exit 1
fi


tasks=$( $TasksFile | grep -v "^$")
Ntasks=$(echo "$tasks" | wc -l)
Ncpus=$(lscpu -b -p=Core,Socket | grep -v '^#' | sort -u | wc -l)
cpuName=$(cat /proc/cpuinfo | grep "model name" | head -n1 | sed "s|.*: ||" | sed "s|  *| |g")

cd "$ExecDir"

# clean last outputs and prep folder for new outputs
rm -rf "$LogDir"
mkdir -p "$LogDir"

# print intro
echo "Running measurements:" | tee "$LogDir/test_run.log"
echo "  using a pool of $NcpusToUse CPU cores (out of $Ncpus available) to run $Ntasks queries in parallel" | tee -a "$LogDir/test_run.log"
echo "  average over N runs: $NrunsToAvg" | tee -a "$LogDir/test_run.log"
echo "  timeout per run    : $timeout" | tee -a "$LogDir/test_run.log"
echo "  CPU model          : $cpuName" | tee -a "$LogDir/test_run.log"
echo | tee -a "$LogDir/test_run.log"

# print progress bar and then jump cursor back to start
for i in $(seq 1 1 "$Ntasks"); do
    echo -e "$i\tIN PROGRESS"
done
echo -en "\033[${Ntasks}A"

run_queries()
{
    # run all queires in parallel using a pool of CPUs, and measure the total runtime
    # NOTE: shuffle the list of queries bc some batches of queries may take longer (e.g., to try and avoid one thread having to do all the slow queries)
    echo "$tasks" | shuf | xargs -I TASK --max-procs=$NcpusToUse bash -c "$ROOTDIR/thread.sh $NrunsToAvg \"TASK\" $LogDir $timeout"
}

{ time run_queries ; } 2> $LogDir/total_time.txt


# sort the results of queries
logSortedQueryResults=$(cat "$LogDir/test_run.log" | tail -n+7 | LC_ALL=C.UTF-8 sort)
logHead=$(cat "$LogDir/test_run.log" | head -n 6)
# rewrite the log file with the sorted query results
echo "$logHead" > "$LogDir/test_run.log"
echo >> "$LogDir/test_run.log"
echo "$logSortedQueryResults" >> "$LogDir/test_run.log"

# append total time
echo | tee -a "$LogDir/test_run.log"
cat "$LogDir/total_time.txt" | tee -a "$LogDir/test_run.log"
exit 0

