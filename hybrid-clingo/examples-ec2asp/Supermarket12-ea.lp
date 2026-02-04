#const maxstep=2.
#const maxtime=12.



fluent(forwards).
fluent(backwards).
fluent(spinning).

event(push).
event(pull).



initiates(push,forwards,S) :- not happens(pull,S), step(S).

terminates(push,backwards,S) :- not happens(pull,S), step(S).

initiates(pull,backwards,S) :- not happens(push,S), step(S).

terminates(pull,forwards,S) :- not happens(push,S), step(S).

initiates(pull,spinning,S) :- happens(push,S).

terminates(pull,forwards,S) :- happens(push,S).

terminates(pull,backwards,S) :- happens(push,S).

terminates(push,spinning,S) :- not happens(pull,S), step(S).

terminates(pull,spinning,S) :- not happens(push,S), step(S).

obs(notReleasedAt,forwards,0).

obs(notReleasedAt,backwards,0).

obs(notReleasedAt,spinning,0).

obs(notHoldsAt,forwards,0).

obs(notHoldsAt,backwards,0).

obs(notHoldsAt,spinning,0).

obs(happens,push,5).

obs(happens,pull,5).

obs(happens,pull,10).

obs(happens,push,10).

% --> conclude spinning after 5 and still spinning after 10