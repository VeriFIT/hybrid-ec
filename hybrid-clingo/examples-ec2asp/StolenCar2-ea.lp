#const maxstep=2.   % can give more or less steps since events are abduced
#const maxtime=2.



fluent(carParked).

event(park).
event(steal).



initiates(park,carParked,S) :- step(S).

terminates(steal,carParked,S) :- step(S).



obs(notReleasedAt,carParked,0).

obs(notHoldsAt,carParked,0).

obs(happens,park,0).

obs(notHoldsAt,carParked, 2).

:- happens(steal, T), not holdsAt(carParked, T).
:- happens(park, T), holdsAt(carParked, T). % added to avoid abducing park at step 0
:- happens(steal,S1), S1<S2, happens(park,S2).

0 {happens(E, T)} 1 :- event(E), step(T).

negated_prints.

% --> abduce happens steal after park (time between 0 and 2), i.e., in step 1 (initial is step 0, end is step 2)
% the example gives no time information for step 1 --> solution says time(1)=2-e (happened "some" short time before time 2)