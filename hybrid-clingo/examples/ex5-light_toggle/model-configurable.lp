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

% allows us to generate event observations via execution parameters (for experiments)
#const eventsNumber=10.
#const eventsScale=1.

obs(happens, toggle_light, T) :- EventNumber = 1..eventsNumber, T = EventNumber*eventsScale.
