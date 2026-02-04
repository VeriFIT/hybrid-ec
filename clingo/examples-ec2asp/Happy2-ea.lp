

#const maxtime=2.
%offset(1..1).

person(fred).


fluent(happy(Person)) :- person(Person).
fluent(hungry(Person)) :- person(Person).
fluent(cold(Person)) :- person(Person).

event(feed(Person)) :- person(Person).
event(clothe(Person)) :- person(Person).



:- holdsAt(happy(Person),Time), holdsAt(cold(Person),Time).

:- holdsAt(happy(Person),Time), holdsAt(hungry(Person),Time).

holdsAt(happy(Person),Time) :- not holdsAt(hungry(Person),Time), not holdsAt(cold(Person),Time), time(Time), person(Person).

terminates(feed(Person),hungry(Person),Time) :- time(Time), person(Person).

terminates(clothe(Person),cold(Person),Time) :- time(Time), person(Person).

releasedAt(happy(Person),Time) :- time(Time), person(Person).

:- releasedAt(hungry(Person),0).

:- releasedAt(cold(Person),0).

holdsAt(hungry(fred),0).

:- holdsAt(cold(fred),0).

happens(feed(fred),1).

#show.

#show holdsAt/2.
#show happens/2.
