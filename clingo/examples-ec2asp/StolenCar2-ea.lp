

#const maxtime=2.
%offset(1..1).



fluent(carParked).

event(park).
event(steal).



initiates(park,carParked,Time) :- time(Time).

terminates(steal,carParked,Time) :- time(Time).

:- releasedAt(carParked,0).

:- holdsAt(carParked,0).

happens(park,0).

:- holdsAt(carParked,2).

0 {happens(E, T)} 1 :- time(T), T<maxtime, event(E).



#show.

#show holdsAt/2.
#show happens/2.
