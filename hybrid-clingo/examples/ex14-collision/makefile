TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"


#-----------------------------------------------------------------------------------------------------------------------
# base
LPX_CMD=python ../../hec-incr.py ./model.lp --maxtime $$MAXTIME
CON_CMD=python ../../hec-incr.py ./model.lp --maxtime $$MAXTIME --con

run-lpx:
	MAXTIME=1000; HEIGHT=20; ${TIME} ${LPX_CMD}

run-lpx-nosig:
	MAXTIME=1000; HEIGHT=20; ${TIME} ${LPX_CMD} --no_signifstep


run-con:
	MAXTIME=1000; HEIGHT=20; ${TIME} ${CON_CMD}
run-con-nosig:
	MAXTIME=1000; HEIGHT=20; ${TIME} ${CON_CMD} --no_signifstep


#-----------------------------------------------------------------------------------------------------------------------
# log the execution

log-lpx:
	@mkdir -p ./logs ; rm -f ./logs/lpx*.log
	NAME=; 		MAXTIME=1000;	HEIGHT=20;	../../../utils/maketrace.sh "${LPX_CMD}" ./logs/lpx$$NAME-h$$HEIGHT.log ; exit 0

log-con:
	@mkdir -p ./logs ; rm -f ./logs/con*.log
	NAME=; 		MAXTIME=1000;	HEIGHT=20;	../../../utils/maketrace.sh "${CON_CMD}" ./logs/con$$NAME-h$$HEIGHT.log ; exit 0
