#const maxstep=1.
#const maxtime=1.



fluent(light).
fluent(switch1).
fluent(switch2).
fluent(switch3).
fluent(relay).

event(lightOn).
event(close1).
event(open2).
event(closeRelay).



happens(lightOn,S) :- stopped(light,S), initiated(switch1,S), initiated(switch2,S).

happens(open2,S) :- started(switch2,S), initiated(relay,S).

happens(closeRelay,S) :- stopped(relay,S), initiated(switch1,S), initiated(switch3,S).

initiates(lightOn,light,S) :- step(S).

terminates(open2,switch2,S) :- step(S).

initiates(closeRelay,relay,S) :- step(S).

initiates(close1,switch1,S) :- step(S).

obs(notReleasedAt,light,0).

obs(notReleasedAt,switch1,0).

obs(notReleasedAt,switch2,0).

obs(notReleasedAt,switch3,0).

obs(notReleasedAt,relay,0).

obs(notHoldsAt,switch1,0).

obs(holdsAt,switch2,0).

obs(holdsAt,switch3,0).

obs(notHoldsAt,relay,0).

obs(notHoldsAt,light,0).

obs(happens,close1,0).

negated_prints.

% --> conclude not light on after time 0 (light not on after closing switch1)