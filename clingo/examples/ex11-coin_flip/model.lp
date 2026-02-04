% toss a coin that will non-deterministically land as heads or tails
% testing release from inertia for discrete fluents

%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

event(toss).
event(land).

fluent(up(heads)).
fluent(up(tails)).


%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

releases(toss,  up(X), T) :- fluent(up(X)), time(T).

initiates(land, up(X), T) :- holdsAt(up(X), T), time(T).
terminates(land, up(X), T) :- not holdsAt(up(X), T), time(T), fluent(up(X)).


%-------------------------------------------------------------------------------
% state constraints
%-------------------------------------------------------------------------------

% the coin must always be exactly one of the sides up
1{holdsAt(up(X), T) : fluent(up(X))}1 :- time(T).

%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------

initiallyP(up(heads)).
initiallyN(F) :- not initiallyP(F), fluent(F).
:- releasedAt(F,0), fluent(F).  % nothing is initially released from inertia


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

happens(toss,      10).
happens(land,      11). % could be triggered

% --> two models heads or tails
