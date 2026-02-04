TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"


#-----------------------------------------------------------------------------------------------------------------------
# base
LPX_CMD=python ../hec-incr.py --maxtime $$MAXTIME
CON_CMD=python ../hec-incr.py --maxtime $$MAXTIME --con

run-lpx-effect:
	MAXTIME=1000; ${TIME} ${LPX_CMD} ./model-effect_constr.lp
run-lpx-state:
	MAXTIME=1000; ${TIME} ${LPX_CMD} ./model-state_constr.lp
run-lpx-state-cont:
	MAXTIME=1000; ${TIME} ${LPX_CMD} ./model-state_constr-continuous.lp


run-lpx-effect-nosig:	
	MAXTIME=1000; ${TIME} ${LPX_CMD} --no_signifstep ./model-effect_constr.lp
run-lpx-state-nosig:	
	MAXTIME=1000; ${TIME} ${LPX_CMD} --no_signifstep ./model-state_constr.lp
run-lpx-state-cont-nosig:
	MAXTIME=1000; ${TIME} ${LPX_CMD} --no_signifstep ./model-state_constr-continuous.lp


run-con-effect:
	MAXTIME=1000; ${TIME} ${CON_CMD} ./model-effect_constr.lp
run-con-state:
	MAXTIME=1000; ${TIME} ${CON_CMD} ./model-state_constr.lp
run-con-state-cont:
	MAXTIME=1000; ${TIME} ${CON_CMD} ./model-state_constr-continuous.lp


run-con-effect-nosig:	
	MAXTIME=1000; ${TIME} ${CON_CMD} --no_signifstep ./model-effect_constr.lp
run-con-state-nosig:	
	MAXTIME=1000; ${TIME} ${CON_CMD} --no_signifstep ./model-state_constr.lp
run-con-state-cont-nosig:	
	MAXTIME=1000; ${TIME} ${CON_CMD} --no_signifstep ./model-state_constr-continuous.lp


#-----------------------------------------------------------------------------------------------------------------------
# log the execution

log-lpx:
	@mkdir -p ./logs ; rm -f ./logs/lpx*.log
	MODEL=-effect_constr;			NAME=; 		MAXTIME=1000;	../../../utils/maketrace.sh "${LPX_CMD} ./model$$MODEL$$NAME.lp" ./logs/lpx$$MODEL$$NAME.log ; exit 0
	MODEL=-state_constr;			NAME=; 		MAXTIME=1000;	../../../utils/maketrace.sh "${LPX_CMD} ./model$$MODEL$$NAME.lp" ./logs/lpx$$MODEL$$NAME.log ; exit 0
	MODEL=-state_constr-continuous; NAME=; 		MAXTIME=1000;	../../../utils/maketrace.sh "${LPX_CMD} ./model$$MODEL$$NAME.lp" ./logs/lpx$$MODEL$$NAME.log ; exit 0

log-con:
	@mkdir -p ./logs ; rm -f ./logs/con*.log
	MODEL=-effect_constr;			NAME=; 		MAXTIME=1000;	../../../utils/maketrace.sh "${CON_CMD} ./model$$MODEL$$NAME.lp" ./logs/con$$MODEL$$NAME.log ; exit 0
	MODEL=-state_constr;			NAME=; 		MAXTIME=1000;	../../../utils/maketrace.sh "${CON_CMD} ./model$$MODEL$$NAME.lp" ./logs/con$$MODEL$$NAME.log ; exit 0
	MODEL=-state_constr-continuous; NAME=; 		MAXTIME=1000;	../../../utils/maketrace.sh "${CON_CMD} ./model$$MODEL$$NAME.lp" ./logs/con$$MODEL$$NAME.log ; exit 0
