

#const maxtime=40.
%offset(1..1).



fluent(loaded).
fluent(alive).

event(load).
event(shoot).
event(sneeze).



initiates(load,loaded,Time) :- time(Time).

terminates(shoot,alive,Time) :- holdsAt(loaded,Time).

terminates(shoot,loaded,Time) :- time(Time).

:- releasedAt(loaded,0).

:- releasedAt(alive,0).

holdsAt(alive,0).

:- holdsAt(loaded,0).

happens(load,10).

happens(sneeze,20).

happens(shoot,35).

#show.

#show holdsAt/2.
#show happens/2.
