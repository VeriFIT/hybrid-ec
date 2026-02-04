
% ----- domain model -----

event(turn_light_on).       % start the fading process
event(turn_light_off).
event(fade_in_end).         % stop fading in and start fading out (dimming)
event(fade_out_end).        % stop fading out (dimming) and starting fading in

domain(0..10).              % range 0-10
fluent(light_on).
fluent(brightness(X)) :- domain(X).        
fluent(fading_in).
fluent(fading_out).

H1 = H2 :- holdsAt(brightness(H1), T), holdsAt(brightness(H2), T),
    domain(H1), domain(H2), time(T).

terminates(fade_in_end, fading_in, T) :- time(T).
initiates(fade_in_end, fading_out, T) :- time(T).

terminates(fade_out_end, fading_out, T) :- time(T).
initiates(fade_out_end, fading_in, T) :- time(T).

initiates(turn_light_on,  light_on, T) :- time(T).
initiates(turn_light_on, fading_in, T) :- time(T).

releases(turn_light_on, brightness(X), T) :- domain(X), time(T).

terminates(turn_light_off, light_on, T) :- time(T).
terminates(turn_light_off, fading_in, T) :- holdsAt(fading_in, T).
terminates(turn_light_off, fading_out, T) :- holdsAt(fading_out, T).

initiates(turn_light_off, brightness(0), T) :- time(T).

trajectory(fading_in, T1, brightness(X + T2), T2) :- holdsAt(brightness(X), T1), time(T1+T2), time(T1), time(T2).

trajectory(fading_out, T1, brightness(X - T2), T2) :- holdsAt(brightness(X), T1), time(T1+T2), time(T1), time(T2).


happens(fade_in_end, T) :-
    holdsAt(fading_in, T),
    holdsAt(brightness(10), T),
    time(T).
    
happens(fade_out_end, T) :-
    holdsAt(fading_out, T),
    holdsAt(brightness(0), T),
    time(T).
    
% ----- narrative & queries  -----

initiallyP(brightness(0)).
initiallyN(F) :- not initiallyP(F), fluent(F).
:- releasedAt(F,0), fluent(F).  % nothing is initially released from inertia

happens(turn_light_on,      10).
happens(turn_light_off,     45).
