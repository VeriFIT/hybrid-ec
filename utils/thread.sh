#!/bin/bash

ROOTDIR="$(dirname "$(realpath "$0")")"

# trap to kill all subprocesses
trap "pkill -P $$; exit" SIGINT SIGTERM

# commandline arguments
if [ $# -eq 4 ]; then
    N_AVG="$1"      # how many times to run the cmd, to average the runtime
    TASK="$2"
    LOGDIR="$3"
    TIMEOUT="$4"
else
    echo "Usage: $0 num_runs_to_avg task timeout"
    exit 1
fi


TEST_NAME=$(echo $TASK | cut -d ";" -f 1)
CMD=$(echo $TASK | cut -d ";" -f 2)
RES=$(echo $TASK | cut -d ";" -f 3)
SETUP=$(echo $TASK | cut -d ";" -f 4)
TEARDOWN=$(echo $TASK | cut -d ";" -f 5)

logFile="$LOGDIR/$TEST_NAME.txt"

totalRuntime=0
totalMemory=0
didTimeout=0
nRuns=0

bash -c "$SETUP"
for i in $(seq 1 $N_AVG)
do
    nRuns=$(($nRuns+1))
    output=$({ /usr/bin/time -f "\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M" timeout --foreground $TIMEOUT $CMD ; } 2>&1 | tee $logFile)

    runtime=$( cat $logFile | grep "real \[s\]" | sed "s|  real \[s\]||")
    totalRuntime=$(awk "BEGIN{ print $runtime + $totalRuntime }")
    memory=$( cat $logFile | grep "[ \t]*mem  \[KB\][ \t]*" | sed "s|[ \t]*mem  \[KB\][ \t]*||")
    totalMemory=$(awk "BEGIN{ print $memory + $totalMemory }")
    
    # check timeout
    if echo "$output" | grep -q "Command exited with non-zero status 124"; then
        didTimeout=1
        break
    fi
done
bash -c "$TEARDOWN"

avgRuntime=$(awk -v OFMT="%.2f" "BEGIN{ print $totalRuntime / $nRuns }")
avgRuntimeMins=$(awk -v OFMT="%.2f" "BEGIN{ print $avgRuntime / 60 }")
avgMemory=$(awk -v OFMT="%.2f" "BEGIN{ print $totalMemory / $nRuns }")
avgMemoryMB=$(awk -v OFMT="%.2f" "BEGIN{ print $avgMemory / 1000 }")
sed -i "s|^  real \[s\]  [0-9\.]*$|  real [m]  $avgRuntimeMins (avg of $nRuns runs)\n  real [s]  $avgRuntime (avg of $nRuns runs)|" $logFile
sed -i "s|^  mem  \[KB\] [0-9\.]*$|  mem  [MB] $avgMemoryMB (avg of $nRuns runs)\n  mem  [KB] $avgMemory (avg of $nRuns runs)|" $logFile

if [ $didTimeout -eq 1 ]; then
    printf "%-55s  %+10s  %+10s      TIMEO    \n" "$TEST_NAME" "${avgRuntime}s" "${avgMemoryMB}MB" | tee -a "./$LOGDIR/test_run.log"
elif echo "$output" | grep -q "Models       : $RES\|	ANSWER:	$RES"; then
    printf "%-55s  %+10s  %+10s   PASS        \n" "$TEST_NAME" "${avgRuntime}s" "${avgMemoryMB}MB" | tee -a "./$LOGDIR/test_run.log"
else
    printf "%-55s  %+10s  %+10s         FAIL  \n" "$TEST_NAME" "${avgRuntime}s" "${avgMemoryMB}MB" | tee -a "./$LOGDIR/test_run.log"
fi