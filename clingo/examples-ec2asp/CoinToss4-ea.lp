

#const maxtime=4.
%offset(1..1).



fluent(itsHeads).
fluent(heads).

event(toss).



initiates(toss,heads,Time) :- holdsAt(itsHeads,Time).

terminates(toss,heads,Time) :- not holdsAt(itsHeads,Time), time(Time).

releasedAt(itsHeads,Time) :- time(Time).

:- releasedAt(heads,0).

holdsAt(heads,0).

happens(toss,1).

happens(toss,2).

happens(toss,3).

holdsAt(itsHeads,0).

holdsAt(itsHeads,4).

#show.

#show holdsAt/2.
#show happens/2.
