% Falling object example -- continuous change using trajectory
% from T.Mueller, 2014 - Commonsense reasoning - an event calculus based approach
% based on page 121, section 7.1.3
%
% An object is dropped, falls down via a constant speed, and then stops falling when it hits the floor.


%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

agent(nathan).
object(apple).
fHeight(-paramHeight..paramHeight).

fluent(height(O, H)) :- object(O), fHeight(H).
fluent(falling(O)) :- object(O).

event(drop(A, O)) :- agent(A), object(O).
event(hitGround(O)) :- object(O).

initHeight(paramHeight).
fGravity(2).


%-------------------------------------------------------------------------------
% domain description 
%-------------------------------------------------------------------------------

% [effect]
% if an agent drops an object, then the object will start falling and its height
% will be released from CLoI
initiates(drop(A,O), falling(O), T) :- 
    agent(A), object(O), time(T).
% [effect + CLoI]
releases(drop(A,O), height(O,H), T) :-
    agent(A), object(O), fHeight(H), time(T).

% [triggered event]
% an object hits the ground when its falling and its height becomes zero
happens(hitGround(O), T) :-
    holdsAt(falling(O), T),
    holdsAt(height(O,0), T),
    object(O), time(T).

% [effect]
% if an object hits the ground, then it will stop falling
terminates(hitGround(O), falling(O), T) :-
    object(O), time(T).
% [effect + CLoI]
% if an object hits the ground then its height will no longer be released from CLoI
initiates(hitGround(O), height(O, H), T) :-
    holdsAt(height(O, H), T),
    object(O), fHeight(H), time(T).

% [state constraint]
% an object only has one unique height at a time
H1 = H2 :- holdsAt(height(O,H1), T), holdsAt(height(O,H2), T),
    agent(A), object(O), fHeight(H1), fHeight(H2), time(T).

% motion of an object from the moment it is dropped to the moment it hits the ground
trajectory(falling(O), T1, height(O,H - (G)*(T2)), T2) :-
    0 < T2,
    holdsAt(height(O,H), T1),
    fGravity(G), object(O), fHeight(H), time(T1), time(T2), time(T1+T2).


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

initiallyP(height(apple, H)) :- initHeight(H).  % apples height initially is something
initiallyN(F) :- not initiallyP(F), fluent(F).  % apple is initially not falling
:- releasedAt(F,0), fluent(F). % nothing is initially released from CLoI

happens(drop(nathan,apple), 1).                 % nathan drop the apple at time 1


% --> conclude that the apple will hit the ground at time (initHeight/2) + 1