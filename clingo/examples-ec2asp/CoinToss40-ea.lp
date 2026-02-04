

#const maxtime=40.
%offset(1..1).



fluent(itsHeads).
fluent(heads).

event(toss).



initiates(toss,heads,Time) :- holdsAt(itsHeads,Time).

terminates(toss,heads,Time) :- not holdsAt(itsHeads,Time), time(Time).

releasedAt(itsHeads,Time) :- time(Time).

:- releasedAt(heads,0).

holdsAt(heads,0).

happens(toss,10).

happens(toss,20).

happens(toss,30).

holdsAt(itsHeads,0..9). % extended to avoid MANY models
holdsAt(itsHeads,11..19).
holdsAt(itsHeads,21..29).
holdsAt(itsHeads,31..maxtime).

#show.

#show holdsAt/2.
#show happens/2.
