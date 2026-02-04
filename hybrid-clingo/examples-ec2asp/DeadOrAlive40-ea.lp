#const maxstep=3.
#const maxtime=40.



fluent(loaded).
fluent(alive).
fluent(dead).

event(load).
event(shoot).
event(sneeze).



initiates(load,loaded,S) :- step(S).

terminates(shoot,alive,S) :- holdsAt(loaded,S), step(S).

terminates(shoot,loaded,S) :- step(S).

:- holdsAt(dead,S), holdsAt(alive,S).

holdsAt(dead,S) :- not holdsAt(alive,S), step(S).

releasedAt(dead,S) :- step(S).

obs(notReleasedAt,loaded,0).

obs(notReleasedAt,alive,0).

obs(holdsAt,alive,0).

obs(notHoldsAt,loaded,0).

obs(happens,load,10).

obs(happens,sneeze,20).

obs(happens,shoot,35).

negated_prints.

% --> conclude dead after time 35, and alive before that 