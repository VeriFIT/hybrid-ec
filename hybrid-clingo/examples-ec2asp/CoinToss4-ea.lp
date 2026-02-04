#const maxstep=3.
#const maxtime=4.



fluent(itsHeads).
fluent(heads).

event(toss).



initiates(toss,heads,S) :- holdsAt(itsHeads,S), step(S).

terminates(toss,heads,S) :- not holdsAt(itsHeads,S), step(S).

releasedAt(itsHeads,S) :- step(S).

obs(notReleasedAt,heads,0).

obs(holdsAt,heads,0).

obs(happens,toss,1).

obs(happens,toss,2).

obs(happens,toss,3).

%obs(holdsAt,itsHeads, 0).    % not needed: value at time zero is the same as at time 1

obs(holdsAt,itsHeads, 4).

% --> find 8 models (all combinations of coin toss results for 3 tosses)