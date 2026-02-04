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
% fHeight(-paramHeight..paramHeight).

% fluent(height(O, H)) :- object(O), fHeight(H).
ffluent(height(O)) :- object(O).
fluent(falling(O)) :- object(O).

event(drop(A, O)) :- agent(A), object(O).
event(hitGround(O)) :- object(O).

%#const paramHeight=20.
initHeight(paramHeight).
fGravity(2).


%-------------------------------------------------------------------------------
% domain description 
%-------------------------------------------------------------------------------

% [effect]
% if an agent drops an object, then the object will start falling and its height
% will be released from CLoI
initiates(drop(A,O), falling(O), T) :- agent(A), object(O), step(T).

% [effect + CLoI]
releases(drop(A,O), height(O), T) :- agent(A), object(O), step(T).

% [triggered event]
% an object hits the ground when its falling and its height becomes zero
happens(hitGround(O), T) :-
    holdsAt(falling(O), T),
    % &sum{ (height(O), T) } = 0,
    sum(( (1, (height(O), T)), ), eq, 0), 
    step(T).


% capture when height(O) = 0
% restrict that there must exist a state where height is exactly equal to zero
% (by saying that there cannot be two subsequent states in which one is lt/gt and the next gt/lt, i.e. there is no state with exactly eq)
no_jump(height(O), S, 0) :- object(O), step(S), holdsAt(falling(O), S).

% [effect]
% if an object hits the ground, then it will stop falling
terminates(hitGround(O), falling(O), T) :- object(O), step(T).

% [effect + CLoI]
% if an object hits the ground then its height will no longer be released from CLoI
%initiates(hitGround(O), height(O), ( (0, (height(O), T)), ), T) :- step(T), object(O).
%! object teleports to its initial height when it hits the ground
%! this is for ease of dropping multiple times
initiates(hitGround(O), height(O), ( (1, (height(O), T)), (1, IH) ), T) :- step(T), object(O), initHeight(IH).

% [state constraint]
% an object only has one unique height at a time
% not needed -- only  one functional value at a time

% motion of an object from the moment it is dropped to the moment it hits the ground
trajectory(falling(O), T1, height(O), (( (1, (height(O), T1)), ), -fallRate), T2) :-
    object(O), step(T1), step(T2), step(T1+T2).


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

% initiallyP(height(apple, H)) :- initHeight(H).  % apples height initially is something
initiallyP(height(apple), H) :- initHeight(H).  % apples height initially is something
initiallyN(falling(apple)).
:- releasedAt(F,0), fluent(F).  % nothing is initially released from inertia
:- releasedAt(F,0), ffluent(F). % nothing is initially released from inertia


% allows us to generate event observations via execution parameters (for experiments)
obs(happens, drop(nathan,apple), T):- EventNumber = 1..eventsNumber, T = (1+(2*(EventNumber-1)))*precisionMultTime.

% supplied as input
#const maxEventsNumber=2.    
#const eventsNumber=2.      
#const precisionMultTime=1.
#const precisionMultVal=1. 

#show conf_fallRate(fallRate).
#show conf_height(paramHeight).
#show conf_maxtime(maxtime).

% auto-computed
#const paramHeight=100*precisionMultVal.
#const maxtime=2*(maxEventsNumber)*precisionMultTime.
#const fallRate=100*precisionMultVal.  
    % falls for 10 units regardless of precision
    % vanila clingo struggles with higher time precision than value precision since it leads to fall rate 0.1, 0.01,...



%%%%    T       V       R
%%%%    100     1       "-0.1"
%%%%    100     10      1
%%%%    100     100     10
%%%%    10      1       1
%%%%    10      10      10
%%%%    10      100     100
%%%%    1       1       10
%%%%    1       10      100
%%%%    1       100     1000
%%%
%%%% auto-computed
%%%#const paramHeight=100*precisionMultVal.                    % 100m * precision
%%%#const fallRate=(-10*precisionMultVal)/precisionMultTime.   % -10m/s ... 100(m^1)/s ... -0.1m/(s^-1) ... -10(m^1)/(s^-1) ...
%%%#const maxtime=20*(maxEventsNumber+1)*precisionMultTime.
