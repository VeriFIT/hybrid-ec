
#const maxstep=7.
#const maxtime=22.

% ----- domain model -----

ffluent(water_left).
ffluent(water_right).
fluent(left_filling).
fluent(right_filling).  % replaced left_draining

event(start(left)).
event(start(right)).
event(switch_left).
event(switch_right).

initiates(start(left), left_filling, T) :- step(T).
initiates(start(right), right_filling, T) :- step(T).
releases(start(LR), water_left, T) :- step(T), event(start(LR)).
releases(start(LR), water_right, T) :- step(T), event(start(LR)).

initiates(switch_left, left_filling, T) :- step(T).
terminates(switch_left, right_filling, T) :- step(T).

terminates(switch_right, left_filling, T) :- step(T).
initiates(switch_right, right_filling, T) :- step(T).

trajectory(left_filling, T1, water_left, (( (1, (water_left, T1)), ), TotalFlow), T2) :-
    TotalFlow = 30 - 20, % in rate 30, out rate 20
    step(T1), step(T2).

trajectory(right_filling, T1, water_left, (( (1, (water_left, T1)), ), -TotalFlow), T2) :-
    TotalFlow = 20, % out rate 20
    step(T1), step(T2).

trajectory(right_filling, T1, water_right, (( (1, (water_right, T1)), ), TotalFlow), T2) :-
    TotalFlow = 30 - 20, % in rate 30, out rate 20
    step(T1), step(T2).

trajectory(left_filling, T1, water_right, (( (1, (water_right, T1)), ), -TotalFlow), T2) :-
    TotalFlow = 20, % out rate 20
    step(T1), step(T2).

minDuration(1).
&sum{ (time,S2); -(time,S1); -(timeDiff,S1,S2) } = 0 :- step(S1), step(S2), S1 <= S2.
comparison( ( (1, (timeDiff, T1, T)), ), MinDur) :- minDuration(MinDur), T1 <= T, step(T1), step(T).

% trigger exactly at 50 if the trajectory took at least the minimum duration
happens(switch_left, T) :-
    holdsAt(right_filling, T),
    sum(((1, (water_left, T)),), eq, 50), % target level
    minDuration(MinDur),
    % would be nicer if hidden behind holdsAt/3
    T1 < T,
    happens(E, T1),
    initiates(E, right_filling, T1),
    not stoppedIn(T1, right_filling, T),
    sum( ( (1, (timeDiff, T1, T)), ), geq, MinDur),
    step(T1), step(T).
% trigger exactly after the minimum duration if the level is below 50
happens(switch_left, T) :-
    holdsAt(right_filling, T),
    sum(((1, (water_left, T)),), leq, 50), % target level
    minDuration(MinDur),
    % would be nicer if hidden behind holdsAt/3
    T1 < T,
    happens(E, T1),
    initiates(E, right_filling, T1),
    not stoppedIn(T1, right_filling, T),
    sum( ( (1, (timeDiff, T1, T)), ), eq, MinDur),
    step(T1), step(T).

% trigger exactly at 50 if the trajectory took at least the minimum duration
happens(switch_right, T) :-
    holdsAt(left_filling, T),
    sum(((1, (water_right, T)),), eq, 50), % target level
    minDuration(MinDur),
    % would be nicer if hidden behind holdsAt/3
    T1 < T,
    happens(E, T1),
    initiates(E, left_filling, T1),
    not stoppedIn(T1, left_filling, T),
    sum( ( (1, (timeDiff, T1, T)), ), geq, MinDur),
    step(T1), step(T).
% trigger exactly after the minimum duration if the level is below 50
happens(switch_right, T) :-
    holdsAt(left_filling, T),
    sum(((1, (water_right, T)),), leq, 50), % target level
    minDuration(MinDur),
    % would be nicer if hidden behind holdsAt/3
    T1 < T,
    happens(E, T1),
    initiates(E, left_filling, T1),
    not stoppedIn(T1, left_filling, T),
    sum( ( (1, (timeDiff, T1, T)), ), eq, MinDur),
    step(T1), step(T).


% manual no_jump
comparison( ((1, (water_right, T)),), 50) :- T1 <= T, step(T1), step(T).
comparison( ((1, (water_left, T)),), 50) :- T1 <= T, step(T1), step(T).

% cannot step over 50, if the duration is already over the minimum
% switching to left
:-  % establish SStart
    happens(E, SStart),
    initiates(E, right_filling, SStart),
    not stoppedIn(SStart, right_filling, S),
    SStart < S,
    minDuration(MinDur),
    % trigger condition holds at S
    sum( ( (1, (timeDiff, SStart, S)), ), gt, MinDur),
    % no_jump constraint for S
    sum(((1, (water_left, S-1)),), gt, 50),
    sum(((1, (water_left, S)),), lt, 50).
% switching to right
:-  % establish SStart
    happens(E, SStart),
    initiates(E, left_filling, SStart),
    not stoppedIn(SStart, left_filling, S),
    SStart < S,
    minDuration(MinDur),
    % trigger condition holds at S
    sum( ( (1, (timeDiff, SStart, S)), ), gt, MinDur),
    % no_jump constraint for S
    sum(((1, (water_right, S-1)),), gt, 50),
    sum(((1, (water_right, S)),), lt, 50).


% cannot step over the minimum duration time, if the level is already below 50
% switching to left
:-  % establish SStart
    happens(E, SStart),
    initiates(E, right_filling, SStart),
    not stoppedIn(SStart, right_filling, S),
    SStart < S,
    minDuration(MinDur),
    % trigger condition holds at S
    sum(((1, (water_left, S)),), lt, 50),
    % no_jump constraint for S
    sum( ( (1, (timeDiff, SStart, S-1)), ), lt, MinDur),
    sum( ( (1, (timeDiff, SStart, S)), ), gt, MinDur).
% switching to right
:-  % establish SStart
    happens(E, SStart),
    initiates(E, left_filling, SStart),
    not stoppedIn(SStart, left_filling, S),
    SStart < S,
    minDuration(MinDur),
    % trigger condition holds at S
    sum(((1, (water_right, S)),), lt, 50),
    % no_jump constraint for S
    sum( ( (1, (timeDiff, SStart, S-1)), ), lt, MinDur),
    sum( ( (1, (timeDiff, SStart, S)), ), gt, MinDur).


% ----- narrative & queries  -----

initiallyP(water_left, 100).
initiallyP(water_right, 100).
initiallyN(F) :- not initiallyP(F), fluent(F).
:- releasedAt(F,0), fluent(F).  % nothing is initially released from inertia
:- releasedAt(F,0), ffluent(F).  % nothing is initially released from inertia

obs(happens, start(right),           10).

% for maxstep 6 without laststep
% happens(switch_left,25/2)
% happens(switch_left,145/8)
% happens(switch_left,161/8)
% happens(switch_left,177/8)
% happens(switch_right,65/4)
% happens(switch_right,153/8)
% happens(switch_right,169/8)
% happens(start(right),10)
