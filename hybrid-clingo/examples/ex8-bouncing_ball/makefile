TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"


#-----------------------------------------------------------------------------------------------------------------------
# base
LPX_CMD=python ../hec-incr.py --maxtime $$MAXTIME
CON_CMD=python ../hec-incr.py --maxtime $$MAXTIME --con

run-lpx:
	MAXTIME=1000; ${TIME} ${LPX_CMD} ./model.lp ./narrative1.lp 
run-lpx-nocatch:
	MAXTIME=1000; ${TIME} ${LPX_CMD} ./model.lp ./narrative2.lp --no_last_step --keep_going --minstep 8 --maxstep 10
run-lpx-nosig:
	MAXTIME=1000; ${TIME} ${LPX_CMD} ./model.lp ./narrative1.lp --no_signifstep
#run-lpx-nocatch-nosig:	# does not work here since last step is disabled
#	MAXTIME=1000; ${TIME} ${LPX_CMD} ./model.lp ./narrative2.lp --no_last_step --no_signifstep --keep_going --minstep 8 --maxstep 10


#-----------------------------------------------------------------------------------------------------------------------
# fixed zeno

run-lpx-fix-flat_loss:
	MAXTIME=1000; ${TIME} ${LPX_CMD} ./fix-flat_loss.lp ./narrative2.lp
run-lpx-fix-min_dur:
	MAXTIME=1000; ${TIME} ${LPX_CMD} ./fix-min_dur.lp ./narrative2.lp
	
run-lpx-fix-flat_loss-nosig:
	MAXTIME=1000; ${TIME} ${LPX_CMD} ./fix-flat_loss.lp ./narrative2.lp --no_signifstep
run-lpx-fix-min_dur-nosig:
	MAXTIME=1000; ${TIME} ${LPX_CMD} ./fix-min_dur.lp ./narrative2.lp --no_signifstep
	

#-----------------------------------------------------------------------------------------------------------------------
# log the execution

log-lpx:
	@mkdir -p ./logs ; rm -f ./logs/lpx*.log
	MODEL=model; 			NAME=;		MAXTIME=1000;	../../../utils/maketrace.sh "${LPX_CMD} ./$$MODEL.lp ./narrative1.lp" ./logs/lpx-$$MODEL$$NAME.log ; exit 0
	MODEL=model; 			NAME=many	MAXTIME=1000;	../../../utils/maketrace.sh "${LPX_CMD} ./$$MODEL.lp ./narrative2.lp --no_last_step --keep_going --minstep 8 --maxstep 10" ./logs/lpx-$$MODEL$$NAME.log ; exit 0
	MODEL=fix-flat_loss; 	NAME=;		MAXTIME=1000;	../../../utils/maketrace.sh "${LPX_CMD} ./$$MODEL.lp ./narrative2.lp" ./logs/lpx-$$MODEL$$NAME.log ; exit 0
	MODEL=fix-min_dur; 	 	NAME=;		MAXTIME=1000;	../../../utils/maketrace.sh "${LPX_CMD} ./$$MODEL.lp ./narrative2.lp" ./logs/lpx-$$MODEL$$NAME.log ; exit 0
