% There are two objects. One is dropped from a height and is falling. The other is thrown up and is rising.
% The reasoning should find that the two object collide.
% After collision, both objects stop moving and remain stationary (for simplicity)

%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

agent(nathan1).
agent(nathan2).
object(apple).
object(ball).
fHeight(-paramHeight..paramHeight).

fluent(height(O, H)) :- object(O), fHeight(H).
fluent(falling(O)) :- object(O).
fluent(rising(O)) :- object(O).

event(drop(A, O)) :- agent(A), object(O).
event(throw(A, O)) :- agent(A), object(O).
event(collide(O1, O2)) :- object(O1), object(O2).

initHeight(paramHeight).
fGravity(2).


%-------------------------------------------------------------------------------
% domain description 
%-------------------------------------------------------------------------------

% [effect]
% if an agent drops an object, then the object will start falling and its height
% will be released from CLoI
initiates(drop(A,O), falling(O), T) :-  agent(A), object(O), time(T).

% similar for throw
initiates(throw(A,O), rising(O), T) :- agent(A), object(O), time(T).

% [effect + CLoI]
releases(drop(A,O), height(O,H), T) :- agent(A), object(O), fHeight(H), time(T).

% similar for throw
releases(throw(A,O), height(O,H), T) :- agent(A), object(O), fHeight(H), time(T).

% [triggered event]
% an object hits the ground when its falling and its height becomes zero
happens(collide(O1, O2), T) :-
    holdsAt(falling(O1), T),
    holdsAt(rising(O2), T),
    holdsAt(height(O1,H), T),
    holdsAt(height(O2,H), T),
    time(T).


% [effect]
terminates(collide(O1, O2), falling(O1), T) :- object(O1), object(O2), time(T).
terminates(collide(O1, O2), rising(O2), T) :- object(O1), object(O2), time(T).

% [effect + CLoI]
initiates(collide(O1,O2), height(O1,H), T) :- holdsAt(height(O1,H), T), time(T), fHeight(H), object(O1), object(O2).
initiates(collide(O1,O2), height(O2,H), T) :- holdsAt(height(O2,H), T), time(T), fHeight(H), object(O1), object(O2).

% [state constraint]
% an object only has one unique height at a time
H1 = H2 :- holdsAt(height(O,H1), T), holdsAt(height(O,H2), T),
    agent(A), object(O), fHeight(H1), fHeight(H2), time(T).

% motion of an object from the moment it is dropped to the moment it hits the ground
trajectory(falling(O), T1, height(O,H - (G)*(T2)), T2) :-
    0 < T2,
    holdsAt(height(O,H), T1),
    fGravity(G), object(O), fHeight(H), time(T1), time(T2), time(T1+T2).
trajectory(rising(O), T1, height(O,H + (G)*(T2)), T2) :-
    0 < T2,
    holdsAt(height(O,H), T1),
    fGravity(G), object(O), fHeight(H), time(T1), time(T2), time(T1+T2).


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

initiallyP(height(apple, H)) :- initHeight(H).  % apple's height initially is something
initiallyP(height(ball, 0)).                    % ball's height initially is something
initiallyN(falling(O)) :- object(O).
initiallyN(rising(O)) :- object(O).
:- releasedAt(F,0), fluent(F).  % nothing is initially released from inertia

happens(drop(nathan1,apple), 10).        % nathan1 drop the apple at time 10
happens(throw(nathan2,ball), 10).        % nathan2 throws the ball at time 10

% --> conclude ...