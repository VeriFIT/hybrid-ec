#const maxstep=2.
#const maxtime=40.



fluent(itsBlack).
fluent(itsWhite).
fluent(onBlack).
fluent(onWhite).

event(throw).



initiates(throw,onWhite,S) :- holdsAt(itsWhite,S).

initiates(throw,onBlack,S) :- holdsAt(itsBlack,S).

holdsAt(itsWhite,S)|holdsAt(itsBlack,S) :- step(S).

releasedAt(itsBlack,S) :- step(S).

releasedAt(itsWhite,S) :- step(S).

obs(notReleasedAt,onBlack,0).

obs(notReleasedAt,onWhite,0).

obs(notHoldsAt,onWhite,0).

obs(notHoldsAt,onBlack,0).

obs(happens,throw,35).

%obs(holdsAt,itsWhite,0).   % not needed: value at time zero is the same as at time 1
%
%obs(holdsAt,itsBlack,0).

obs(holdsAt,itsWhite,maxtime).

obs(holdsAt,itsBlack,maxtime).

% --> find 3 models, differ in state after time 1: onWhite or onBlack or both
