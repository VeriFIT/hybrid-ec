

#const maxtime=20.
height(-4..8).
%offset(1..8).

balloon(balloon).
agent(nathan).


fluent(heaterOn(Balloon)) :- balloon(Balloon).
fluent(height(Balloon,Height)) :- balloon(Balloon), height(Height).

event(turnOnHeater(Agent,Balloon)) :- agent(Agent), balloon(Balloon).
event(turnOffHeater(Agent,Balloon)) :- agent(Agent), balloon(Balloon).



initiates(turnOnHeater(Agent,Balloon),heaterOn(Balloon),Time) :- agent(Agent), balloon(Balloon), time(Time).

terminates(turnOffHeater(Agent,Balloon),heaterOn(Balloon),Time) :- agent(Agent), balloon(Balloon), time(Time).

happens(turnOnHeater(nathan,balloon),0).

happens(turnOffHeater(nathan,balloon),8).

:- holdsAt(height(Balloon,Height1),Time), holdsAt(height(Balloon,Height2),Time), Height1!=Height2.

trajectory(heaterOn(Balloon),Time,height(Balloon,Height2),Time2) :- holdsAt(height(Balloon,Height1),Time), Height2=Height1+(Time2), time(Time2), time(Time+Time2).

antiTrajectory(heaterOn(Balloon),Time,height(Balloon,Height2),Time2) :- holdsAt(height(Balloon,Height1),Time), Height2=Height1-(Time2), time(Time2), time(Time+Time2).

holdsAt(height(balloon,0),0).

:- holdsAt(heaterOn(balloon),0).

releasedAt(height(Balloon,Height),Time) :- time(Time),balloon(Balloon), height(Height).

:- releasedAt(heaterOn(Balloon),0).

#show.

#show holdsAt/2.
#show happens/2.
