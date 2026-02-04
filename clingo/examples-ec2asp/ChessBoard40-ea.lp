

#const maxtime=40.
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

happens(throw,35).

holdsAt(itsWhite,0..34).    % extended these to prevent MANY models

holdsAt(itsBlack,0..34).

holdsAt(itsWhite,36..maxtime).

holdsAt(itsBlack,36..maxtime).

#show.

#show holdsAt/2.
#show happens/2.
