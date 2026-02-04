#const maxstep=2.
#const maxtime=2.



fluent(hasTicket).
fluent(onRed).
fluent(onYellow).

event(buy).
event(board).
event(boardRed).
event(boardYellow).



happens(boardRed,S)|happens(boardYellow,S) :- happens(board,S).

initiates(buy,hasTicket,S) :- step(S).

initiates(boardRed,onRed,S) :- holdsAt(hasTicket,S).

initiates(boardYellow,onYellow,S) :- holdsAt(hasTicket,S).

:- holdsAt(onRed,S), holdsAt(onYellow,S).

:- holdsAt(onYellow,S), holdsAt(onRed,S).

holdsAt(hasTicket,S) :- holdsAt(onRed,S).

holdsAt(hasTicket,S) :- holdsAt(onYellow,S).

obs(notReleasedAt,hasTicket,0).

obs(notReleasedAt,onRed,0).

obs(notReleasedAt,onYellow,0).

obs(holdsAt,onRed,2). % can remove this to show both models

obs(notHoldsAt,hasTicket,0).

obs(happens,buy,0).

obs(happens,board,1).

% --> abduce that board must have been boardRed
