

#const maxtime=2.
%offset(1..1).



fluent(hasTicket).
fluent(onRed).
fluent(onYellow).

event(buy).
event(board).
event(boardRed).
event(boardYellow).



happens(boardRed,Time)|happens(boardYellow,Time) :- happens(board,Time).

initiates(buy,hasTicket,Time) :- time(Time).

initiates(boardRed,onRed,Time) :- holdsAt(hasTicket,Time).

initiates(boardYellow,onYellow,Time) :- holdsAt(hasTicket,Time).

:- holdsAt(onRed,Time), holdsAt(onYellow,Time).

:- holdsAt(onYellow,Time), holdsAt(onRed,Time).

holdsAt(hasTicket,Time) :- holdsAt(onRed,Time).

holdsAt(hasTicket,Time) :- holdsAt(onYellow,Time).

:- releasedAt(hasTicket,0).

:- releasedAt(onRed,0).

:- releasedAt(onYellow,0).

holdsAt(onRed,2).

:- holdsAt(hasTicket,0).

happens(buy,0).

happens(board,1).

#show.

#show holdsAt/2.
#show happens/2.
