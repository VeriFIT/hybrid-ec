#const maxstep=4.
#const maxtime=15.



place(work).
place(home).
station(herneHill).
station(victoria).
station(southKen).

place(V) :- station(V).
fluent(at(Place)) :- place(Place).
fluent(train(Station,Station1)) :- station(Station), station(Station1).

event(walkTo(Place)) :- place(Place).
event(trainTo(Station)) :- station(Station).
event(goToWork).



initiates(walkTo(Place),at(Place),S) :- step(S), place(Place).

terminates(walkTo(Place2),at(Place1),S) :- Place1!=Place2, holdsAt(at(Place1),S), place(Place2).

initiates(trainTo(Station2),at(Station2),S) :- holdsAt(train(Station1,Station2),S), holdsAt(at(Station1),S).

terminates(trainTo(Station2),at(Station1),S) :- holdsAt(train(Station1,Station2),S), holdsAt(at(Station1),S).

initiates(goToWork,at(work),S) :- step(S).

terminates(goToWork,at(Place1),S) :- holdsAt(at(Place1),S), Place1!=work.

happens3(goToWork,S1,S4) :-
    happens3(walkTo(herneHill),S1,S1),
    happens3(trainTo(victoria),S2,S2),
    happens3(trainTo(southKen),S3,S3),
    happens3(walkTo(work),S4,S4),
    S1<S2, S2<S3, S3<S4,
    not stoppedIn(S1,at(herneHill),S2),
    not terminated1(at(herneHill), S1), %not released1(at(herneHill),S1),
    not stoppedIn(S2,at(victoria),S3),
    not terminated1(at(victoria), S2), %not released1(at(victoria),S2),
    not stoppedIn(S3,at(southKen),S4),
    not terminated1(at(southKen), S3). %not released1(at(southKen),S1),


holdsAt(train(herneHill,victoria),S) :- step(S).

holdsAt(train(victoria,southKen),S) :- step(S).

obs(notReleasedAt,at(Place),0) :- place(Place).

obs(notReleasedAt,train(Station1,Station2),0) :- station(Station1), station(Station2).

:- holdsAt(at(Place1),S), holdsAt(at(Place2),S), Place1!=Place2.

:- holdsAt(train(Station1,Station2),S), Station1==Station2.

:- Station1!=herneHill, Station1!=victoria, holdsAt(train(Station1,Station2),S).

:- Station2!=victoria, Station2!=southKen, holdsAt(train(Station1,Station2),S).

:- holdsAt(train(Station1,Station2),S), Station1==herneHill, Station2==southKen.

obs(holdsAt,at(home),0).

obs(happens3,walkTo(herneHill),1,1).

obs(happens3,trainTo(victoria),6,6).

obs(happens3,trainTo(southKen),10,10).

obs(happens3,walkTo(work),12,12).


% --> conclude ..