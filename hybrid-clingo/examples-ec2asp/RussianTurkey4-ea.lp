#const maxstep=3.
#const maxtime=4.



fluent(loaded).
fluent(alive).

event(load).
event(shoot).
event(spin).



initiates(load,loaded,S) :- step(S).

terminates(shoot,alive,S) :- holdsAt(loaded,S).

releases(spin,loaded,S) :- step(S).

terminates(shoot,loaded,S) :- step(S).

obs(notReleasedAt,loaded,0).

obs(notReleasedAt,alive,0).

obs(holdsAt,alive,0).

obs(notHoldsAt,loaded,0).

obs(happens,load,1).

obs(happens,spin,2).

obs(happens,shoot,3).

negated_prints.

% --> find 2 models: one with alive after shoot and one with no alive after shoot