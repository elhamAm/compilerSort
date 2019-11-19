/*exo3*/
empty([]).

myPush(P,E,[E|P]).

myPop([E|P],P).


top([E|P],E).

/*exo4*/

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
executeProg(TabInst, [],  Pile, 0, Res).

minus("-").
plus("+").
mult("*").
div("/").

swap("SWAP").
over("OVER").
drop("DROP").
dup("DUP").

bigger(">").
smaller("<").
equal("=").

deuxPoints(":").

defFunc([Start|X]):-
deuxPoints(Start).


/*At the end of array of instructions*/
executeProg(TabInst, TabDefFunc, Pile, P, Pile):-
length(TabInst,Len),
P = Len.


/*Check that it is > and empile true if it's true*/
executeProg(TabInst, TabDefFunc, Pile, P, ResPile):-
find(TabInst, P, Inst),
bigger(Inst),
Pile = [Top|Pile1],
Pile1 = [Sec|Pile2],
Sec > Top,
myPush(Pile,"true",Pile3),
Pnew is P + 1,
executeProg(TabInst, TabDefFunc, Pile3, Pnew, ResPile).

/*Check that it is > and empile false if it's not true*/
executeProg(TabInst, TabDefFunc, Pile, P, ResPile):-
find(TabInst, P, Inst),
bigger(Inst),
Pile = [Top|Pile1],
Pile1 = [Sec|Pile2],
\+ Sec > Top,
myPush(Pile,"false",Pile3),
Pnew is P + 1,
executeProg(TabInst, TabDefFunc, Pile3, Pnew, ResPile).

/*Check that it is < and empile true if it's true*/
executeProg(TabInst, TabDefFunc, Pile, P, ResPile):-
find(TabInst, P, Inst),
smaller(Inst),
Pile = [Top|Pile1],
Pile1 = [Sec|Pile2],
Sec < Top,
myPush(Pile,"true",Pile3),
Pnew is P + 1,
executeProg(TabInst, TabDefFunc, Pile3, Pnew, ResPile).

/*Check that it is < and empile false if it's not true*/
executeProg(TabInst, TabDefFunc, Pile, P, ResPile):-
find(TabInst, P, Inst),
smaller(Inst),
Pile = [Top|Pile1],
Pile1 = [Sec|Pile2],
\+Sec < Top,
myPush(Pile,"false",Pile3),
Pnew is P + 1,
executeProg(TabInst, TabDefFunc, Pile3, Pnew, ResPile).

/*Check that it is = and empile true if it's true*/
executeProg(TabInst, TabDefFunc, Pile, P, ResPile):-
find(TabInst, P, Inst),
equal(Inst),
Pile = [Top|Pile1],
Pile1 = [Sec|Pile2],
Sec = Top,
myPush(Pile,"true",Pile3),
Pnew is P + 1,
executeProg(TabInst, TabDefFunc, Pile3, Pnew, ResPile).

/*Check that it is = and empile false if it's not true*/
executeProg(TabInst, TabDefFunc, Pile, P, ResPile):-
find(TabInst, P, Inst),
equal(Inst),
Pile = [Top|Pile1],
Pile1 = [Sec|Pile2],
\+Sec = Top,
myPush(Pile,"false",Pile3),
Pnew is P + 1,
executeProg(TabInst, TabDefFunc, Pile3, Pnew, ResPile).


/*Check that the instruction is a condition
and if there is true on the pile then execute the program and
then take the pile returned inorder to execute the rest of the program with the pile found*/
executeProg(TabInst, TabDefFunc, Pile, P, ResPile):-
find(TabInst, P, Inst),
Inst = [ConditionTrue|_],
ConditionTrue = ["IF"|TabInstTemp],
top(Pile, "true"),
executeProg(TabInstTemp, TabDefFunc, Pile, 0, PileTemp),
Pnew is P + 1,
executeProg(TabInst, TabDefFunc, PileTemp, Pnew, ResPile).

/*Check that the instruction is a condition
and if there is false on the pile then execute the program and
then take the pile returned inorder to execute the rest of the program with the pile found*/
executeProg(TabInst, TabDefFunc, Pile, P, ResPile):-
find(TabInst, P, Inst),
Inst = [_|[ConditionFalse]],
ConditionFalse = ["ELSE"|TabInstTemp],
top(Pile, "false"),
executeProg(TabInstTemp, TabDefFunc, Pile, 0, PileTemp),
Pnew is P + 1,
executeProg(TabInst, TabDefFunc, PileTemp, Pnew, ResPile).

/*find the definition of the name of the function and return the definition*/
findDefFunc([[NameFun| Def ]|TabLabel], NameFun, Def).
findDefFunc([[NameFun | Def]], NameFun, Def).
findDefFunc([X|TabDefFun], NameFun, Def):-
findDefFunc(TabDefFun, NameFun, Def).

/*Check that it is a number and push it on the pile*/
executeProg(TabInst, TabDefFunc, Pile, P, ResPile):-
find(TabInst, P, Inst),
integer(Inst),
myPush(Pile, Inst, PileRes),
Pnew is P + 1,
executeProg(TabInst, TabDefFunc, PileRes, Pnew, ResPile).

/*Check that it is the definition of a function and oush the definition on the Table of function definitions*/
/*we delete the semicolumn that starts it*/
executeProg(TabInst, TabDefFunc, Pile, P, ResPile):-
find(TabInst, P, [Start|InstDef]),
defFunc([Start|InstDef]),
myPush(TabDefFunc, InstDef, TabDefFuncNew),
Pnew is P + 1,
executeProg(TabInst, TabDefFuncNew, Pile, Pnew, ResPile).


/*Check that it is the name of a function by finding it in TabDefFunc*/
/*After finding the definition , we take the definition and execute it with the function executeProg*/
/*take the pile that it returns and execute the rest of the program with this pile*/
executeProg(TabInst, TabDefFunc, Pile, P, ResPile):-
find(TabInst, P, Inst),
findDefFunc(TabDefFunc, Inst, TabInstTemp),
executeProg(TabInstTemp, TabDefFunc, Pile, 0, PileInter),
Pnew is P + 1,
executeProg(TabInst, TabDefFuncNew, PileInter, Pnew, ResPile).

/*Check that it is a minus and substract the two last numbers*/
executeProg(TabInst, TabDefFunc, Pile, P, ResPile):-
find(TabInst, P, Inst),
minus(Inst),
top(Pile, E),
myPop(Pile, Pilenew),
top(Pilenew, Esec),
myPop(Pilenew, Pilenewnew),
Ans is Esec - E,
myPush(Pilenewnew, Ans, Pileres),
Pnew is P + 1,
executeProg(TabInst, TabDefFunc, Pileres, Pnew, ResPile).

/*Check that it is a plus and add the two last numbers*/
executeProg(TabInst, TabDefFunc, Pile, P, ResPile):-
find(TabInst, P, Inst),
plus(Inst),
top(Pile, E),
myPop(Pile, Pilenew),
top(Pilenew, Esec),
myPop(Pilenew, Pilenewnew),
Ans is Esec + E,
myPush(Pilenewnew, Ans, Pileres),
Pnew is P + 1,
executeProg(TabInst, TabDefFunc, Pileres, Pnew, ResPile).

/*Check that it is a * and multiply the two last numbers*/
executeProg(TabInst, TabDefFunc, Pile, P, ResPile):-
find(TabInst, P, Inst),
mult(Inst),
top(Pile, E),
myPop(Pile, Pilenew),
top(Pilenew, Esec),
myPop(Pilenew, Pilenewnew),
Ans is Esec * E,
myPush(Pilenewnew, Ans, Pileres),
Pnew is P + 1,
executeProg(TabInst, TabDefFunc, Pileres, Pnew, ResPile).

/*Check that it is a div and divide the two last numbers*/
executeProg(TabInst, TabDefFunc, Pile, P, ResPile):-
find(TabInst, P, Inst),
div(Inst),
top(Pile, E),
myPop(Pile, Pilenew),
top(Pilenew, Esec),
myPop(Pilenew, Pilenewnew),
Ans is Esec / E,
myPush(Pilenewnew, Ans, Pileres),
Pnew is P + 1,
executeProg(TabInst, TabDefFunc, Pileres, Pnew, ResPile).

/*Check that it is SWAP and SWAP the two last numbers*/
executeProg(TabInst, TabDefFunc, Pile, P, ResPile):-
find(TabInst, P, Inst),
swap(Inst),
top(Pile, E),
myPop(Pile, Pile1),
top(Pile1, Esec),
myPop(Pile1, Pile2),
myPush(Pile2,E,Pile3),
myPush(Pile3,Esec,Pile4),
Pnew is P + 1,
executeProg(TabInst, TabDefFunc, Pile4, Pnew, ResPile).

/*Check that it is OVER and push the seocnd element*/
executeProg(TabInst, TabDefFunc, Pile, P, ResPile):-
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
executeProg(TabInst, TabDefFunc, Pile5, Pnew, ResPile).

/*Check that it is OVER and push the seocnd element*/
executeProg(TabInst, TabDefFunc, Pile, P, ResPile):-
find(TabInst, P, Inst),
dup(Inst),
top(Pile, E),
myPush(Pile,E,Pile1),
Pnew is P + 1,
executeProg(TabInst, TabDefFunc,  Pile1, Pnew, ResPile).

/*Check that it is DROP and pop the first element*/
executeProg(TabInst, TabDefFunc, Pile, P, ResPile):-
find(TabInst, P, Inst),
drop(Inst),
myPop(Pile, Pile1),
Pnew is P + 1,
executeProg(TabInst, TabDefFunc, Pile1, Pnew, ResPile).
