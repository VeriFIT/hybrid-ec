TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"

AXIOMS=../axioms/dec_clingo.lp ../axioms/dec_clingo-show.lp

#-----------------------------------------------------------------------------------------------------------------------
# base

CMD=clingo -c maxtime=$$MAXTIME -n 0 ${AXIOMS}
run-effect:
	MAXTIME=50; ${TIME} ${CMD} ./model-effect_constr.lp
run-state:
	MAXTIME=50; ${TIME} ${CMD} ./model-state_constr.lp
run-state-cont:
	MAXTIME=70; ${TIME} ${CMD} ./model-state_constr-continuous.lp


#-----------------------------------------------------------------------------------------------------------------------
# alternatives (fixes / improvements)


#-----------------------------------------------------------------------------------------------------------------------
# log the execution

log:
	@mkdir -p ./logs ; rm -f ./logs/*.log
	MODEL=effect_constr;	 		NAME=; 		MAXTIME=50;	../../../utils/maketrace.sh "${CMD} ./model-$$MODEL$$NAME.lp" ./logs/$$MODEL$$NAME.log ; exit 0
	MODEL=state_constr; 	 	 	NAME=; 		MAXTIME=50;	../../../utils/maketrace.sh "${CMD} ./model-$$MODEL$$NAME.lp" ./logs/$$MODEL$$NAME.log ; exit 0
	MODEL=state_constr-continuous;  NAME=; 		MAXTIME=70;	../../../utils/maketrace.sh "${CMD} ./model-$$MODEL$$NAME.lp" ./logs/$$MODEL$$NAME.log ; exit 0

