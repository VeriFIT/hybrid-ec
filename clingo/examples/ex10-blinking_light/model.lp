% ----- domain model -----

event(turn_light_on).
event(turn_light_off).

fluent(light_on).

initiates(turn_light_on,  light_on, T) :- time(T).
terminates(turn_light_off, light_on, T) :- time(T).


happens(turn_light_off, T) :- holdsAt(light_on, T), time(T).

happens(turn_light_on, T) :- not holdsAt(light_on, T), time(T),
    T > 1. % to avoid triggering before the first event



% ----- narrative & queries  -----
initiallyN(light_on).
:- releasedAt(F,0), fluent(F).  % nothing is initially released from inertia
:- releasedAt(F,0), ffluent(F). % nothing is initially released from inertia

happens(turn_light_on,    10).
