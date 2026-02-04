% toss a coin that will non-deterministically land as heads or tails
% testing release from inertia for discrete fluents

#const maxstep=2.
#const maxtime=1000.

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

releases(toss,  up(X), T) :- fluent(up(X)), step(T).

initiates(land, up(X), T) :- holdsAt(up(X), T), step(T).
terminates(land, up(X), T) :- not holdsAt(up(X), T), step(T), fluent(up(X)).


%-------------------------------------------------------------------------------
% state constraints
%-------------------------------------------------------------------------------

% the coin must always be exactly one of the sides up
1{holdsAt(up(X), T) : fluent(up(X))}1 :- step(T).

%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------

initiallyP(up(heads)).
initiallyN(F) :- not initiallyP(F), fluent(F).
:- releasedAt(F,0), fluent(F).  % nothing is initially released from inertia


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

obs(happens, toss,      10).
obs(happens, land,      20). % could be triggered

% --> two models heads or tails
