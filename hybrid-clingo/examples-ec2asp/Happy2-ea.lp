#const maxstep=1.
#const maxtime=2.



person(fred).

fluent(happy(Person)) :- person(Person).
fluent(hungry(Person)) :- person(Person).
fluent(cold(Person)) :- person(Person).

event(feed(Person)) :- person(Person).
event(clothe(Person)) :- person(Person).



:- holdsAt(happy(Person),S), holdsAt(cold(Person),S).

:- holdsAt(happy(Person),S), holdsAt(hungry(Person),S).

holdsAt(happy(Person),S) :- not holdsAt(hungry(Person),S), not holdsAt(cold(Person),S), step(S), person(Person).

terminates(feed(Person),hungry(Person),S) :- step(S), person(Person).

terminates(clothe(Person),cold(Person),S) :- step(S), person(Person).

releasedAt(happy(Person),S) :- step(S), person(Person).

obs(notReleasedAt,hungry(Person),0) :- person(Person).

obs(notReleasedAt,cold(Person),0) :- person(Person).

obs(holdsAt,hungry(fred),0).

obs(notHoldsAt,cold(fred),0).

obs(happens,feed(fred),1).

% --> conclude happy(fred) after 1