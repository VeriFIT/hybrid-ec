#const maxstep=2.
#const maxtime=40.



fluent(blocked1).
fluent(blocked2).
fluent(stuffy).

event(close1).
event(close2).
event(start).



initiates(close1,blocked1,S) :- step(S).

initiates(close2,blocked2,S) :- step(S).

% note: the 3 rules below represent an equivalence "stuffy <--> bocked1 and blocked2"

holdsAt(blocked2,S) :- holdsAt(stuffy,S).

holdsAt(blocked1,S) :- holdsAt(stuffy,S).

holdsAt(stuffy,S) :- holdsAt(blocked1,S), holdsAt(blocked2,S).

initiates(start,blocked1,S) :- step(S).

terminates(start,blocked2,S) :- step(S).

releasedAt(stuffy,S) :- step(S).

obs(notReleasedAt,blocked1,0).

obs(notReleasedAt,blocked2,0).

obs(notHoldsAt,blocked1,0).

obs(notHoldsAt,blocked2,0).

obs(happens,start,0).

obs(happens,close2,1).

% --> conclude stuffy after time 1