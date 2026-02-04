

#const maxtime=3.
%offset(1..1).

agent(agent1).
agent(agent2).
phone(phone1).
phone(phone2).


fluent(ringing(Phone,Phone1)) :- phone(Phone), phone(Phone1).
fluent(dialTone(Phone)) :- phone(Phone).
fluent(busySignal(Phone)) :- phone(Phone).
fluent(idle(Phone)) :- phone(Phone).
fluent(connected(Phone,Phone1)) :- phone(Phone), phone(Phone1).
fluent(disconnected(Phone)) :- phone(Phone).

event(pickUp(Agent,Phone)) :- agent(Agent), phone(Phone).
event(setDown(Agent,Phone)) :- agent(Agent), phone(Phone).
event(dial(Agent,Phone,Phone2)) :- agent(Agent), phone(Phone), phone(Phone2).



initiates(pickUp(Agent,Phone),dialTone(Phone),S) :- holdsAt(idle(Phone),S), agent(Agent).

terminates(pickUp(Agent,Phone),idle(Phone),S) :- holdsAt(idle(Phone),S), agent(Agent).

initiates(setDown(Agent,Phone),idle(Phone),S) :- holdsAt(dialTone(Phone),S), agent(Agent).

terminates(setDown(Agent,Phone),dialTone(Phone),S) :- holdsAt(dialTone(Phone),S), agent(Agent).

initiates(dial(Agent,Phone1,Phone2),ringing(Phone1,Phone2),S) :- holdsAt(dialTone(Phone1),S), holdsAt(idle(Phone2),S), agent(Agent).

terminates(dial(Agent,Phone1,Phone2),dialTone(Phone1),S) :- holdsAt(dialTone(Phone1),S), holdsAt(idle(Phone2),S), agent(Agent).

terminates(dial(Agent,Phone1,Phone2),idle(Phone2),S) :- holdsAt(dialTone(Phone1),S), holdsAt(idle(Phone2),S), agent(Agent).

initiates(dial(Agent,Phone1,Phone2),busySignal(Phone1),S) :- holdsAt(dialTone(Phone1),S), not holdsAt(idle(Phone2),S), phone(Phone2), agent(Agent).

terminates(dial(Agent,Phone1,Phone2),dialTone(Phone1),S) :- holdsAt(dialTone(Phone1),S), not holdsAt(idle(Phone2),S), phone(Phone2), agent(Agent).

initiates(setDown(Agent,Phone),idle(Phone),S) :- holdsAt(busySignal(Phone),S), agent(Agent).

terminates(setDown(Agent,Phone),busySignal(Phone),S) :- holdsAt(busySignal(Phone),S), agent(Agent).

initiates(setDown(Agent,Phone1),idle(Phone1),S) :- holdsAt(ringing(Phone1,Phone2),S), agent(Agent).

initiates(setDown(Agent,Phone1),idle(Phone2),S) :- holdsAt(ringing(Phone1,Phone2),S), agent(Agent).

terminates(setDown(Agent,Phone1),ringing(Phone1,Phone2),S) :- holdsAt(ringing(Phone1,Phone2),S), agent(Agent).

initiates(pickUp(Agent,Phone2),connected(Phone1,Phone2),S) :- holdsAt(ringing(Phone1,Phone2),S), agent(Agent).

terminates(pickUp(Agent,Phone2),ringing(Phone1,Phone2),S) :- holdsAt(ringing(Phone1,Phone2),S), agent(Agent).

initiates(setDown(Agent,Phone1),idle(Phone1),S) :- holdsAt(connected(Phone1,Phone2),S), agent(Agent).

initiates(setDown(Agent,Phone1),disconnected(Phone2),S) :- holdsAt(connected(Phone1,Phone2),S), agent(Agent).

terminates(setDown(Agent,Phone1),connected(Phone1,Phone2),S) :- holdsAt(connected(Phone1,Phone2),S), agent(Agent).

initiates(setDown(Agent,Phone2),idle(Phone2),S) :- holdsAt(connected(Phone1,Phone2),S), agent(Agent).

initiates(setDown(Agent,Phone2),disconnected(Phone1),S) :- holdsAt(connected(Phone1,Phone2),S), agent(Agent).

terminates(setDown(Agent,Phone2),connected(Phone1,Phone2),S) :- holdsAt(connected(Phone1,Phone2),S), agent(Agent).

initiates(setDown(Agent,Phone),idle(Phone),S) :- holdsAt(disconnected(Phone),S), agent(Agent).

terminates(setDown(Agent,Phone),disconnected(Phone),S) :- holdsAt(disconnected(Phone),S), agent(Agent).

happens(pickUp(agent1,phone1),0).

happens(dial(agent1,phone1,phone2),1).

happens(pickUp(agent2,phone2),2).

holdsAt(idle(Phone),0) :- phone(Phone).

:- holdsAt(dialTone(Phone),0).

:- holdsAt(busySignal(Phone),0).

:- holdsAt(ringing(Phone1,Phone2),0).

:- holdsAt(connected(Phone1,Phone2),0).

:- holdsAt(disconnected(Phone),0).

:- releasedAt(ringing(Phone1,Phone2),0).

:- releasedAt(dialTone(Phone),0).

:- releasedAt(busySignal(Phone),0).

:- releasedAt(idle(Phone),0).

:- releasedAt(connected(Phone1,Phone2),0).

:- releasedAt(disconnected(Phone),0).

#show.

#show holdsAt/2.
#show happens/2.
