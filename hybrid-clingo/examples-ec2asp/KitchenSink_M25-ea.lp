#const maxstep=2.
#const maxtime=25.

#const spillheight=15.
% offset(1..15).



fluent(filling).
ffluent(height).
fluent(spilling).

event(tapOn).
event(tapOff).
event(overflow).



initiates(tapOn,filling,S) :- step(S).

terminates(tapOff,filling,S) :- step(S).

releases(tapOn,height,S) :- step(S).

initiates(tapOff,height,((1,(height,S)),),S) :- step(S).

terminates(overflow,filling,S) :- step(S).

initiates(overflow,height,((1,(height,S)),),S) :- step(S).

initiates(overflow,spilling,S) :- step(S).

trajectory(filling,S,height,(((1,(height,S)),),1), S2) :- step(S), step(S2), step(S+S2).

% :- holdsAt(height(Height1),S), holdsAt(height(Height2),S), Height1!=Height2. % implicit

happens(overflow,S) :- sum(((1,(height,S)),), eq, spillheight), holdsAt(filling,S), step(S).
no_jump(height, S, spillheight) :- holdsAt(filling, S).

obs(height, 0, 0).

obs(notHoldsAt,filling,0).

obs(notHoldsAt,spilling,0).

obs(happens,tapOn,0).

obs(notReleasedAt,filling,0).

obs(notReleasedAt,height,0).

obs(notReleasedAt,spilling,0).

% --> conclude happens overflow at time "spillheight"