% an adder machine (like a calculator with only the add operation)
% can be turned on and off
% while its on we can add(X) to the current result (functional fluent like result(X))
% there is no result while the machine is off
% the initial result is 0 when the machine is turned on
%
% --> example meant to test the encoding of functional fluents in clingo-lpx

#const maxstep=4.
#const maxtime=1000.

%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

% this is grounded (but only to as many values as there are input events...)
addDomain(X) :- happens(add(X), _).

event(add(X)) :- addDomain(X).
event(turn_on).
event(turn_off).

ffluent(result).
fluent(powered_on).

%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

% initiates(add(Add),  result(Res2), T) :- Add .>. 0, holdsAt(result(Res1), T), Res2 = Res1 + Add, step(T).
initiates(add(Add), result, ( (1, Add), (1, (result, T)) ), T) :-
    Add > 0,
    holdsAt(powered_on, T),
    % holdsAt(result, T),
    addDomain(Add), step(T).

% terminates(add(Add), result(OldRes), T) :- Add .>. 0, holdsAt(OldRes, T), step(T).
% this is meant to terminate the old functional value (break its inertia), this is already done by initiates/4


% initiates(turn_on, powered_on, T) :- -holdsAt(powered_on, T), step(T).
initiates(turn_on, powered_on, T) :-
    not holdsAt(powered_on, T),
    step(T).

% terminates(turn_off, powered_on, T) :- holdsAt(powered_on, T), step(T).
terminates(turn_off, powered_on, T) :-
    holdsAt(powered_on, T).


% initiates(turn_on, result(0), T) :- step(T).
initiates(turn_on, result, ( (0, (result, T)), ), T) :-
    Add > 0,
    not holdsAt(powered_on, T),
    %not holdsAt(result, T),
    addDomain(Add), step(T).

% terminates(turn_off, result(_), T) :- holdsAt(powered_on, T), step(T).
% HEC cannot terminate ffluents, instead initiate zero
initiates(turn_off, result, ( (0, (result, T)), ), T) :-
    Add > 0,
    holdsAt(powered_on, T),
    %holdsAt(result, T),
    addDomain(Add), step(T).


%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------

initiallyN(powered_on).
initiallyP(result, 0).  % HEC needs a value for ffluents at all times
:- releasedAt(F,0), fluent(F).  % nothing is initially released from inertia
:- releasedAt(F,0), ffluent(F). % nothing is initially released from inertia


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

obs(happens, turn_on,        5).
obs(happens, add(5),         10).
obs(happens, add(1000000),   20).
obs(happens, turn_off,       25).

% conclude that result will be 1000005 after time 20

% also show -holdsAt
negated_prints.