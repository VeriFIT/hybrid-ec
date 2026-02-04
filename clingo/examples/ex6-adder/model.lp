% an adder machine (like a calculator with only the add operation)
% can be turned on and off
% while its on we can add(X) to the current result (functional fluent like result(X))
% there is no result while the machine is off
% the initial result is 0 when the machine is turned on
%
% --> example meant to test the encoding of functional fluents in clingo-lpx

%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

% this is grounded (but only to as many values as there are input events...)
addDomain(X) :- happens(add(X), _).

event(add(X)) :- addDomain(X).
event(turn_on).
event(turn_off).

domain(0..120).
fluent(result(X)) :- domain(X).
fluent(powered_on).


R1 = R2 :- holdsAt(result(R1), T), holdsAt(result(R2), T),
    domain(R1), domain(R2), time(T).

%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

initiates(add(Add),  result(Res2), T) :- Add > 0, holdsAt(result(Res1), T), Res2 = Res1 + Add,
    time(T), addDomain(Add), domain(Res2), domain(Res1).

terminates(add(Add), result(OldRes), T) :- Add > 0, holdsAt(result(OldRes), T),
    time(T), addDomain(Add), domain(OldRes).

initiates(turn_on, powered_on, T) :- not holdsAt(powered_on, T),
    time(T).

terminates(turn_off, powered_on, T) :- holdsAt(powered_on, T),
    time(T).


initiates(turn_on, result(0), T) :- time(T).

terminates(turn_off, result(Res), T) :- holdsAt(powered_on, T),
    time(T), domain(Res).


%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------

initiallyN(powered_on).
initiallyN(result(X)) :- fluent(result(X)).
:- releasedAt(F,0), fluent(F).  % nothing is initially released from inertia


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

happens(turn_on,        5).
happens(add(5),         10).
happens(add(100),       20).
happens(turn_off,       25).

% conclude that result will be 105 after time 20
