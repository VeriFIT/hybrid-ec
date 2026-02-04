TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"


#-----------------------------------------------------------------------------------------------------------------------
# base
LPX_CMD=python ../hec-incr.py --maxtime $$MAXTIME
CON_CMD=python ../hec-incr.py --maxtime $$MAXTIME --con

run-lpx:
	MAXTIME=1000; ${TIME} ${LPX_CMD} ./model.lp --no_last_step

run-lpx-10:
	MAXTIME=1000; ${TIME} ${LPX_CMD} ./model.lp --no_last_step --keep_going --minstep 8 --maxstep 10


run-con: # enumarates all possible placements of events at timepoints -- use project
	MAXTIME=1000; ${TIME} ${CON_CMD} ./model.lp --no_last_step --project
run-con-10: # enumarates all possible placements of events at timepoints -- use project
	MAXTIME=1000; ${TIME} ${CON_CMD} ./model.lp --no_last_step --project  --keep_going --minstep 8 --maxstep 10


#-----------------------------------------------------------------------------------------------------------------------
# fixed zeno

run-lpx-fixed:
	MAXTIME=15; ${TIME} ${LPX_CMD} ./model-fixed.lp
run-lpx-fixed-nosig:
	MAXTIME=15; ${TIME} ${LPX_CMD} ./model-fixed.lp --no_signifstep

run-lpx-fixed-50:
	MAXTIME=63; ${TIME} ${LPX_CMD} ./model-fixed.lp 


run-con-fixed:
	MAXTIME=15; ${TIME} ${CON_CMD} ./model-con-fixed.lp
run-con-fixed-nosig:
	MAXTIME=15; ${TIME} ${CON_CMD} ./model-con-fixed.lp --no_signifstep

run-con-fixed-50:
	MAXTIME=59; ${TIME} ${CON_CMD} ./model-con-fixed.lp


#-----------------------------------------------------------------------------------------------------------------------
# log the execution

log-lpx:
	@mkdir -p ./logs ; rm -f ./logs/lpx*.log
	MODEL=model; 			NAME=;		MAXTIME=1000;	../../../utils/maketrace.sh "${LPX_CMD} ./$$MODEL.lp --no_last_step" ./logs/lpx-$$MODEL$$NAME.log ; exit 0
	MODEL=model-fixed; 		NAME=;		MAXTIME=15;		../../../utils/maketrace.sh "${LPX_CMD} ./$$MODEL.lp" ./logs/lpx-$$MODEL$$NAME.log ; exit 0
#	MODEL=model-fixed; 		NAME=many;  MAXTIME=63;		../../../utils/maketrace.sh "${LPX_CMD} ./$$MODEL.lp" ./logs/lpx-$$MODEL$$NAME.log ; exit 0

log-con:
	@mkdir -p ./logs ; rm -f ./logs/con*.log
	MODEL=model; 			NAME=;		MAXTIME=1000;	../../../utils/maketrace.sh "${CON_CMD} ./$$MODEL.lp --no_last_step --project" ./logs/con-$$MODEL$$NAME.log ; exit 0
	MODEL=model-con-fixed; 	NAME=;		MAXTIME=15;		../../../utils/maketrace.sh "${CON_CMD} ./$$MODEL.lp" ./logs/con-$$MODEL$$NAME.log ; exit 0
#	MODEL=model-con-fixed; 	NAME=many;  MAXTIME=59;		../../../utils/maketrace.sh "${CON_CMD} ./$$MODEL.lp" ./logs/con-$$MODEL$$NAME.log ; exit 0
