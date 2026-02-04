

#const maxtime=2.
%offset(1..1).



fluent(itsBlack).
fluent(itsWhite).
fluent(onBlack).
fluent(onWhite).

event(throw).



initiates(throw,onWhite,Time) :- holdsAt(itsWhite,Time).

initiates(throw,onBlack,Time) :- holdsAt(itsBlack,Time).

holdsAt(itsWhite,Time)|holdsAt(itsBlack,Time) :- time(Time).

releasedAt(itsBlack,Time) :- time(Time).

releasedAt(itsWhite,Time) :- time(Time).

:- releasedAt(onBlack,0).

:- releasedAt(onWhite,0).

:- holdsAt(onWhite,0).

:- holdsAt(onBlack,0).

happens(throw,1).

holdsAt(itsWhite,0).

holdsAt(itsBlack,0).

holdsAt(itsWhite,2).

holdsAt(itsBlack,2).

#show.

#show holdsAt/2.
#show happens/2.
