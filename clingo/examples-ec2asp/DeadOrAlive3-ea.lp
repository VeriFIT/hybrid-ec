

#const maxtime=3.
%offset(1..1).



fluent(loaded).
fluent(alive).
fluent(dead).

event(load).
event(shoot).
event(sneeze).



initiates(load,loaded,Time) :- time(Time).

terminates(shoot,alive,Time) :- holdsAt(loaded,Time).

terminates(shoot,loaded,Time) :- time(Time).

:- holdsAt(dead,Time), holdsAt(alive,Time).

holdsAt(dead,Time) :- not holdsAt(alive,Time), time(Time).

releasedAt(dead,Time) :- time(Time).

:- releasedAt(loaded,0).

:- releasedAt(alive,0).

holdsAt(alive,0).

:- holdsAt(loaded,0).

happens(load,0).

happens(sneeze,1).

happens(shoot,2).

#show.

#show holdsAt/2.
#show happens/2.
