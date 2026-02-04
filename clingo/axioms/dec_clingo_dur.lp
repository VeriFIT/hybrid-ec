time(0..maxtime).
{holdsAt(F,T)} :- fluent(F), time(T).
{releasedAt(F,T)} :- fluent(F), time(T).

% DEC1
stoppedIn(T1,F,T4) :- happens3(E,T2,T3), T1<T3, T2<T4,
  terminates(E,F,T2), event(E), fluent(F), time(T),
  time(T1), time(T2), time(T3), time(T4).

% DEC2
startedIn(T1,F,T2) :- happens3(E,T2,T3), T1<T3, T2<T4,
  initiates(E,F,T2), event(E), fluent(F), time(T),
  time(T1), time(T2), time(T3), time(T4).

% DEC3
holdsAt(F2,T3) :- happens(E,T1,T2), initiates(E,F1,T1), T2<T3,
  trajectory(F1,T1,F2,T3), not stoppedIn(T1,F1,T3),
  event(E), fluent(F1), fluent(F2), time(T1), time(T2), time(T3).

% DEC4
holdsAt(F2,T3) :- happens(E,T1,T2), terminates(E,F1,T1), T2<T3,
  antiTrajectory(F1,T1,F2,T3), not startedIn(T1,F1,T3),
  event(E), fluent(F1), fluent(F2), time(T1), time(T2), time(T3).


initiated1(F,T2) :- happens3(E,T1,T2), initiates(E,F,T1), event(E),
  fluent(F), time(T1), time(T2).
terminated1(F,T2) :- happens3(E,T1,T2), terminates(E,F,T1), event(E),
  fluent(F), time(T1), time(T2).
released1(F,T2) :- happens3(E,T1,T2), releases(E,F,T1), event(E),
  fluent(F), time(T1), time(T2).

% DEC5
holdsAt(F,T+1) :- holdsAt(F,T), not releasedAt(F,T+1),
  not terminated1(F,T), fluent(F), time(T), T<maxstep.

% DEC6
:- holdsAt(F,T+1), not holdsAt(F,T), not releasedAt(F,T+1),
  not initiated1(F,T), fluent(F), time(T), T<maxstep.

% DEC7
releasedAt(F,T+1) :- releasedAt(F,T), not initiated1(F,T),
  not terminated1(F,T), fluent(F), time(T), T<maxstep.

% DEC8
:- releasedAt(F,T+1), not releasedAt(F,T), not released1(F,T),
  fluent(F), time(T), T<maxstep.

% DEC9
holdsAt(F,T2+1) :- happens3(E,T1,T2), initiates(E,F,T1), event(E),
  fluent(F), time(T1), time(T2), T2<maxstep.

% DEC10
:- holdsAt(F,T2+1), happens3(E,T1,T2), terminates(E,F,T1), event(E),
  fluent(F), time(T1), time(T2), T2<maxstep.

% DEC11
releasedAt(F,T2+1) :- happens3(E,T1,T2), releases(E,F,T1), event(E),
  fluent(F), time(T1), time(T2), T2<maxstep.

% DEC12
:- releasedAt(F,T2+1), happens3(E,T1,T2), initiates(E,F,T1),
  event(E), fluent(F), time(T1), time(T2), T2<maxstep.
:- releasedAt(F,T2+1), happens3(E,T1,T2), terminates(E,F,T1),
  event(E), fluent(F), time(T1), time(T2), T2<maxstep.

% DEC 17
:- happens3(E,T1,T2), T1 > T2.

% DEC 18
happens(E,T) :- happens3(E,T,T).

%-------------------------------------------------------------------------------
% Defined
%-------------------------------------------------------------------------------

% define #const maxstep
% define #const maxtime

#defined time/1.

#defined fluent/1.

#defined happens/2.
#defined happens/3.


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