
#const maxstep=5.
#const maxtime=1000.

% ----- domain model -----

event(turn_light_on).       % start the fading process
event(turn_light_off).
event(fade_in_end).         % stop fading in and start fading out (dimming)
event(fade_out_end).        % stop fading out (dimming) and starting fading in

fluent(light_on).
ffluent(brightness).        % range 0-10
fluent(fading_in).
fluent(fading_out).

terminates(fade_in_end, fading_in, T) :- step(T).
initiates(fade_in_end, fading_out, T) :- step(T).

terminates(fade_out_end, fading_out, T) :- step(T).
initiates(fade_out_end, fading_in, T) :- step(T).

initiates(turn_light_on,  light_on, T) :- step(T).
initiates(turn_light_on, fading_in, T) :- step(T).

releases(turn_light_on, brightness, T) :- step(T).

terminates(turn_light_off, light_on, T) :- step(T).
terminates(turn_light_off, fading_in, T) :- holdsAt(fading_in, T).
terminates(turn_light_off, fading_out, T) :- holdsAt(fading_out, T).

initiates(turn_light_off, brightness, ( (0,0), ), T) :- step(T).

trajectory(fading_in, T1, brightness, ( ( (1, (brightness, T1)), ), 1), T2) :- step(T1+T2), step(T1), step(T2).

trajectory(fading_out, T1, brightness, ( ( (1, (brightness, T1)), ), -1), T2) :- step(T1+T2), step(T1), step(T2).


happens(fade_in_end, T) :-
    holdsAt(fading_in, T),
    sum(( (1, (brightness, T)), ), eq, 10), 
    step(T).
    
no_jump(brightness, S, 10) :- holdsAt(fading_in, S), step(S).

    
happens(fade_out_end, T) :-
    holdsAt(fading_out, T),
    sum(( (1, (brightness, T)), ), eq, 0), 
    step(T).

no_jump(brightness, S, 0) :- holdsAt(fading_out, S),step(S).
    
% ----- narrative & queries  -----

initiallyP(brightness, 0).
initiallyN(F) :- not initiallyP(F), fluent(F).
:- releasedAt(F,0), fluent(F).  % nothing is initially released from inertia
:- releasedAt(F,0), ffluent(F). % nothing is initially released from inertia

obs(happens, turn_light_on,      10).
obs(happens, turn_light_off,     45).
