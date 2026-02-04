% exploring ways to query fluents values

% #const maxstep=6.
% #const maxtime=1000.


%-------------------------------------------------------------------------------
% additional "queries"
%-------------------------------------------------------------------------------

% if we wanted to check the height at time 15
% could add an event at time 15
event(checkAtT).
obs(happens, checkAtT, 15).               


% if we wanted to see the time at which the height is 2
% could add a triggered event
event(checkAtH).
happens(checkAtH, T) :- sum(( (1, (height(O), T)), ), eq, 2), object(O), step(T).
no_jump(height(O), S, 2) :- holdsAt(falling(O), S).


%% if we wanted to see the time at which the object was falling for 2 time units
checkDuration(2).
&sum{ (time,S2); -(time,S1); -(timeDiff,S1,S2) } = 0 :- step(S1), step(S2), S1 <= S2.
comparison( ( (1, (timeDiff, T1, T)), ), Dur) :- checkDuration(Dur), T1 <= T, step(T1), step(T).
event(checkAtDur).
happens(checkAtDur, T) :-
    holdsAt(falling(O), T),
    % would be nicer if hidden behind holdsAt/3
    T1 < T,
    happens(E, T1),
    initiates(E, falling(O), T1),
    not stoppedIn(T1, falling(O), T),
    checkDuration(Dur),
    sum(( (1, (timeDiff, T1, T)), ), eq, Dur).

:-  % establish SStart
    happens(E, SStart),
    initiates(E, falling(O), SStart),
    not stoppedIn(SStart, falling(O), S),
    SStart < S,
    checkDuration(Dur),
    % cannot step over SStart + Dur
    sum(( (1, (timeDiff, SStart, S-1)), ), lt, Dur),
    sum(( (1, (timeDiff, SStart, S)), ), gt, Dur).
