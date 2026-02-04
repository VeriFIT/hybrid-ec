% counter example from Mueller, E. T. Chapter 17 event calculus. In Handbook of Knowledge Representation 2008

#show.
#show holdsAt/2.
#show happens/2.

#const maxtime=5.

%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

event(increment).
event(reset).

domain(0..maxtime).
fluent(value(V)) :- domain(V).


%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

initiates(increment, value(V+1), T) :- holdsAt(value(V), T), time(T).
terminates(increment, value(V), T) :- holdsAt(value(V), T), time(T).

initiates(reset, value(0), T) :- time(T).
terminates(reset, value(V), T) :- V != 0, time(T), domain(V).


%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------

initiallyP(value(0)).
initiallyN(F) :- not initiallyP(F), fluent(F).
:- releasedAt(F,0), fluent(F).  % nothing is initially released from inertia


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

happens(increment,   1).
happens(increment,   2).
happens(reset,       3).
happens(increment,   4).
