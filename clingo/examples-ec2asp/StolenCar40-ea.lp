

#const maxtime=40.
%offset(1..1).



fluent(carParked).

event(park).
event(steal).



initiates(park,carParked,Time) :- time(Time).

terminates(steal,carParked,Time) :- time(Time).

:- releasedAt(carParked,0).

:- holdsAt(carParked,0).

happens(park,20).

:- holdsAt(carParked,maxtime).

holdsAt(carParked,Time) :- happens(steal,Time).

:- happens(steal,Time1), Time1<Time2, happens(park,Time2).

:- happens(park, T), holdsAt(carParked, T). % added to avoid abducing park at step 0

0 {happens(E, T)} 1 :- time(T), T<maxtime, event(E).



#show.

#show holdsAt/2.
#show happens/2.

% looking only for one model using -n1, otherwise many models