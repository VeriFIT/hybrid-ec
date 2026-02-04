% roll a dice with non-ground number of sides
% testing release from inertia for functional fluents

#const maxstep=2.
#const maxtime=100.

%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

event(roll).
event(land).

ffluent(sideUp).    % functional fluent

% the fluent can only have positive values
&sum{ (sideUp, T) } > 0 :- step(T).


%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

releases(roll, sideUp, T) :- step(T).

initiates(land, sideUp, ( (1, (sideUp, T)), ), T) :- step(T).


%-------------------------------------------------------------------------------
% state constraints
%-------------------------------------------------------------------------------

% the dice must always be exactly one of the sides up
% 1{holdsAt(sideUp, T)}1 :- step(T).

%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------

initiallyP(sideUp, 1).
%initiallyN(F) :- not initiallyP(F), fluent(F).
:- releasedAt(F,0), fluent(F).  % nothing is initially released from inertia
:- releasedAt(F,0), ffluent(F). % nothing is initially released from inertia


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

obs(happens, roll,      10).
obs(happens, land,      20). % could be triggered


% enforce a result that we are looking for
% (since its not really useful to list all non-ground fholdsAts...)
&sum{ (sideUp, maxstep) } = X :- goal(X).


% the goal is grounded but the point of the example is to show a non-ground non-deterministic fholdsAt during the roll
{goal(1;2;3;4;5;6)} = 1.
