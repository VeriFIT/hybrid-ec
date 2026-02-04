# !/bin/bash


if [ $# -eq 2 ]; then
    command_to_run="$1"
    log_file="$2"
else
    echo "Usage: $0 command_to_run file_to_log_to"
    exit 1
fi

echo "$ $command_to_run" > "$log_file"
echo >> "$log_file"
echo >> "$log_file"

#stderr=$(/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K" $command_to_run 2>&1 1>> "$log_file")
#echo  >> "$log_file"
#echo "$stderr" >> "$log_file"

# in `sh -c "..."` so that the "command_to_run" can include pipes
# the time command will only measure the first command in the pipe
# stderr goes to the end of the file
stderr=$(sh -c "/usr/bin/time -f \"\\n  real      %E\\n  real [s]  %e\\n  user [s]  %U\\n  sys  [s]  %S\\n  mem  [KB] %M\\n  avgm [KB] %K\" $command_to_run" 2>&1 1>> "$log_file")
echo  >> "$log_file"
echo "$stderr" >> "$log_file"
