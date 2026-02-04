
% ----- domain model -----

% fluents
ffluent(height).
ffluent(velocity).

fluent(falling).
fluent(rising).

fluent(constant_fall_rate(X)) :- initiallyP(constant_fall_rate(X)).         % simplified to a constant fall rate instead of accelerating over time
fluent(velocity_loss_portion(X)) :- initiallyP(velocity_loss_portion(X)).   % ball looses a portion of velocity on each bounce

% input events
event(drop).
event(catch).

% triggered events
event(fall_down).
event(hit_ground).
event(bounce_up).
event(reach_apex).
event(stop_bouncing).


% start by dropping the ball
releases(drop, height, T) :- step(T).
releases(drop, velocity, T) :- step(T).


% start by dropping the ball
initiates(fall_down, falling, T) :- step(T).

% stop falling when hitting the ground
terminates(hit_ground, falling, T) :- step(T).

% bounce back up
initiates(bounce_up, rising, T) :- step(T).

% stop rising when reaching the apex
terminates(reach_apex, rising, T) :- step(T).

% stop everything by catching the ball
terminates(catch, falling, T) :- step(T).
terminates(catch, rising, T) :- step(T).
initiates(catch, height, ( (1, (height, T)), ), T) :- step(T).
initiates(catch, velocity, ( (0, (velocity, T)), ), T) :- step(T).

% stop everything if the ball stops bouncing
initiates(stop_bouncing, height, ( (0, (height, T)), ), T) :- step(T).
initiates(stop_bouncing, velocity, ( (0, (velocity, T)), ), T) :- step(T).

% falling 
trajectory(falling, T1, height, (( (1, (height, T1)), ), -Rate), T2) :-
    initiallyP(constant_fall_rate(Rate)),
    step(T1), step(T2).
trajectory(falling, T1, velocity, (( (1, (velocity, T1)), ), Rate), T2) :-
    initiallyP(constant_fall_rate(Rate)),
    step(T1), step(T2).

% rising
trajectory(rising, T1, height, (( (1, (height, T1)), ), Rate), T2) :-
    initiallyP(constant_fall_rate(Rate)),
    step(T1), step(T2).
trajectory(rising, T1, velocity, (( ("0.25", (velocity, T1)), ), -Rate), T2) :-
    initiallyP(constant_fall_rate(Rate)),
    %initiallyP(velocity_loss_portion(LossPortion)), % ... 1 - LossPortion
    step(T1), step(T2).

happens(fall_down, T) :- happens(drop, T).

happens(hit_ground, T) :- 
    holdsAt(falling, T),
    sum(( (1, (height, T)), ), eq, 0).

happens(bounce_up, T) :- happens(hit_ground, T),
    holdsAt(falling, T),
    % only bounce if stop_bouncing did not happen
    not happens(stop_bouncing, T),
    step(T).

happens(stop_bouncing, T) :- happens(hit_ground, T),
    holdsAt(falling, T),
    sum(( (1, (velocity, T)), ), eq, 0).

happens(reach_apex, T) :-
    holdsAt(rising, T),
    sum(( (1, (velocity, T)), ), eq, 0).

happens(fall_down, T) :- happens(reach_apex, T).

no_jump(height, S, 0) :- holdsAt(falling, S), step(S).
no_jump(velocity, S, 0) :- holdsAt(rising, S), step(S).
