% Carrying a book example -- using release axioms and state constrains
% from T.Mueller, 2014 - Commonsense reasoning - an event calculus based approach
% based on page 96, section 6.3.1
%
% Demonstrates indirect effects using release axioms and state constrains
%
% Modified for clingo-lpx --> location is a continuous location instead of a room (non-ground value)

#const maxstep=5.
#const maxtime=1000.

%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

agent(nathan).
object(book).
%! could also use (below) to treat agents as objects
% object(A) :- agent(A).

in_locations(0).
in_locations(L) :- obs(happens, walk(_, L), _).  % grounding L only to actual occurrences

ffluent(location(A)) :- agent(A).
ffluent(location(O)) :- object(O).
fluent(holding(A, O)) :- agent(A), object(O).

event(walk(A, L)) :- agent(A), in_locations(L).
event(pickUp(A, O)) :- agent(A), object(O).
event(letGoOf(A, O)) :- agent(A), object(O).


%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

% if an agent walks from Location1 to Location2, then they will no longer be in Location1
% and will be in Location2
initiates(walk(A, L), location(A), ( (1, L), ), T) :- step(T), agent(A), in_locations(L).

% if an agent is in the same room as an object and picks it up, then they will be holding it
initiates(pickUp(A, O), holding(A, O), T) :-
    sum( ( (1, (location(A), T)), (1, (location(O), T)) ), eq, 0),
    agent(A), object(O), step(T).
comparison(( (1, (location(A), T)), (1, (location(O), T)) ), 0) :- happens(pickUp(A, O), T).

% if an agent is holding an object and lets go of it, then they will no longer be holding it
terminates(letGoOf(A, O), holding(A, O), T) :-
    holdsAt(holding(A, O), T),
    agent(A), object(O), step(T).

%! indirect effect
% if an agent lets go of an object while in a room, then the object will be
% in that room and will no longer be released from CLoI (caused by initiates)
initiates(letGoOf(A, O), location(O), ( (1, (location(A),T)), ), T) :- step(T), agent(A), object(O).


%-------------------------------------------------------------------------------
% state constraints
%-------------------------------------------------------------------------------

% % an object can only be in one room at a time (same for agents...)
% not needed -- only one value at a time

%! indirect effect
% when an agent is in a room and holding an object, then the object is in the same room
&sum{(location(A),T)} = (location(O),T) :-
    holdsAt(holding(A,O), T),
    agent(A), object(O), step(T).


%-------------------------------------------------------------------------------
% triggered events
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
% release from CLoI
%-------------------------------------------------------------------------------

%! indirect effect
% when an agent pickups an object, then the location of that object will
% be released from CLoI
releases(pickUp(A,O), location(O), T) :-
    agent(A), object(O), step(T).

%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------

initiallyP(location(nathan), 0).
initiallyP(location(book), 0).
initiallyN(F) :- not initiallyP(F), fluent(F).  % nathan is initially not holding the book and % nathan is initially not walking
:- releasedAt(F,0), fluent(F).  % nothing is initially released from inertia
:- releasedAt(F,0), ffluent(F). % nothing is initially released from inertia


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

obs(happens, pickUp(nathan, book),  10).

% nathan walks to position 100 with the book
obs(happens, walk(nathan, 100),     20).

obs(happens, letGoOf(nathan, book), 30).

% nathan walks to position 200 without the book
obs(happens, walk(nathan, 200),     40).

% --> conclude that the book is at position 100 after time 20 and stays there 
