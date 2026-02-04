#show happens3/3.
#show holdsAt(F, T) : happens3(_, T, _), holdsAt(F,T).
#show holdsAt(F, T) : happens3(_, _, T), holdsAt(F,T).
#show holdsAt(F, maxtime) : holdsAt(F,maxtime).
#show holdsAt(F, 0) : holdsAt(F,0).
%#show releasedAt(F, T) : happens3(_, T, _), releasedAt(F,T).
%#show releasedAt(F, T) : happens3(_, _, T), releasedAt(F,T).
