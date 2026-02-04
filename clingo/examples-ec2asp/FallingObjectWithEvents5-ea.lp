

#const maxtime=5.
height(0..3).
%offset(1..3).

object(apple).
agent(nathan).


fluent(falling(Object)) :- object(Object).
fluent(height(Object,Height)) :- object(Object), height(Height).

event(drop(Agent,Object)) :- agent(Agent), object(Object).
event(hitGround(Object)) :- object(Object).



initiates(drop(Agent,Object),falling(Object),Time) :- agent(Agent), object(Object), time(Time).

releases(drop(Agent,Object),height(Object,Height),Time) :- height(Height), agent(Agent), object(Object), time(Time).

terminates(hitGround(Object),falling(Object),Time) :- object(Object), time(Time).

initiates(hitGround(Object),height(Object,Height),Time) :- holdsAt(height(Object,Height),Time).

happens(hitGround(Object),Time) :- holdsAt(falling(Object),Time), holdsAt(height(Object,0),Time).

happens(drop(nathan,apple),0).

:- holdsAt(height(Object,Height1),Time), holdsAt(height(Object,Height2),Time), Height1!=Height2.

trajectory(falling(Object),Time,height(Object,Height2),Time2) :- holdsAt(height(Object,Height1),Time), Height2=Height1-(Time2), time(Time2), time(Time+Time2).

:- holdsAt(falling(apple),0).

holdsAt(height(apple,3),0).

:- releasedAt(falling(Object),0).

:- releasedAt(height(Object,Height),0).

#show.

#show holdsAt/2.
#show happens/2.
