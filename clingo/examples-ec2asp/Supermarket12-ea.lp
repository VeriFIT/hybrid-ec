

#const maxtime=12.
%offset(1..1).



fluent(forwards).
fluent(backwards).
fluent(spinning).

event(push).
event(pull).



initiates(push,forwards,Time) :- not happens(pull,Time), time(Time).

terminates(push,backwards,Time) :- not happens(pull,Time), time(Time).

initiates(pull,backwards,Time) :- not happens(push,Time), time(Time).

terminates(pull,forwards,Time) :- not happens(push,Time), time(Time).

initiates(pull,spinning,Time) :- happens(push,Time).

terminates(pull,forwards,Time) :- happens(push,Time).

terminates(pull,backwards,Time) :- happens(push,Time).

terminates(push,spinning,Time) :- not happens(pull,Time), time(Time).

terminates(pull,spinning,Time) :- not happens(push,Time), time(Time).

:- releasedAt(forwards,0).

:- releasedAt(backwards,0).

:- releasedAt(spinning,0).

:- holdsAt(forwards,0).

:- holdsAt(backwards,0).

:- holdsAt(spinning,0).

happens(push,5).

happens(pull,5).

happens(pull,10).

happens(push,10).

#show.

#show holdsAt/2.
#show happens/2.
