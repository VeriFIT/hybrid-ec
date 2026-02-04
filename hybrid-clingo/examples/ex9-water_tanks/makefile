TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"


#-----------------------------------------------------------------------------------------------------------------------
# base
LPX_CMD=python ../hec-incr.py --maxtime $$MAXTIME
CON_CMD=python ../hec-incr.py --maxtime $$MAXTIME --con

run-lpx:
	MAXTIME=19; ${TIME} ${LPX_CMD} ./model.lp
run-lpx-nosig:
	MAXTIME=19; ${TIME} ${LPX_CMD} ./model.lp --no_signifstep

run-lpx-10:
	MAXTIME=1000; ${TIME} ${LPX_CMD} ./model.lp --no_last_step --keep_going --minstep 8 --maxstep 10


#-----------------------------------------------------------------------------------------------------------------------
# fixed zeno

run-lpx-fix:
	MAXTIME=22; ${TIME} ${LPX_CMD} ./model-fixed.lp
run-lpx-fix-nosig:
	MAXTIME=22; ${TIME} ${LPX_CMD} ./model-fixed.lp --no_signifstep
	

#-----------------------------------------------------------------------------------------------------------------------
# log the execution

log-lpx:
	@mkdir -p ./logs ; rm -f ./logs/lpx*.log
	MODEL=; 			NAME=;		MAXTIME=19;		../../../utils/maketrace.sh "${LPX_CMD} ./model$$MODEL.lp" ./logs/lpx$$MODEL$$NAME.log ; exit 0
	MODEL=; 			NAME=many;	MAXTIME=1000;	../../../utils/maketrace.sh "${LPX_CMD} ./model$$MODEL.lp --no_last_step --keep_going --minstep 8 --maxstep 10" ./logs/lpx$$MODEL$$NAME.log ; exit 0
	MODEL=-fixed; 		NAME=;		MAXTIME=22;		../../../utils/maketrace.sh "${LPX_CMD} ./model$$MODEL.lp" ./logs/lpx$$MODEL$$NAME.log ; exit 0
