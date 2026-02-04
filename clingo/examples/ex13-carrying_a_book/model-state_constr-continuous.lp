% Carrying a book example -- using release axioms and state constrains
% from T.Mueller, 2014 - Commonsense reasoning - an event calculus based approach
% based on page 96, section 6.3.1
%
% Demonstrates indirect effects using release axioms and state constrains
%
% Modified for clingo-lpx --> location is a continuous location instead of a room (non-ground value)
% and walking is now a continuous process via a trajectory
% currently can only walk in one direction (only up/forward)

%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

agent(nathan).
object(book).
%! could also use (below) to treat agents as objects
% object(A) :- agent(A).

in_locations(0..30). % need a full range because of trajectory

fluent(location(A,L)) :- agent(A), in_locations(L).
fluent(location(O,L)) :- object(O), in_locations(L).
fluent(holding(A, O)) :- agent(A), object(O).
fluent(walkingTo(A,L)) :- agent(A), in_locations(L).

event(walk(A, L)) :- agent(A), in_locations(L).
event(arrive(A)) :- agent(A).
event(pickUp(A, O)) :- agent(A), object(O).
event(letGoOf(A, O)) :- agent(A), object(O).


%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

% if an agent starts walking from Location1 to Location2, then they will no longer be in Location1,
% will be walking, and their location will continuously approach Location2
initiates(walk(A, L), walkingTo(A,L), T) :- time(T), agent(A), in_locations(L).

releases(walk(A, L1), location(A, L2), T) :- agent(A), time(T), in_locations(L1), in_locations(L2).

terminates(arrive(A), walkingTo(A, L), T) :- agent(A), time(T), in_locations(L).

initiates(arrive(A), location(A, L), T) :- holdsAt(location(A, L), T), time(T), agent(A), in_locations(L).

trajectory(walkingTo(A,DstL), T1, location(A,OrigL + 10*T2), T2) :- holdsAt(location(A,OrigL), T1), in_locations(DstL), in_locations(OrigL), agent(A), time(T1), time(T2), time(T1+T2).

happens(arrive(A), T) :-
    holdsAt(walkingTo(A, L), T),
    holdsAt(location(A, L), T),
    time(T).

% if an agent is in the same room as an object and picks it up, then they will be holding it
initiates(pickUp(A, O), holding(A, O), T) :-
    holdsAt(location(A,L), T),
    holdsAt(location(O,L), T),
    agent(A), object(O), time(T).

%% % if an agent is holding an object and lets go of it, then they will no longer be holding it
terminates(letGoOf(A, O), holding(A, O), T) :-
    holdsAt(holding(A, O), T),
    agent(A), object(O), time(T).

%! indirect effect
% if an agent lets go of an object while in a room, then the object will be
% in that room and will no longer be released from CLoI (caused by initiates)
initiates(letGoOf(A, O), location(O, L), T) :- holdsAt(location(O,L), T), time(T), agent(A), object(O).


%-------------------------------------------------------------------------------
% state constraints
%-------------------------------------------------------------------------------

% % an object can only be in one room at a time (same for agents...)
H1 = H2 :- holdsAt(location(O,H1), T), holdsAt(location(O,H2), T),
    object(O), in_locations(H1), in_locations(H2), time(T).
H1 = H2 :- holdsAt(location(O,H1), T), holdsAt(location(O,H2), T),
    agent(O), in_locations(H1), in_locations(H2), time(T).
H1 = H2 :- holdsAt(walkingTo(O,H1), T), holdsAt(walkingTo(O,H2), T),
    agent(O), in_locations(H1), in_locations(H2), time(T).

%! indirect effect
% when an agent is in a room and holding an object, then the object is in the same room
holdsAt(location(O,L), T) :-
    holdsAt(holding(A,O), T),
    holdsAt(location(A,L), T),
    agent(A), object(O), time(T), in_locations(L).


%-------------------------------------------------------------------------------
% triggered events
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
% release from CLoI
%-------------------------------------------------------------------------------

%! indirect effect
% when an agent pickups an object, then the location of that object will
% be released from CLoI
releases(pickUp(A,O), location(O, L), T) :-
    in_locations(L), agent(A), object(O), time(T).

%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------

initiallyP(location(nathan, 0)).
initiallyP(location(book, 0)).
initiallyN(F) :- not initiallyP(F), fluent(F).  % % nathan is initially not holding the book
:- releasedAt(F,0), fluent(F).  % nothing is initially released from inertia


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

happens(pickUp(nathan, book), 10).

% nathan walks to position 10 with the book
happens(walk(nathan, 10), 20).

% check state of fluents at time 25
happens(check, 25).

% --> conclude arrive at 30

happens(letGoOf(nathan, book), 40).
 
% nathan walks to position 20 without the book
happens(walk(nathan, 20), 50).

% check state of fluents at time 55
happens(check, 55).

% --> conclude arrive at 60
