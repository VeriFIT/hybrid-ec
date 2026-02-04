#const maxstep=2.
#const maxtime=40.

% height(0..20).
% offset(1..20).



balloon(balloon).
agent(nathan).


fluent(heaterOn(Balloon)) :- balloon(Balloon).
ffluent(height(Balloon)) :- balloon(Balloon).

event(turnOnHeater(Agent,Balloon)) :- agent(Agent), balloon(Balloon).
event(turnOffHeater(Agent,Balloon)) :- agent(Agent), balloon(Balloon).



initiates(turnOnHeater(Agent,Balloon),heaterOn(Balloon),S) :- agent(Agent), balloon(Balloon), step(S).

terminates(turnOffHeater(Agent,Balloon),heaterOn(Balloon),S):- agent(Agent), balloon(Balloon), step(S).

obs(happens,turnOnHeater(nathan,balloon),0).

obs(happens,turnOffHeater(nathan,balloon),maxtime/2).

% implicit
%:- holdsAt(height(Balloon,Height1),S), holdsAt(height(Balloon,Height2),S), Height1!=Height2.

trajectory(heaterOn(Balloon),S,height(Balloon), (((1,(height(Balloon),S)),),1),S2) :- balloon(Balloon), step(S), step(S2), step(S+S2).

antiTrajectory(heaterOn(Balloon),S,height(Balloon), (((1,(height(Balloon),S)),),-1),S2) :- balloon(Balloon), step(S), step(S2), step(S+S2).

obs(height(balloon), 0, 0).

obs(notHoldsAt,heaterOn(balloon),0).

releasedAt(height(Balloon),S) :- balloon(Balloon), step(S).

obs(notReleasedAt,heaterOn(Balloon),0) :- balloon(Balloon).

% --> conclude height 20 at time 20, and height 0 at time 40
