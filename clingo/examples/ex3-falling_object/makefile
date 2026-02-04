TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"

AXIOMS=../axioms/dec_clingo.lp ../axioms/dec_clingo-show.lp

#-----------------------------------------------------------------------------------------------------------------------
# base

CMD=clingo -c maxtime=$$MAXTIME -c paramHeight=$$HEIGHT -n 0 ${AXIOMS} ./model.lp
run:
	MAXTIME=15; HEIGHT=20; ${TIME} ${CMD}


#-----------------------------------------------------------------------------------------------------------------------
# alternatives (fixes / improvements)

# demonstration of "missing the ground"
run-miss_ground:
	MAXTIME=5; HEIGHT=4; ${TIME} ${CMD} # this is fine
	MAXTIME=4; HEIGHT=3; ${TIME} ${CMD} # this misses due to 3 not being divisible by 2

#-----------------------------------------------------------------------------------------------------------------------
# log the execution

log:
	@mkdir -p ./logs ; rm -f ./logs/*.log
	MAXTIME=15;  HEIGHT=20;	 ../../../utils/maketrace.sh "${CMD}" ./logs/t$$MAXTIME-h$$HEIGHT.log ; exit 0
	MAXTIME=5;   HEIGHT=4;   ../../../utils/maketrace.sh "${CMD}" ./logs/miss_ground-ok-t$$MAXTIME-h$$HEIGHT.log ; exit 0
	MAXTIME=4;   HEIGHT=3;   ../../../utils/maketrace.sh "${CMD}" ./logs/miss_ground-miss-t$$MAXTIME-h$$HEIGHT.log ; exit 0