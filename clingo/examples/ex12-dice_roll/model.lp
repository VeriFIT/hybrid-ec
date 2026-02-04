% roll a dice with non-ground number of sides
% testing release from inertia for functional fluents

%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

event(roll).
event(land).

domain(1..6).
fluent(sideUp(X)) :- domain(X).


%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

releases(roll, sideUp(X), T) :- domain(X), time(T).

initiates(land, sideUp(X), T) :- X = 5, time(T).


%-------------------------------------------------------------------------------
% state constraints
%-------------------------------------------------------------------------------

% the dice must always be exactly one of the sides up
1{holdsAt(sideUp(X), T) : fluent(sideUp(X))}1 :- time(T).

%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------

initiallyP(sideUp(1)).
initiallyN(F) :- not initiallyP(F), fluent(F).
:- releasedAt(F,0), fluent(F).  % nothing is initially released from inertia


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

happens(roll,      10).
happens(land,      11). %  could be triggered
