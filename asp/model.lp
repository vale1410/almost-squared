#const n=7. 
#hide.
#show succ/4. 
#show size/3. 
#show corner/1. 
#show reached/2. 
#show ring/3. 
#show ring_reached/2. 

%basics
box(1 .. n). 
obj(e).
obj(X) :- box(X). 

min(X,Y,X) :- box(X;Y), X < Y. 
min(X,Y,Y) :- box(X;Y), X > Y. 

% choice for boxes, and how much do they allign. 
{ succ(right,X,Y,1 .. S+1), succ(up,X,Y,0 .. S+1) } 1 :- min(X,Y,S).  % semantics of 0 = diagonal lower left to upper right 

%choose if box is sideways or up
1 { size(right,X,X), size(right,X,X+1) } 1 :- box(X).
size(up,X,X+1) :- box(X), size(right,X,X).
size(up,X,X) :- box(X), size(right,X,Y), X != Y. 

% choose size of the big rectangle (called empty).
size(M) :- M = (n*(n+1)*(n+2))/3.
rectangle(L,R) :- L = n .. (n*(n+1)), R = n .. (n*(n+1)), L <= R, size(S), S = R*L. 

1 { size(right,e,R) : rectangle(R,_) } 1.
size(up,e,L) :- rectangle(R,L), size(right,e,R). 

% full or nothing next to empty
{ succ(D,X,e,S) } 1 :- size(D,X,S), box(X). 
{ succ(D,e,X,S) } 1 :- size(D,X,S), box(X). 

% boxes have to be next to other boxes summed up exactly to their size
:- size(D,X,S), not S [ succ(D,X,Y,Z) = Z ] S. 
:- size(D,Y,S), not S [ succ(D,X,Y,Z) = Z ] S. 

%helpers and projections
succ(D,X,Y) :- succ(D,X,Y,_).
succ(X,Y) :- succ(_,X,Y).
con(X,Y) :- succ(X,Y). 
con(Y,X) :- succ(X,Y). 

% cycle free
reached(X,Y) :- succ(X,Y), box(X;Y). 
reached(X,Z) :- reached(X,Y), succ(Y,Z), box(Y;Z). 
:- box(X), reached(X,X).

% lower left corner
corner(X) :- succ(up,e,X), succ(right,e,X). 

% lower left corner is unique
:- 2 { corner(X) }.

% all nodes are reachable from lower left
:- box(Y), corner(X), X != Y, not reached(X,Y). 

% on side, standard
ring(X,Y,Z) :- succ(right,X,Y), succ(right,X,Z), succ(up,Y,Z). 
ring(X,Y,Z) :- succ(up,X,Y), succ(up,X,Z), succ(right,Z,Y). 
ring(X,Y,Z) :- succ(right,X,Y), succ(up,X,Z), succ(up,Y,Z). 
ring(X,Y,Z) :- succ(right,X,Y), succ(up,X,Z), succ(right,Z,Y). 
%ring(X,Y,Z) :- succ(X,Y), succ(X,Z), succ(Y,Z). 
%:- succ(right,X,Y), succ(up,X,Z), succ(up,Z,Y). 
%:- succ(right,X,Y), succ(up,X,Z), succ(right,Z,Y). 
ring(Y,Z,X) :- ring(X,Y,Z). % genious!

% the ring is unique!
:- con(X,Y), 2 { ring(X,Y,Z) }.

% choose a unique element 
has_smaller(X,Y) :- con(X,Y), con(X,Z), Z < Y. 
ring_reached(X,Y) :- con(X,Y), not has_smaller(X,Y). 
ring_reached(X,Z) :- ring_reached(X,Y), ring(X,Y,Z). 

:- con(X,Y), not ring_reached(X,Y). 

% EULER: e = 3v - 6 for maximally planar graphs
count(X,Y) :- succ(X,Y), box(Y).
count(X,e) :- succ(X,e), not succ(e,X). 
s(N) :- N = (3*(n+1)) - 6. 
:- s(S), not S  [count(_,_) ] S.

%  symmetry: fix order of n*n+1 and (n+1)*(n+2) blocks. 
%:- box(X), box(X+1), size(D,X,X+1), size(D,X+1,X+1), succ(D,X+1,X,X+1). 
