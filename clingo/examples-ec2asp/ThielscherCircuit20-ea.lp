

#const maxtime=20.
%offset(1..1).



fluent(light).
fluent(switch1).
fluent(switch2).
fluent(switch3).
fluent(relay).

event(lightOn).
event(close1).
event(open2).
event(closeRelay).



happens(lightOn,Time) :- stopped(light,Time), initiated(switch1,Time), initiated(switch2,Time).

happens(open2,Time) :- started(switch2,Time), initiated(relay,Time).

happens(closeRelay,Time) :- stopped(relay,Time), initiated(switch1,Time), initiated(switch3,Time).

initiates(lightOn,light,Time) :- time(Time).

terminates(open2,switch2,Time) :- time(Time).

initiates(closeRelay,relay,Time) :- time(Time).

initiates(close1,switch1,Time) :- time(Time).

:- releasedAt(light,0).

:- releasedAt(switch1,0).

:- releasedAt(switch2,0).

:- releasedAt(switch3,0).

:- releasedAt(relay,0).

:- holdsAt(switch1,0).

holdsAt(switch2,0).

holdsAt(switch3,0).

:- holdsAt(relay,0).

:- holdsAt(light,0).

happens(close1,12).

#show.

#show holdsAt/2.
#show happens/2.
