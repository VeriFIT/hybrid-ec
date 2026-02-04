

#const maxtime=40.
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

happens(load,10).

happens(spin,20).

% added 2 rules below to avoid MANY models (all combinations of released value for time 22..30)
% (the non-deterministic effect is "decided" based on the value at time 21)
holdsAt(loaded, 22..30) :- holdsAt(loaded, 21).
:- holdsAt(loaded, 22..30), not holdsAt(loaded, 21).

happens(shoot,30).

#show.

#show holdsAt/2.
#show happens/2.
