
#const maxstep=6.
#const maxtime=15.
disable_laststep.

% ----- domain model -----

event(turn_light_on).
event(turn_light_off).

fluent(light_on).

initiates(turn_light_on,  light_on, T) :- step(T).
terminates(turn_light_off, light_on, T) :- step(T).


happens(turn_light_off, T) :- holdsAt(light_on, T), step(T).

happens(turn_light_on, T) :- not holdsAt(light_on, T), step(T),
    T > 1. % to avoid triggering before the first event


% manual no_jump -- cannot have two subsequent steps of trigger condition holding without triggering the event
:- not holdsAt(light_on, T),
   not holdsAt(light_on, T+1),
   not happens(turn_light_on, T+1),
   step(T), step(T+1).
:- holdsAt(light_on, T),
   holdsAt(light_on, T+1),
   not happens(turn_light_off, T+1).


% ----- narrative & queries  -----
initiallyN(light_on).
:- releasedAt(F,0), fluent(F).  % nothing is initially released from inertia
:- releasedAt(F,0), ffluent(F). % nothing is initially released from inertia

obs(happens, turn_light_on,      10).

% clingo-lpx can automatically use 'e' (I assume 'epsilon') to represent an infinitely small time step
