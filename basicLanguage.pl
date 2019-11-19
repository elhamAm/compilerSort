/*exo1*/
empty([]).

myPush(P,E,[E|P]).

myPop([E|P],P).

top([E|P],E).

/*exo2*/

/*if the first element is wanted, the index is 0*/
find([First|Tab],Ind,First):-
Ind = 0.

/*if the first element is wanted, the index is 0*/
find([_|Tab],Ind,FoundEle):-
\+Ind = 0,
NewInd is Ind-1,
find(Tab,NewInd,FoundEle).

/*if the index depasses the table: P should not be bigger that the length*/
check(P,Tab):-
length(Tab,Len),
P < Len,
P > 0.

check(P,Tab):-
P = 0.

check(P,Tab):-
length(Tab,Len),
P = Len.


execute(TabInst, Pile, Res):-
executeProg(TabInst, Pile, 0, [], Res).

minus("-").
plus("+").
mult("*").
div("/").

swap("SWAP").
over("OVER").
drop("DROP").
dup("DUP").

label("LABEL").
jump("JUMP").

/*find where the label put it in P*/
findLabNum([[Num|[P]]|TabLabel], Num, P).
findLabNum([[Num|[P]]], Num, P).
findLabNum([X|TabLabel], Num, P):-
findLabNum(TabLabel, Num, P).

/*At the end of array of instructions*/
executeProg(TabInst, Pile, P, TabLabel, Pile):-
length(TabInst,Len),
P = Len.

/*Check that it is a number and oush it on the pile*/
executeProg(TabInst, Pile, P, TabLabel, ResPile):-
find(TabInst, P, Inst),
integer(Inst),
myPush(Pile, Inst, PileRes),
Pnew is P + 1,
executeProg(TabInst, PileRes, Pnew, TabLabel, ResPile).

/*Check that it is a minus and substract the two last numbers*/
executeProg(TabInst, Pile, P, TabLabel, ResPile):-
find(TabInst, P, Inst),
minus(Inst),
top(Pile, E),
myPop(Pile, Pilenew),
top(Pilenew, Esec),
myPop(Pilenew, Pilenewnew),
Ans is Esec - E,
myPush(Pilenewnew, Ans, Pileres),
Pnew is P + 1,
executeProg(TabInst, Pileres, Pnew, TabLabel, ResPile).

/*Check that it is a plus and add the two last numbers*/
executeProg(TabInst, Pile, P, TabLabel, ResPile):-
find(TabInst, P, Inst),
plus(Inst),
top(Pile, E),
myPop(Pile, Pilenew),
top(Pilenew, Esec),
myPop(Pilenew, Pilenewnew),
Ans is Esec + E,
myPush(Pilenewnew, Ans, Pileres),
Pnew is P + 1,
executeProg(TabInst, Pileres, Pnew, TabLabel, ResPile).

/*Check that it is a * and multiply the two last numbers*/
executeProg(TabInst, Pile, P, TabLabel, ResPile):-
find(TabInst, P, Inst),
mult(Inst),
top(Pile, E),
myPop(Pile, Pilenew),
top(Pilenew, Esec),
myPop(Pilenew, Pilenewnew),
Ans is Esec * E,
myPush(Pilenewnew, Ans, Pileres),
Pnew is P + 1,
executeProg(TabInst, Pileres, Pnew, TabLabel, ResPile).

/*Check that it is a div and divide the two last numbers*/
executeProg(TabInst, Pile, P, TabLabel, ResPile):-
find(TabInst, P, Inst),
div(Inst),
top(Pile, E),
myPop(Pile, Pilenew),
top(Pilenew, Esec),
myPop(Pilenew, Pilenewnew),
Ans is Esec / E,
myPush(Pilenewnew, Ans, Pileres),
Pnew is P + 1,
executeProg(TabInst, Pileres, Pnew, TabLabel, ResPile).

/*Check that it is SWAP and SWAP the two last numbers*/
executeProg(TabInst, Pile, P, TabLabel, ResPile):-
find(TabInst, P, Inst),
swap(Inst),
top(Pile, E),
myPop(Pile, Pile1),
top(Pile1, Esec),
myPop(Pile1, Pile2),
myPush(Pile2,E,Pile3),
myPush(Pile3,Esec,Pile4),
Pnew is P + 1,
executeProg(TabInst, Pile4, Pnew, TabLabel, ResPile).

/*Check that it is OVER and push the seocnd element*/
executeProg(TabInst, Pile, P, TabLabel, ResPile):-
find(TabInst, P, Inst),
over(Inst),
top(Pile, E),
myPop(Pile, Pile1),
top(Pile1, Esec),
myPop(Pile1, Pile2),
myPush(Pile2,Esec,Pile3),
myPush(Pile3,E,Pile4),
myPush(Pile4,Esec,Pile5),
Pnew is P + 1,
executeProg(TabInst, Pile5, Pnew, TabLabel, ResPile).

/*Check that it is OVER and push the seocnd element*/
executeProg(TabInst, Pile, P, TabLabel, ResPile):-
find(TabInst, P, Inst),
dup(Inst),
top(Pile, E),
myPush(Pile,E,Pile1),
Pnew is P + 1,
executeProg(TabInst, Pile1, Pnew, TabLabel, ResPile).

/*Check that it is DROP and pop the first element*/
executeProg(TabInst, Pile, P, TabLabel, ResPile):-
find(TabInst, P, Inst),
drop(Inst),
myPop(Pile, Pile1),
Pnew is P + 1,
executeProg(TabInst, Pile1, Pnew, TabLabel, ResPile).

/*Check that it is LABEL,n and add n,P to TabLabel*/
executeProg(TabInst, Pile, P, TabLabel, ResPile):-
find(TabInst, P, [Lab|[Num]]),
label(Lab),
myPush(TabLabel, [Num, P], TabLabNew),
Pnew is P + 1,
executeProg(TabInst, Pile, Pnew, TabLabNew, ResPile).

/*Check that it is JUMP and that the top element is zero,n and find the number of instruction that corresponds to LABEL,n  then change the P*/
executeProg(TabInst, Pile, P, TabLabel, ResPile):-
find(TabInst, P, [Jmp|[Num]]),
jump(Jmp),
top(Pile, E),
E = 0,
findLabNum(TabLabel, Num, Pnew),
Pnewnew is Pnew + 1,
executeProg(TabInst, Pile, Pnewnew, TabLabel, ResPile).

/*Check that it is JUMP and that the top element is zero,n and find the number of instruction that corresponds to LABEL,n  then change the P*/
executeProg(TabInst, Pile, P, TabLabel, ResPile):-
find(TabInst, P, [Jmp|[Num]]),
jump(Jmp),
Pnew is P + 1,
executeProg(TabInst, Pile, Pnew, TabLabel, ResPile).
