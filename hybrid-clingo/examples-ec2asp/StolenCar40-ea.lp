#const maxstep=3.   % can give more or less steps since events are abduced
#const maxtime=40.



fluent(carParked).

event(park).
event(steal).



initiates(park,carParked,S) :- step(S).

terminates(steal,carParked,S) :- step(S).



obs(notReleasedAt,carParked,0).

obs(notHoldsAt,carParked,0).

obs(happens,park,20).

obs(notHoldsAt,carParked, maxtime).

:- happens(steal, T), not holdsAt(carParked, T).
:- happens(park, T), holdsAt(carParked, T). % added to avoid abducing park at step 0
:- happens(steal,S1), S1<S2, happens(park,S2).

0 {happens(E, T)} 1 :- event(E), step(T).

negated_prints.

% --> abduce happens steal after park (time between 20 and 40), i.e., in step 2 (initial is step 0, end is step 2)
% NOTE: the example gives no time information for step 1 --> clingo-lpx says time(2)=40-e (happened "some" short time before time 40)
% NOTE: clingcon needs --project for the same reason, otherwise would give many models of all possible placements