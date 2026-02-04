#show happens/2.
#show holdsAt(F, T) : happens(_, T), holdsAt(F,T).
#show holdsAt(F, maxtime) : holdsAt(F,maxtime).
#show holdsAt(F, 0) : holdsAt(F,0).
%#show releasedAt(F, T) : happens(_, T), releasedAt(F,T).
