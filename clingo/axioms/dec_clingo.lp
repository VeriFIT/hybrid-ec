% copied from http://decreasoner.sourceforge.net/csr/ecasp/dec.lp
% with minor adjustments

%#show.
%#show holdsAt/2.
%#show happens/2.
%#show releasedAt/2.

time(0..maxtime).
{holdsAt(F,T)} :- fluent(F), time(T).
{releasedAt(F,T)} :- fluent(F), time(T).

% DEC1
stoppedIn(T1,F,T2) :-
  happens(E,T),
  T1<T, T<T2,
  terminates(E,F,T),
  event(E), fluent(F), time(T), time(T1), time(T2).

% DEC2
startedIn(T1,F,T2) :-
  happens(E,T),
  T1<T, T<T2,
  initiates(E,F,T),
  event(E), fluent(F), time(T), time(T1), time(T2).

% DEC3
holdsAt(F2,T1+T2) :-
  happens(E,T1),
  initiates(E,F1,T1),
  0<T2,
  trajectory(F1,T1,F2,T2),
  not stoppedIn(T1,F1,T1+T2),
  event(E), fluent(F1), fluent(F2), time(T1), time(T1+T2).

% DEC4
holdsAt(F2,T1+T2) :-
  happens(E,T1),
  terminates(E,F1,T1),
  0<T2,
  antiTrajectory(F1,T1,F2,T2),
  not startedIn(T1,F1,T1+T2),
  event(E), fluent(F1), fluent(F2), time(T1), time(T1+T2).

initiated1(F,T) :-
  happens(E,T),
  initiates(E,F,T),
  event(E), fluent(F), time(T).
terminated1(F,T) :-
  happens(E,T),
  terminates(E,F,T),
  event(E), fluent(F), time(T).
released1(F,T) :-
  happens(E,T),
  releases(E,F,T),
  event(E), fluent(F), time(T).

% DEC5
holdsAt(F,T+1) :-
  holdsAt(F,T),
  not releasedAt(F,T+1),
  not terminated1(F,T),
  fluent(F), time(T), T<maxtime.

% DEC6
:- holdsAt(F,T+1),
  not holdsAt(F,T),
  not releasedAt(F,T+1),
  not initiated1(F,T),
  fluent(F), time(T), T<maxtime.

% DEC7
releasedAt(F,T+1) :-
  releasedAt(F,T),
  not initiated1(F,T),
  not terminated1(F,T),
  fluent(F), time(T), T<maxtime.

% DEC8
:- releasedAt(F,T+1),
  not releasedAt(F,T),
  not released1(F,T),
  fluent(F), time(T), T<maxtime.

% DEC9
holdsAt(F,T+1) :-
  happens(E,T),
  initiates(E,F,T),
  event(E), fluent(F), time(T), T<maxtime.

% DEC10
:- holdsAt(F,T+1),
  happens(E,T),
  terminates(E,F,T),
  event(E), fluent(F), time(T), T<maxtime.

% DEC11
releasedAt(F,T+1) :-
  happens(E,T),
  releases(E,F,T),
  event(E), fluent(F), time(T), T<maxtime.

% DEC12
:- releasedAt(F,T+1),
  happens(E,T),
  initiates(E,F,T),
  event(E), fluent(F), time(T), T<maxtime.
:- releasedAt(F,T+1),
  happens(E,T),
  terminates(E,F,T),
  event(E), fluent(F), time(T), T<maxtime.

%-------------------------------------------------------------------------------
% Defined
%-------------------------------------------------------------------------------

% define #const maxstep
% define #const maxtime

#defined time/1.

#defined fluent/1.

#defined happens/2.


#defined initiates/3.
#defined terminates/3.
#defined releases/3.
#defined trajectory/4.
#defined antiTrajectory/4.


%-------------------------------------------------------------------------------
% compatibility with BEC
%-------------------------------------------------------------------------------

% below was added to make these axioms compatible with the BEC narratives without a need to modify the narrative
:- holdsAt(F, 0), initiallyN(F), fluent(F).
holdsAt(F, 0) :- initiallyP(F), fluent(F).
#defined initiallyP/1.
#defined initiallyN/1.