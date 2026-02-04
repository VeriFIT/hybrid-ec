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

% allows us to generate event observations via execution parameters (for experiments)
#const eventsNumber=10.
#const precision=1.



#show holdsAt(F, T) : happens(_, T), holdsAt(F,T).
#show happens/2.

#show maxTime(maxtime).
#show maxTime(maxtime).
#show eventsNumber(eventsNumber).
#show precision(precision).

happens(toggle_light, T) :- EventNumber = 1..eventsNumber, T = EventNumber*precision.
