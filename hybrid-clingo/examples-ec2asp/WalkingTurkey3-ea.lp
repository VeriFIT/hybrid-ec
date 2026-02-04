#const maxstep=1.
#const maxtime=3.



fluent(loaded).
fluent(alive).
fluent(walking).

event(load).
event(shoot).



initiates(load,loaded,S) :- step(S).

terminates(shoot,alive,S) :- holdsAt(loaded,S).

%terminates(shoot,walking,S) :- terminates(shoot,alive,S).
terminates(E,walking,S) :- terminates(E,alive,S).   % this is even better

obs(notReleasedAt,loaded,0).

obs(notReleasedAt,alive,0).

obs(notReleasedAt,walking,0).

obs(holdsAt,alive,0).

obs(holdsAt,loaded,0).

obs(holdsAt,walking,0).

obs(happens,shoot,1).

obs(notHoldsAt,walking,2).

negated_prints.

% --> conclude not walking after time 1