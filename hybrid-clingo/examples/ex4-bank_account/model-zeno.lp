% Bank account example
% from T.Mueller, 2014 - Commonsense reasoning - an event calculus based approach
% based on page 70, section 4.2
% - modified by removing the service fee

% There are multiple bank accounts and money can be transferred between them.

#const maxstep=5.
#const maxtime=1000.

%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

endOfMonth(50).
% money(0..maxmoney). 

account(account1).
account(account2).

% fluent(balance(A, M)) :- account(A), money(M).
% fluent(minimumBalance(A, M)) :- account(A), money(M).
% fluent(serviceFee(A, M)) :- account(A), money(M).
ffluent(          balance(A)) :- account(A).
ffluent(   minimumBalance(A)) :- account(A).
ffluent(       serviceFee(A)) :- account(A).
fluent(serviceFeeCharged(A)) :- account(A).

% event(transfer(A1, A2, M)) :- account(A1), account(A2), money(M).
event(transfer(A1, A2, M)) :- obs(happens,transfer(A1, A2, M), T), account(A1), account(A2).
event(chargeServiceFee(A)) :- account(A).
event(monthlyReset(A)) :- account(A).


%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

%% basic operation of the account -- next 4 rules
%% if balance of account A1 is greater equal to the amount to be transfered,
%% and the amount is transfered from A1 to account A2,
%% then the balance of A1 decreses and of A2 increases

initiates(transfer(A1, A2, TransM12), balance(A2), ( (1, TransM12), (1, (balance(A2), T)) ), T) :-
    TransM12 > 0,
    % &sum{ (balance(A1),T) } >= TransM12, 
    sum( ( (1, (balance(A1), T)), ), geq, TransM12),
    event(transfer(A1, A2, TransM12)), account(A1), account(A2), step(T).

% needed for sum
comparison( ( (1, (balance(A1), T)), ), TransM12) :-
    event(transfer(A1, A2, TransM12)), account(A1), account(A2), step(T).

%*
%% terminate old balance of A2
*%
% not needed -- meant to terminate the old functional value (break its inertia), this is already done by initiates

%*
%% new balance of A1 (sends payment)
*%
initiates(transfer(A1, A2, TransM12), balance(A1), ( (-1, TransM12), (1, (balance(A1), T)) ), T) :-
    TransM12 > 0,
    % &sum{ (balance(A1),T) } >= TransM12, 
    sum( ( (1, (balance(A1), T)), ), geq, TransM12),
    event(transfer(A1, A2, TransM12)), account(A1), account(A2), step(T).

% already defined with the initiates above
%comparison((balance(A1),T), TransM12) :-  ...


%*
%% terminate old balance of A1
*%
% not needed -- is meant to terminate the old functional value (break its inertia), this is already done by initiates


% when a service fee is charged, then a note is made to avoid repeated charging
initiates(chargeServiceFee(A), serviceFeeCharged(A), T) :- account(A), step(T).

% this is reset every month
%happens(monthlyReset(A), T) :- &sum{(time, T)} = TriggerT, endOfMonth(TriggerT), account(A), step(T).
happens(monthlyReset(A), T) :- sum(( (1, (time, T)), ), eq, TriggerT), endOfMonth(TriggerT), account(A), step(T).

terminates(monthlyReset(A), serviceFeeCharged(A), T):- account(A), step(T).

% restrict that there must exist a state with its ftimeAtStep exactly equal to endOfMonth
% (by saying that there cannot be two subsequent states in which one is lt/gt and the next gt/lt, i.e. there is no state with exactly eq)
no_jump(time, T, EndT) :- endOfMonth(EndT), step(T).


% if a service fee is charged, then the balance of the account is decreased
% new balance
%*
%initiates(chargeServiceFee(A), balance(A, OldM - FeeM), T) :-
%    holdsAt(balance(A, OldM), T),
%    holdsAt(serviceFee(A, FeeM), T),
%    account(A), step(T), money(OldM), money(FeeM).
*%

initiates(chargeServiceFee(A), balance(A), ( (-1, (serviceFee(A), T)), (1, (balance(A), T)) ), T) :-
    step(T), account(A).

%*
%% terminate old balance
*%
% not needed -- is meant to terminate the old functional value (break its inertia), this is already done by initiates


%-------------------------------------------------------------------------------
% state constraints
%-------------------------------------------------------------------------------

%*
%% an account has a single unique balance at a time
%% an account can only have a single unique minimumBalance at a time
%% an account can only have a single unique serviceFee at a time
*%
% not needed -- functional fluents cannot have multiple values


%-------------------------------------------------------------------------------
% triggered events
%-------------------------------------------------------------------------------

% if the balance of an account falls below the minimum
% and a service fee has not yet been charged
% then a service fee will be charged


% time epsilon to trigger chargeServiceFee(A)
happens(chargeServiceFee(A), T) :-
    % &sum{ (balance(A),T-1) } < (minimumBalance(A),T-1), 
    sum( ( (1, (balance(A), T)), (-1, (minimumBalance(A), T)) ), lt, 0),
    not holdsAt(serviceFeeCharged(A), T),
    account(A), step(T).

comparison( ( (1, (balance(A), T)), (-1, (minimumBalance(A), T)) ), 0) :- account(A), step(T).

% manual no_jump -- cannot have two subsequent steps of trigger condition holding without triggering the event
:- sum( ( (1, (balance(A), T)), (-1, (minimumBalance(A), T)) ), lt, 0),
   not holdsAt(serviceFeeCharged(A), T),
   sum( ( (1, (balance(A), T+1)), (-1, (minimumBalance(A), T+1)) ), lt, 0),
   not holdsAt(serviceFeeCharged(A), T+1),
   not happens(chargeServiceFee(A), T+1),
   account(A), step(T), step(T+1).


%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------

initiallyP(balance(account1), 10).      
initiallyP(balance(account2), 10).      
initiallyP(minimumBalance(account1),  5).
initiallyP(minimumBalance(account2),  5).
initiallyP(    serviceFee(account1),  1).    
initiallyP(    serviceFee(account2),  1).    
initiallyN(F) :- not initiallyP(F), fluent(F).
:- releasedAt(F,0), fluent(F).  % nothing is initially released from inertia
:- releasedAt(F,0), ffluent(F). % nothing is initially released from inertia
initiallyN(F) :- not initiallyP(F), fluent(F).


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

obs(happens, transfer(account1, account2, 2), 10).
obs(happens, transfer(account1, account2, 4), 20).

% --> conclude that
%   a service fee is charged to account1 "in response to transfer at time 20" due to the balance being 4
%   the balance of account1 will be 3 at time 40
%   the service fee flag is reset at time 50
%   a service fee is again charged to account1 "in response to reset at time 50"
%   the balance of account1 will be 2 after 
