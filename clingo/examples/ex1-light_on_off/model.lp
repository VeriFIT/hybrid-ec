% light can be turned on and off
% from T.Mueller, 2014 - Commonsense reasoning - an event calculus based approach

%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

event(turn_light_on).
event(turn_light_off).

fluent(light_on).


%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

initiates(turn_light_on,  light_on, T) :- time(T).
terminates(turn_light_off, light_on, T) :- time(T).


%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------

initiallyN(light_on).
:- releasedAt(F,0), fluent(F). % nothing is initially released from CLoI


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

happens(turn_light_on,      10).
happens(turn_light_off,     20).

% conclude that the light is on between 10 and 20
