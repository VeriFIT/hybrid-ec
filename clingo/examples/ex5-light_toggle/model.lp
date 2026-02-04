% light can be turned on and off

%-------------------------------------------------------------------------------
% sorts
%-------------------------------------------------------------------------------

event(toggle_light).

fluent(light_on).


%-------------------------------------------------------------------------------
% effects 
%-------------------------------------------------------------------------------

initiates(toggle_light,  light_on, T) :- not holdsAt(light_on, T), time(T).
terminates(toggle_light, light_on, T) :- holdsAt(light_on, T), time(T).


%-------------------------------------------------------------------------------
% observations
%-------------------------------------------------------------------------------

initiallyN(light_on).
:- releasedAt(F,0), fluent(F). % nothing is initially released from CLoI


%-------------------------------------------------------------------------------
% narrative 
%-------------------------------------------------------------------------------

happens(toggle_light,      10).
happens(toggle_light,     20).

% conclude that the light is on between 10 and 20
