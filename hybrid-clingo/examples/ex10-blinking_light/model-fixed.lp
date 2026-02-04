
#const maxstep=5.
#const maxtime=15.

% ----- domain model -----

event(turn_light_on).
event(turn_light_off).

fluent(light_on).

initiates(turn_light_on,  light_on, T) :- step(T).
terminates(turn_light_off, light_on, T) :- step(T).

% time epsilon to trigger on/off(A)
epsilon("1.1").
&sum{ (time,S2); -(time,S1); -(timeDiff,S1,S2) } = 0 :- step(S1), step(S2), S1 <= S2.

happens(turn_light_off, T) :- holdsAt(light_on, T),
    % would be nicer if hidden behind holdsAt/3
    T1 < T,
    happens(E, T1),
    initiates(E, light_on, T1),
    not stoppedIn(T1, light_on, T),
    epsilon(EPS),
    sum( ( (1, (timeDiff, T1, T)), ), eq, EPS),
    step(T).

happens(turn_light_on, T) :- not holdsAt(light_on, T), step(T),
    % would be nicer if hidden behind holdsAt/3
    T1 < T,
    happens(E, T1),
    terminates(E, light_on, T1),
    not startedIn(T1, light_on, T),
    epsilon(EPS),
    sum( ( (1, (timeDiff, T1, T)), ), eq, EPS),
        %sum(time(T), -time(T1), eq, EPS),
    T > 1, step(T).


comparison( ( (1, (timeDiff, T1, T)), ), EPS) :- epsilon(EPS), T1 <= T, step(T1), step(T).
    %comparison(time(T), -time(T1), EPS) :- epsilon(EPS), T1 < T, step(T1), step(T).


% different no_jump -- not dont step over a particular value of continuous change, but force an event at some T1 + epsilon
:-  % establish SStart
    happens(E, SStart),
    terminates(E, light_on, SStart),
    not startedIn(SStart, light_on, S),
    SStart < S,
    epsilon(EPS),
    % trigger condition holds at S
    not holdsAt(light_on, S),
    % no_jump constraint for S
    sum(( (1, (timeDiff, SStart, S-1)), ), lt, EPS),
    sum(( (1, (timeDiff, SStart, S)), ), gt, EPS).
:-  % establish SStart
    happens(E, SStart),
    initiates(E, light_on, SStart),
    not stoppedIn(SStart, light_on, S),
    SStart < S,
    epsilon(EPS),
    % trigger condition holds at S
    holdsAt(light_on, S),
    % no_jump constraint for S
    sum(( (1, (timeDiff, SStart, S-1)), ), lt, EPS),
    sum(( (1, (timeDiff, SStart, S)), ), gt, EPS).


% ----- narrative & queries  -----
initiallyN(light_on).
:- releasedAt(F,0), fluent(F).  % nothing is initially released from inertia
:- releasedAt(F,0), ffluent(F). % nothing is initially released from inertia

obs(happens, turn_light_on,      10).
