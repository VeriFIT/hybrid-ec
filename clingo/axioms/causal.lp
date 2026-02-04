% based on https://azreasoners.github.io/ecasp/examples/foundations/ECCausal.lp

% CC1
started(Fluent,Time) :- holdsAt(Fluent,Time).
started(Fluent,Time) :- happens(Event,Time), initiates(Event,Fluent,Time).

%CC2
stopped(Fluent,Time) :- not holdsAt(Fluent,Time), fluent(Fluent), time(Time).
stopped(Fluent,Time) :- happens(Event,Time), terminates(Event,Fluent,Time).

%CC3
terminated2(Fluent,Time) :- happens(Event,Time), terminates(Event,Fluent,Time).
initiated(Fluent,Time) :- started(Fluent,Time), not terminated2(Fluent,Time).

%CC4
initiated2(Fluent,Time) :- happens(Event,Time), initiates(Event,Fluent,Time).
terminated(Fluent,Time) :- stopped(Fluent,Time), not initiated2(Fluent,Time).
