% light can be turned on and off

#const maxstep=2.
#const maxtime=1000.


%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

event(toggle_light).

fluent(light_on).


%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

initiates(toggle_light,  light_on, T) :- not holdsAt(light_on, T), step(T).

terminates(toggle_light, light_on, T) :- holdsAt(light_on, T), step(T).


%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------

initiallyN(light_on).
:- releasedAt(F,0), fluent(F).  % nothing is initially released from inertia


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

obs(happens, toggle_light,   10).
obs(happens, toggle_light,   20).

% conclude that the light is on between 10 and 20

% enables showing of -holdsAt and -releasedAt
negated_prints.