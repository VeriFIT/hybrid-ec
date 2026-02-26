TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"


#-----------------------------------------------------------------------------------------------------------------------
# base
LPX_CMD=python ../../hec-incr.py ./model.lp --maxtime $$MAXTIME
LPX_CMD_ZENO=python ../../hec-incr.py ./model-zeno.lp --maxtime $$MAXTIME
#LPX_CMD_ZENO=python -m clingolpx --enable-python --strict -n10 ./model-zeno.lp ../axioms/hec.lp ../axioms/hec-show.lp -c maxstep=$$MAXSTEP -c maxtime=$$MAXTIME
CON_CMD=python ../../hec-incr.py ./model-con.lp --maxtime $$MAXTIME --con
CON_CMD_ZENO=python ../../hec-incr.py ./model-zeno.lp --maxtime $$MAXTIME --con 
#CON_CMD_ZENO=python -m clingcon --enable-python -n10 ./model-zeno.lp ../axioms/hec.lp ../axioms/hec-show.lp -c maxstep=$$MAXSTEP -c maxtime=$$MAXTIME

run-lpx:
	MAXTIME=1000; ${TIME} ${LPX_CMD} 
run-lpx-nosig:
	MAXTIME=1000; ${TIME} ${LPX_CMD} --no_signifstep
run-lpx-zeno:
	MAXTIME=1000; ${TIME} ${LPX_CMD_ZENO}  


run-con:
	MAXTIME=1000; ${TIME} ${CON_CMD} 
run-con-nosig:
	MAXTIME=1000; ${TIME} ${CON_CMD} --no_signifstep
run-con-zeno:	# generates all combinations of placement of timepoints (use --project to only see one)
	MAXTIME=1000; ${TIME} ${CON_CMD_ZENO} --project


#-----------------------------------------------------------------------------------------------------------------------
# log the execution

log-lpx:
	@mkdir -p ./logs ; rm -f ./logs/lpx*.log
	NAME=-zeno	MAXTIME=1000;  ../../../utils/maketrace.sh "${LPX_CMD_ZENO} 	" ./logs/lpx$$NAME.log ; exit 0
	NAME=;		MAXTIME=1000;  ../../../utils/maketrace.sh "${LPX_CMD} 		" ./logs/lpx$$NAME.log ; exit 0

log-con:
	@mkdir -p ./logs ; rm -f ./logs/ccon*.log
	NAME=-zeno	MAXTIME=1000;  ../../../utils/maketrace.sh "${CON_CMD_ZENO} --project" ./logs/ccon$$NAME.log ; exit 0
	NAME=;		MAXTIME=1000;  ../../../utils/maketrace.sh "${CON_CMD} 		" ./logs/ccon$$NAME.log ; exit 0
