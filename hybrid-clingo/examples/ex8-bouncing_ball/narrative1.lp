
#const maxstep=6.
#const maxtime=1000.

% ----- narrative & queries  -----

initiallyP(height, 10).
initiallyP(velocity, 0).
initiallyP(constant_fall_rate(1)).
initiallyP(velocity_loss_portion("0.75")).
initiallyP(constant_velocity_loss_bounce(1)).   % relevant for the fixzeno version

initiallyN(F) :- not initiallyP(F), fluent(F).
:- releasedAt(F,0), fluent(F).  % nothing is initially released from inertia
:- releasedAt(F,0), ffluent(F).  % nothing is initially released from inertia

obs(happens, drop,                           10).

% with zeno behavior
%?- happens(hit_ground,                  T).     % 20, 25, 26.25 (105/4), 26,5625 (425/16),...

obs(happens, catch,                          26).

% with flat loss of velocity on bounce
%?- happens(hit_ground,                  T).     % 20, 49/2, 201/8
%?- happens(stop_bouncing)               T).     % 201/8 (25,125)

% with minimum duration
%?- happens(hit_ground,                  T).     % 20, 25

