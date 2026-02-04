TIME=/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K"

AXIOMS=../axioms/dec_clingo.lp ../axioms/dec_clingo-show.lp

#-----------------------------------------------------------------------------------------------------------------------
# base

CMD=clingo -c maxtime=$$MAXTIME -c paramHeight=$$HEIGHT -n 0 ${AXIOMS} ./model.lp
run:
	MAXTIME=15; HEIGHT=20; ${TIME} ${CMD}


#-----------------------------------------------------------------------------------------------------------------------
# alternatives (fixes / improvements)

# demonstration of "missing"
run-miss:
	MAXTIME=12; HEIGHT=4; ${TIME} ${CMD} | ../utils/format-output/format-output-rework 2		# this is fine
	MAXTIME=11; HEIGHT=3; ${TIME} ${CMD} | ../utils/format-output/format-output-rework 2		# this misses due to 3 not being divisible by 2

#-----------------------------------------------------------------------------------------------------------------------
# log the execution

log:
	@mkdir -p ./logs ; rm -f ./logs/*.log
	MAXTIME=15;  HEIGHT=20;	 ../../../utils/maketrace.sh "${CMD}" ./logs/t$$MAXTIME-h$$HEIGHT.log ; exit 0
	MAXTIME=12;   HEIGHT=4;   ../../../utils/maketrace.sh "${CMD}" ./logs/miss-ok-t$$MAXTIME-h$$HEIGHT.log ; exit 0
	MAXTIME=11;   HEIGHT=3;   ../../../utils/maketrace.sh "${CMD}" ./logs/miss-miss-t$$MAXTIME-h$$HEIGHT.log ; exit 0