#const maxstep=3.
#const maxtime=3.



fluent(loaded).
fluent(alive).

event(load).
event(shoot).
event(sneeze).



initiates(load,loaded,S) :- step(S).

terminates(shoot,alive,S) :- holdsAt(loaded,S).

terminates(shoot,loaded,S) :- step(S).

obs(notReleasedAt,loaded,0).

obs(notReleasedAt,alive,0).

obs(holdsAt,alive,0).

obs(notHoldsAt,loaded,0).

obs(happens,load,0).

obs(happens,sneeze,1).

obs(happens,shoot,2).

negated_prints.

% --> conclude not alive after 2