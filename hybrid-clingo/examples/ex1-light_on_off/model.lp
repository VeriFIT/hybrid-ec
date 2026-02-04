% from T.Mueller, 2014 - Commonsense reasoning - an event calculus based approach
% light can be turned on and off

#const maxstep=2.
#const maxtime=1000.


%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

event(turn_light_on).
event(turn_light_off).

fluent(light_on).


%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

initiates(turn_light_on,  light_on, T) :- step(T).

terminates(turn_light_off, light_on, T) :- step(T).


%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------

initiallyN(light_on).
:- releasedAt(F,0), fluent(F).  % nothing is initially released from inertia

%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

obs(happens, turn_light_on,   10).
obs(happens, turn_light_off,  25).

% conclude that the light is on between 10 and 20

% enables showing of -holdsAt and -releasedAt
negated_prints.