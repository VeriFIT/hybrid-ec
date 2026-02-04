

#const maxtime=3.
%offset(1..1).



fluent(loaded).
fluent(alive).
fluent(walking).

event(load).
event(shoot).



initiates(load,loaded,Time) :- time(Time).

terminates(shoot,alive,Time) :- holdsAt(loaded,Time).

terminates(shoot,walking,Time) :- terminates(shoot,alive,Time).

:- releasedAt(loaded,0).

:- releasedAt(alive,0).

:- releasedAt(walking,0).

holdsAt(alive,0).

holdsAt(loaded,0).

holdsAt(walking,0).

happens(shoot,1).

:- holdsAt(walking,2).

#show.

#show holdsAt/2.
#show happens/2.
