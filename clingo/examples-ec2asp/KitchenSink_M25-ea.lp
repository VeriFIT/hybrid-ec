

#const maxtime=25.
height(0..15).
%offset(1..15).



fluent(filling).
fluent(height(Height)) :- height(Height).
fluent(spilling).

event(tapOn).
event(tapOff).
event(overflow).



initiates(tapOn,filling,Time) :- time(Time).

terminates(tapOff,filling,Time) :- time(Time).

releases(tapOn,height(Height),Time) :- time(Time), height(Height).

initiates(tapOff,height(Height),Time) :- holdsAt(height(Height),Time).

terminates(overflow,filling,Time) :- time(Time).

initiates(overflow,height(Height),Time) :- holdsAt(height(Height),Time).

initiates(overflow,spilling,Time) :- time(Time).

trajectory(filling,Time,height(Height2),Time2) :- holdsAt(height(Height1),Time), Height2=Height1+(Time2), time(Time2), time(Time+Time2).

:- holdsAt(height(Height1),Time), holdsAt(height(Height2),Time), Height1!=Height2.

happens(overflow,Time) :- holdsAt(height(15),Time), holdsAt(filling,Time).

holdsAt(height(0),0).

:- holdsAt(filling,0).

:- holdsAt(spilling,0).

happens(tapOn,5).

:- releasedAt(filling,0).

:- releasedAt(height(Height),0).

:- releasedAt(spilling,0).

#show.

#show holdsAt/2.
#show happens/2.
