

#const maxtime=4.
%offset(1..1).



fluent(loaded).
fluent(alive).

event(load).
event(shoot).
event(spin).



initiates(load,loaded,Time) :- time(Time).

terminates(shoot,alive,Time) :- holdsAt(loaded,Time).

releases(spin,loaded,Time) :- time(Time).

terminates(shoot,loaded,Time) :- time(Time).

:- releasedAt(loaded,0).

:- releasedAt(alive,0).

holdsAt(alive,0).

:- holdsAt(loaded,0).

happens(load,1).

happens(spin,2).

happens(shoot,3).

#show.

#show holdsAt/2.
#show happens/2.
