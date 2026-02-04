% CC1
started(Fluent,S) :- holdsAt(Fluent,S).
started(Fluent,S) :- happens(Event,S), initiates(Event,Fluent,S).

%CC2
stopped(Fluent,S) :- not holdsAt(Fluent,S), fluent(Fluent), step(S).
stopped(Fluent,S) :- happens(Event,S), terminates(Event,Fluent,S).

%CC3
initiated(Fluent,S) :- started(Fluent,S), not terminated2(Fluent,S).
terminated2(Fluent,S) :- happens(Event,S), terminates(Event,Fluent,S).

%CC4
terminated(Fluent,S) :- stopped(Fluent,S), not initiated2(Fluent,S).
initiated2(Fluent,S) :- happens(Event,S), initiates(Event,Fluent,S).
