% Bank account example
% from T.Mueller, 2014 - Commonsense reasoning - an event calculus based approach
% based on page 70, section 4.2

% There are multiple bank accounts and money can be transferred between them. If the balance is below a specified minimum, then a monthly fee is charged.

%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

endOfMonth(5).
money(0..maxmoney). 

account(account1).
account(account2).

fluent(balance(A, M)) :- account(A), money(M).
fluent(minimumBalance(A, M)) :- account(A), money(M).
fluent(serviceFee(A, M)) :- account(A), money(M).
fluent(serviceFeeCharged(A)) :- account(A).

event(transfer(A1, A2, M)) :- account(A1), account(A2), money(M).
event(chargeServiceFee(A)) :- account(A).
event(monthlyReset(A)) :- account(A).


%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

%% basic operation of the account -- next 4 rules
%% if balance of account A1 is greater equal to the amount to be transfered,
%% and the amount is transfered from A1 to account A2,
%% then the balance of A1 decreses and of A2 increases
% new balance of A2 (receives payment)
initiates(transfer(A1, A2, TransM12), balance(A2, DstM2 + TransM12), T) :-
    holdsAt(balance(A2, DstM2), T),
    holdsAt(balance(A1, SrcM1), T),
    TransM12 > 0,
    SrcM1 >= TransM12,
    account(A1), account(A2), time(T), money(TransM12), money(DstM2), money(SrcM1).
% terminate old balance of A2
terminates(transfer(A1, A2, TransM12), balance(A2, DstM2), T) :-
    holdsAt(balance(A2, DstM2), T),
    holdsAt(balance(A1, SrcM1), T),
    TransM12 > 0,
    SrcM1 >= TransM12,
    account(A1), account(A2), time(T), money(TransM12), money(DstM2), money(SrcM1).
% new balance of A1 (sends payment)
initiates(transfer(A1, A2, TransM12), balance(A1, SrcM1 - TransM12), T) :-
    holdsAt(balance(A2, DstM2), T),
    holdsAt(balance(A1, SrcM1), T),
    TransM12 > 0,
    SrcM1 >= TransM12,
    account(A1), account(A2), time(T), money(TransM12), money(DstM2), money(SrcM1).
% terminate old balance of A1
terminates(transfer(A1, A2, TransM12), balance(A1, SrcM1), T) :-
    holdsAt(balance(A2, DstM2), T),
    holdsAt(balance(A1, SrcM1), T),
    TransM12 > 0,
    SrcM1 >= TransM12,
    account(A1), account(A2), time(T), money(TransM12), money(DstM2), money(SrcM1).


% when a service fee is charged, then a note is made to avoid repeated charging
initiates(chargeServiceFee(A), serviceFeeCharged(A), T) :-
    account(A), time(T).
% this is reset every month
happens(monthlyReset(A), T) :- endOfMonth(T),
    account(A), time(T).
terminates(monthlyReset(A), serviceFeeCharged(A), T):- 
    account(A), time(T).

% if a service fee is charged, then the balance of the account is decreased
% new balance
initiates(chargeServiceFee(A), balance(A, OldM - FeeM), T) :-
    holdsAt(balance(A, OldM), T),
    holdsAt(serviceFee(A, FeeM), T),
    account(A), time(T), money(OldM), money(FeeM).
% terminate old balance
terminates(chargeServiceFee(A), balance(A, OldM), T) :-
    holdsAt(balance(A, OldM), T),
    account(A), time(T), money(OldM).


%-------------------------------------------------------------------------------
% state constraints
%-------------------------------------------------------------------------------

% an account has a single unique balance at a time
M1=M2 :- holdsAt(balance(A, M1), T), holdsAt(balance(A, M2), T),
    account(A), time(T), money(M1), money(M2).

% an account can only have a single unique minimumBalance at a time % modif -- added
M1=M2 :- holdsAt(minimumBalance(A, M1), T), holdsAt(minimumBalance(A, M2), T),
    account(A), time(T), money(M1), money(M2).

% an account can only have a single unique serviceFee at a time % modif -- added
M1=M2 :- holdsAt(serviceFee(A, M1), T), holdsAt(serviceFee(A, M2), T),
    account(A), time(T), money(M1), money(M2).


%-------------------------------------------------------------------------------
% triggered events
%-------------------------------------------------------------------------------

% if the balance of an account falls below the minimum
% and a service fee has not yet been charged
% then a service fee will be charged
happens(chargeServiceFee(A), T) :-
    holdsAt(balance(A,AccM), T), holdsAt(minimumBalance(A, MinM), T), AccM < MinM,
    not holdsAt(serviceFeeCharged(A), T),
    account(A), time(T), money(AccM), money(MinM).



%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------


initiallyN(serviceFeeCharged(account1)).
initiallyN(serviceFeeCharged(account2)).
initiallyP(balance(account1, 10)).      
initiallyP(balance(account2, 10)).      
initiallyP(minimumBalance(account1, 5)).
initiallyP(minimumBalance(account2, 5)).
initiallyP(serviceFee(account1, 1)).    
initiallyP(serviceFee(account2, 1)).    
initiallyN(F) :- not initiallyP(F), fluent(F).
:- releasedAt(F,0), fluent(F). % nothing is initially released from CLoI

%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

happens(transfer(account1, account2, 2), 1).
happens(transfer(account1, account2, 4), 2).

% --> conclude that
%   a service fee is charged to account1 "in response to transfer at time 2" due to the balance being 4
%   the balance of account1 will be 3 at time 4
%   the service fee flag is reset at time 5
%   a service fee is again charged to account1 "in response to reset at time 5"
%   the balance of account1 will be 2 at time 7