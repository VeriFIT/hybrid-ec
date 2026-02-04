#const maxstep=2.
#const maxtime=25.

% height(0..18).
% offset(1..18).

object(apple).
agent(nathan).


fluent(falling(Object)) :- object(Object).
ffluent(height(Object)) :- object(Object).

event(drop(Agent,Object)) :- agent(Agent), object(Object).
event(hitGround(Object)) :- object(Object).



initiates(drop(Agent,Object),falling(Object),S) :- agent(Agent), object(Object), step(S).

terminates(hitGround(Object),falling(Object),S) :- object(Object), step(S).

happens(hitGround(Object),S) :- holdsAt(falling(Object),S), sum(( (1,(height(Object), S)), ), eq, 0).
no_jump(height(Object), S, 0) :- holdsAt(falling(Object), S).

obs(happens,drop(nathan,apple),0).

% not needed, implicit
% :- holdsAt(height(Object,Height1),S), holdsAt(height(Object,Height2),S), Height1!=Height2.

trajectory(falling(Object),S,height(Object), (((1,(height(Object),S)),),-1),S2) :- object(Object), step(S), step(S2), step(S+S2).

antiTrajectory(falling(Object),S,height(Object), (((1,(height(Object),S)),),0),S2) :- object(Object), step(S), step(S2), step(S+S2).


obs(notHoldsAt,falling(apple),0).

%holdsAt(height(apple,18),0).
obs(height(apple), 18, 0).

obs(notReleasedAt,falling(Object),0) :- object(Object).

obs(releasedAt,height(Object),0) :- object(Object).

% --> conclude hit ground at time 18, and hight zero after
