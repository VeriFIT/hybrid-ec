% Bank account example
% from T.Mueller, 2014 - Commonsense reasoning - an event calculus based approach
% based on page 70, section 4.2
% - modified by removing the service fee

% There are multiple bank accounts and money can be transferred between them.

#const maxstep=2.
#const maxtime=1000.

%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

% money(0..maxmoney). 

account(account1).
account(account2).

% fluent(balance(A, M)) :- account(A), money(M).
ffluent(balance(A)) :- account(A).

% event(transfer(A1, A2, M)) :- account(A1), account(A2), money(M).
event(transfer(A1, A2, M)) :- obs(happens,transfer(A1, A2, M), T), account(A1), account(A2).


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


%-------------------------------------------------------------------------------
% state constraints
%-------------------------------------------------------------------------------

%*
%% an account has a single unique balance at a time
%% an account can only have a single unique minimumBalance at a time
*%
% not needed -- functional fluents cannot have multiple values

%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------

initiallyP(balance(account1), 10).      
initiallyP(balance(account2), 10).      
:- releasedAt(F,0), fluent(F).  % nothing is initially released from inertia
:- releasedAt(F,0), ffluent(F). % nothing is initially released from inertia
initiallyN(F) :- not initiallyP(F), fluent(F).


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

obs(happens, transfer(account1, account2, 2), 10).
obs(happens, transfer(account1, account2, 4), 20).

% --> conclude that
%   the balance of account1 will be 4 after time 20
