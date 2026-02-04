% version of HEC for happens3 -- events with duration

%-------------------------------------------------------------------------------
% DEC axioms -- slightly modified (changed fluent to dfluent in many rules, 
%               renamed maxtime to maxstep)
%-------------------------------------------------------------------------------

step(0..maxstep).
{    holdsAt(F,S) } :-  fluent(F), step(S).
{ releasedAt(F,S) } :-  fluent(F), step(S).
{ releasedAt(F,S) } :- ffluent(F), step(S). 
% we do not need any choice for the value of variables in linear equations,
% since their value is open by default

% HEC1 only for relational fluents (identical to DEC1)
stoppedIn(S1,F,S4) :-
  S1<S3, S2<S4,
  happens3(E,S2,S3),
  terminates(E,F,S2),
  step(S1), step(S4).

% HEC2 for both types of fluents (added a clause with initiates/4)
startedIn(S1,F,S4) :-
  S1<S3, S2<S4,
  happens3(E,S2,S3),
  initiates(E,F,S2),
  step(S1), step(S4).
startedIn(S1,F,S4) :-
  S1<S3, S2<S4,
  happens3(E,S2,S3),
  initiates(E,F,_,S2),
  step(S1), step(S4).

% In the following rules:
%   LE stands for Linear Expression
%   C for Coefficient
%   V for (rational) Variable

% HEC3 only for functional fluents (replaced DEC3)
&sum{ C*V : @member(LE) = (C,V); CC*(time,S2+S3); -CC*(time,S2) } = (F2,S2+S3) :-
  happens3(E,S1,S2),
  initiates(E,F1,S1),
  0<S3,
  trajectory(F1,S1,F2,(LE,CC),S3),
  not stoppedIn(S1,F1,S2+S3),
  step(S2+S3).

% HEC4 only for functional fluents (replaced DEC4)
&sum{ C*V : @member(LE) = (C,V); CC*(time,S2+S3); -CC*(time,S2) } = (F2,S2+S3) :-
  happens3(E,S1,S2),
  terminates(E,F1,S1),
  0<S3,
  antiTrajectory(F1,S1,F2,(LE,CC),S3),
  not startedIn(S1,F1,S2+S3),
  step(S2+S3).

% auxiliary 
initiated1(F,S2) :- happens3(E,S1,S2), initiates(E,F,S1).
initiated1(F,S2) :- happens3(E,S1,S2), initiates(E,F,_,S1).
terminated1(F,S2) :- happens3(E,S1,S2), terminates(E,F,S1).
released1(F,S2) :- happens3(E,S1,S2), releases(E,F,S1).
% no terminated1(F,S) for ffluent(F)
%      released1(F,S) is defined above given releases(E,F,S) for ffluent(F)

% HEC5 for both types of fluents (added a clause without holdsAt and initiated instead of terminated)
holdsAt(F,S+1) :-
  holdsAt(F,S),
  not releasedAt(F,S+1),
  not terminated1(F,S),
  step(S+1).
&sum{ (F,S1) } = (F,S1+1) :-
  not releasedAt(F,S1+1), 
  not initiated1(F,S1),
  ffluent(F), step(S1), step(S1+1).

% HEC6 only for relational fluents (identical to DEC6)
:- holdsAt(F,S+1),
  not holdsAt(F,S),
  not releasedAt(F,S+1),
  not initiated1(F,S),
  step(S), step(S+1).

% HEC7 for both types of fluents (identical to DEC7)
releasedAt(F,S+1) :-
  releasedAt(F,S),
  not initiated1(F,S),
  not terminated1(F,S),
  step(S+1).

% HEC8 for both types of fluents (identical to DEC7)
:- releasedAt(F,S+1),
  not releasedAt(F,S),
  not released1(F,S),
  step(S), step(S+1).

% HEC9 for both types of fluents (added a clause with a theory atom)
holdsAt(F,S2+1) :-
  happens3(E,S1,S2),
  initiates(E,F,S1),
  step(S2+1).
&sum{ C*V : @member(LE) = (C,V) } = (F,S2+1) :-
  happens3(E,S1,S2),
  initiates(E,F,LE,S1),
  step(S2).

% HEC10 only for relational fluents (identical to DEC10)
:- holdsAt(F,S2+1),
  happens3(E,S1,S2),
  terminates(E,F,S1),
  step(S2+1).

% HEC11 for both types of fluents (identical to DEC11)
releasedAt(F,S2+1) :-
  happens3(E,S1,S2),
  releases(E,F,S1),
  step(S2+1).

% HEC12 for both types of fluents (added a clause with initiates/4)
:- releasedAt(F,S2+1),
  happens3(E,S1,S2),
  initiates(E,F,S1),
  step(S2+1).
:- releasedAt(F,S2+1),
  happens3(E,S1,S2),
  terminates(E,F,S1),
  step(S2+1).
:- releasedAt(F,S2+1),
  happens3(E,S1,S2),
  initiates(E,F,_,S1),
  step(S2+1).

% HEC 13
:- obs(happens3, E, T1, T2), T1 > T2.
:- happens3(E,S1,S2), S1 > S2.

% HEC 14
happens(E,S) :- happens3(E,S,S).


%-------------------------------------------------------------------------------
% comparing functional values
%-------------------------------------------------------------------------------

% Note: needed only because clingo-lpx does not allow &sum in bodies

% comparison(LE,B): there is a comparison between linear equation LE and bound B
% sum(LE,lt/eq/gt,B): the sum of the members of LE is lt/eq/gt the bound B

{ sum(LE,(lt;eq;gt),B) } = 1 :- comparison(LE,B).
%
&sum{ C*V : @member(LE) = (C,V) } < B :- sum(LE,lt,B).
&sum{ C*V : @member(LE) = (C,V) } = B :- sum(LE,eq,B).
&sum{ C*V : @member(LE) = (C,V) } > B :- sum(LE,gt,B).
%
sum(LE,leq,B) :- sum(LE,lt,B).
sum(LE,leq,B) :- sum(LE,eq,B).
sum(LE,geq,B) :- sum(LE,eq,B).
sum(LE,geq,B) :- sum(LE,gt,B).


%-------------------------------------------------------------------------------
% mapping time to steps
%-------------------------------------------------------------------------------

% (time,S): the time of step S
&sum{ (time, 0) } >= 0.                                    % step 0 is at at time >= 0
&sum{ (time,S1+1) } > (time,S1) :- step(S1), step(S1+1).   % consecutive steps must have greater time
&sum{ (time,maxstep) } = maxtime :- not disable_laststep.  % maxstep is at time maxtime (unless disabled)

%
% Observations
%
:- obs(_,_,T), T < 0.
:- obs(_,_,T), T > maxtime, not disable_laststep. % last step can be disabled

% happens3
:- obs(_,_,T1,T2), T1 < 0.
:- obs(_,_,T1,T2), T2 > maxtime, not disable_laststep. % last step can be disabled

% mapEventObs(T,S): time T is mapped to state S
%mapEventObs(T,S) :- obs(happens3,E,T), step(S), &sum{ (time,S) } = T.          % clingcon
 mapEventObs(T,S) :- obs(happens3,E,T,_), step(S), sum(( (1,(time,S)), ),eq,T). % clingo-lpx
 mapEventObs(T,S) :- obs(happens3,E,_,T), step(S), sum(( (1,(time,S)), ),eq,T). % clingo-lpx
                  :- obs(happens3,E,_,T), not mapEventObs(T,_). 
                  :- obs(happens3,E,T,_), not mapEventObs(T,_). 
happens3(E,S1,S2) :- obs(happens3,E,T1,T2), mapEventObs(T1,S1), mapEventObs(T2,S2).

% mapObs(T,S): time point T corresponds to step S 
%% clingcon
%mapObs(T,S) :- obs(O,_,T), O != happens, step(S), S > 0, &sum{ (time,S-1) } < T, &sum{ (time,S) } >= T. % (time,S-1) < T <= (time,S)
%mapObs(T,S) :- obs(O,_,T), O != happens,          S = 0,                         &sum{ (time,S) } >= T. %              T <= (time,S)
% clingo-lpx
mapObs(T,S) :- obs(O,_,T), O != happens3, step(S), S > 0, sum(( (1,(time,S-1)), ),lt,T), sum(( (1,(time,S)), ),geq,T). % (time,S-1) < T <= (time,S)
mapObs(T,S) :- obs(O,_,T), O != happens3,          S = 0,                                sum(( (1,(time,S)), ),geq,T).           %              T <= (time,S)
:- obs(O,_,T), O != happens3, not mapObs(T, _).
%time_step_obs((holdsAt;notHoldsAt;releasedAt;notReleasedAt)). % filter out happens and functional values

% check Boolean fluents' observations
:- obs(      holdsAt,F,T),  fluent(F), mapObs(T,S), not holdsAt(F,S).
:- obs(   notHoldsAt,F,T),  fluent(F), mapObs(T,S),     holdsAt(F,S).
:- obs(   releasedAt,F,T),  fluent(F), mapObs(T,S), not releasedAt(F,S).
:- obs(   releasedAt,F,T), ffluent(F), mapObs(T,S), not releasedAt(F,S).
:- obs(notReleasedAt,F,T),  fluent(F), mapObs(T,S),     releasedAt(F,S).
:- obs(notReleasedAt,F,T), ffluent(F), mapObs(T,S),     releasedAt(F,S).

% check functional fluents' observations
% in_trajectory(F,S,C): F is at step S in a trajectory with time coefficient C
in_trajectory(F2,S2+S3,C) :- 
  happens3(E,S1,S2), initiates(E,F1,S1), 0<S3,
  trajectory(F1,S1,F2,(LE,C),S3), not stoppedIn(S1,F1,S2+S3), step(S2+S3).
%
in_trajectory(F2,S2+S3,C) :- 
  happens3(E,S1,S2), terminates(E,F1,S1), 0<S3,
  antiTrajectory(F1,S1,F2,(LE,C),S3), not startedIn(S1,F1,S2+S3), step(S2+S3).

&sum{ (F,S) }                   = V :- obs(F,V,T), ffluent(F), mapObs(T,S), not in_trajectory(F,S,_).
%&sum{ (F,S); C*T; -C*(time,S) } = V :- obs(F,V,T), ffluent(F), mapObs(T,S),     in_trajectory(F,S,C).  % clingcon
&sum{ (F,S); C*T; -C*(time,S) } = V :- obs(F,V,T), ffluent(F), mapObs(T,S),     in_trajectory(F,S,C).  % clingo-lpx 

% for clingo-lpx
comparison(( (1,(time,S)), ),T) :- obs(_,_,T), step(S).
comparison(( (1,(time,S)), ),T) :- obs(_,_,T,_), step(S).
comparison(( (1,(time,S)), ),T) :- obs(_,_,_,T), step(S).


% restrict free floating steps to avoid seeing useless steps:
:- step(S), not significant_step(S),                    % all steps must be significant
   not disable_significant_constr.                      % unless this constraint is disabled
significant_step(S) :- S=maxstep, not disable_laststep. % last step is significant (unless last step is disabled)
significant_step(S) :- happens3(E,S,_).                 % step is significant if an event happens
significant_step(S) :- happens3(E,_,S).                 % step is significant if an event happens


%-------------------------------------------------------------------------------
% helper predicates to make domain description easier/shorter
%-------------------------------------------------------------------------------

% designating significant values of continuous fluents or time so that we do not miss them
comparison(( (1,(F,S-1)), ),V) :- no_jump(F,S,V), step(S), step(S-1).
comparison(( (1,(F,S  )), ),V) :- no_jump(F,S,V), step(S), step(S-1). 
%
:- no_jump(F,S,V), sum(( (1,(F,S-1)), ),lt,V), sum(( (1,(F,S)), ),gt,V), step(S-1).
:- no_jump(F,S,V), sum(( (1,(F,S-1)), ),gt,V), sum(( (1,(F,S)), ),lt,V), step(S-1).


%-------------------------------------------------------------------------------
% Defined
%-------------------------------------------------------------------------------

% define #const maxstep
% define #const maxtime

#defined no_jump/3.
#defined obs/3.
#defined obs/4.

#defined initiallyP/1.
#defined initiallyN/1.
#defined initiallyP/2.

#defined ffluent/1.
#defined fluent/1.

#defined initiates/3.
#defined terminates/3.
#defined releases/3.
#defined trajectory/4.
#defined antiTrajectory/4.

#defined initiates/4.
#defined trajectory/5.
#defined antiTrajectory/5.

#defined checkStep/1.

#defined comparison/2.
#defined comparison/3.


%-------------------------------------------------------------------------------
% configuration of the axioms
%-------------------------------------------------------------------------------

#const disablelaststep=0.
#defined disable_laststep/0.
disable_laststep :- disablelaststep = 1.

#const disablesignificantconstr=0.
#defined disable_significant_constr/0.
disable_significant_constr :- disablesignificantconstr = 1.

#const debugprints=0.
#defined debug_prints/0.
debug_prints :- debugprints = 1.

#const negprints=0.
#defined negated_prints/0.
negated_prints :- negprints = 1.



%-------------------------------------------------------------------------------
% compatibility with BEC
%-------------------------------------------------------------------------------

% below was added to make these axioms compatible with the BEC narratives without a need to modify the narrative
:- holdsAt(F, 0), initiallyN(F), fluent(F).
holdsAt(F, 0) :- initiallyP(F), fluent(F).
&sum{ (F,0) } = V :- initiallyP(F, V), ffluent(F).
