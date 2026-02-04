TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"

AXIOMS=../axioms/dec_clingo.lp ../axioms/dec_clingo-show.lp

#-----------------------------------------------------------------------------------------------------------------------
# base

CMD=clingo -c maxtime=$$MAXTIME -n 0 ${AXIOMS} ./model.lp
run:
	MAXTIME=50; ${TIME} ${CMD}


#-----------------------------------------------------------------------------------------------------------------------
# alternatives (fixes / improvements)


#-----------------------------------------------------------------------------------------------------------------------
# log the execution

log:
	@mkdir -p ./logs ; rm -f ./logs/*.log
	MAXTIME=50;   ../../../utils/maketrace.sh "${CMD}" ./logs/t$$MAXTIME.log ; exit 0
