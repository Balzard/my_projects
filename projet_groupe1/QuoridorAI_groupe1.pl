/* --------------------------------------------------------------------- */
/*                                                                       */
/*        STRAT(C_State, N_Action) :                                     */
/*                                                                       */
/*        Input : un état C_State reprenant l'état courrant du           */
/*                jeu                                                    */
/*        Output : une chaîne de caractères correspondant à la           */
/*                 prochaine action à effectuer                          */
/*                                                                       */
/* --------------------------------------------------------------------- */

/* NOT CHECKED */
%strat(C_state, N_action):-
%    explorer(arbre).

strat(0,_,STATE,VECTOR,_):-
    util(STATE,VECTOR),!.
strat(N,IA_COLOR,STATE,B_VECTOR,B_ACTION):-
    current_player(STATE,C_COLOR),
    IA_COLOR == C_COLOR,
    findall(ACTION,action(STATE,ACTION),L_ACTION),
    from_laction_to_lstate(STATE,L_ACTION,L_STATE),
    M is N - 1,
    best_branch(M,IA_COLOR,L_ACTION,L_STATE,[],B_VECTOR,B_ACTION).
strat(N,IA_COLOR,STATE,W_VECTOR,W_ACTION):-
    current_player(STATE,C_COLOR),
    IA_COLOR \= C_COLOR,
    findall(ACTION,action(STATE,ACTION),L_ACTION),
    from_laction_to_lstate(STATE,L_ACTION,L_STATE),
    M is N - 1,
    worst_branch(M,IA_COLOR,L_ACTION,L_STATE,[],W_VECTOR,W_ACTION).

best_branch(_,IA_COLOR,[],[],L_VECTOR_REF,B_VECTOR,B_ACTION):-
    best_vector(L_VECTOR_REF,IA_COLOR,ref(B_VECTOR,B_ACTION)).
best_branch(N,IA_COLOR,[ACTION|AS],[STATE|SS],L_VECTOR_REF,T_VECTOR,T_ACTION):-
    strat(N,IA_COLOR,STATE,VECTOR,_),
    append(L_VECTOR_REF,[ref(VECTOR,ACTION)],NL_VECTOR_REF),
    best_branch(N,IA_COLOR,AS,SS,NL_VECTOR_REF,T_VECTOR,T_ACTION).

worst_branch(_,IA_COLOR,[],[],L_VECTOR_REF,B_VECTOR,B_ACTION):-
    worst_vector(L_VECTOR_REF,IA_COLOR,ref(B_VECTOR,B_ACTION)).
worst_branch(N,IA_COLOR,[ACTION|AS],[STATE|SS],L_VECTOR_REF,T_VECTOR,T_ACTION):-
    strat(N,IA_COLOR,STATE,VECTOR,_),
    append(L_VECTOR_REF,[ref(VECTOR,ACTION)],NL_VECTOR_REF),
    worst_branch(N,IA_COLOR,AS,SS,NL_VECTOR_REF,T_VECTOR,T_ACTION).

best_vector([VECTOR_REF],_,VECTOR_REF).
best_vector([VECTOR_REF|VRS],IA_COLOR,REF):-
    best_vector(VRS,IA_COLOR,B_VECTOR_REF),
    better_vector(IA_COLOR,VECTOR_REF,B_VECTOR_REF,REF).

worst_vector([VECTOR_REF],_,VECTOR_REF).
worst_vector([VECTOR_REF|VRS],IA_COLOR,REF):-
    worse_vector(IA_COLOR,VECTOR_REF,W_VECTOR_REF,REF),
    worst_vector(VRS,IA_COLOR,W_VECTOR_REF).

better_vector(IA_COLOR,
              ref([V11,V21,V31,V41],A1),
              ref([V12,V22,V32,V42],_),
              ref([V11,V21,V31,V41],A1)):-
    greater_than_average(IA_COLOR,[V11,V21,V31,V41],[V12,V22,V32,V42],first).
better_vector(IA_COLOR,
              ref([V11,V21,V31,V41],_),
              ref([V12,V22,V32,V42],A2),
              ref([V12,V22,V32,V42],A2)):-
    greater_than_average(IA_COLOR,[V11,V21,V31,V41],[V12,V22,V32,V42],second).
better_vector(IA_COLOR,
              ref([V11,V21,V31,V41],A1),
              ref([V12,V22,V32,V42],_),
              ref([V11,V21,V31,V41],A1)):-
    not(greater_than_average(IA_COLOR,[V11,V21,V31,V41],[V12,V22,V32,V42],_)),
	opp_vector(IA_COLOR,[V11,V21,V31,V41],[O11,O21,O31]),
	opp_vector(IA_COLOR,[V12,V22,V32,V42],[O12,O22,O32]),
	AVG_OPP1 is (O11 + O21 + O31) / 3,
	AVG_OPP2 is (O12 + O22 + O32) / 3,
	greater_than_avg_diff_opp(O11,O21,O31,O12,O22,O32,AVG_OPP1,AVG_OPP2,first).
better_vector(IA_COLOR,
              ref([V11,V21,V31,V41],_),
              ref([V12,V22,V32,V42],A2),
              ref([V12,V22,V32,V42],A2)):-
    not(greater_than_average(IA_COLOR,[V11,V21,V31,V41],[V12,V22,V32,V42],_)),
	opp_vector(IA_COLOR,[V11,V21,V31,V41],[O11,O21,O31]),
	opp_vector(IA_COLOR,[V12,V22,V32,V42],[O12,O22,O32]),
	AVG_OPP1 is (O11 + O21 + O31) / 3,
	AVG_OPP2 is (O12 + O22 + O32) / 3,
	greater_than_avg_diff_opp(O11,O21,O31,O12,O22,O32,AVG_OPP1,AVG_OPP2,second).
better_vector(IA_COLOR,
              ref([V11,V21,V31,V41],A1),
              ref([V12,V22,V32,V42],_),
              ref([V11,V21,V31,V41],A1)):-
    not(greater_than_average(IA_COLOR,[V11,V21,V31,V41],[V12,V22,V32,V42],_)),
	opp_vector(IA_COLOR,[V11,V21,V31,V41],[O11,O21,O31]),
	opp_vector(IA_COLOR,[V12,V22,V32,V42],[O12,O22,O32]),
	AVG_OPP1 is (O11 + O21 + O31) / 3,
	AVG_OPP2 is (O12 + O22 + O32) / 3,
    not(greater_than_avg_diff_opp(O11,O21,O31,O12,O22,O32,AVG_OPP1,AVG_OPP2,_)),
	lower_than_avg_diff_opp(O11,O21,O31,O12,O22,O32,AVG_OPP1,AVG_OPP2,first).
better_vector(IA_COLOR,
              ref([V11,V21,V31,V41],_),
              ref([V12,V22,V32,V42],A2),
              ref([V12,V22,V32,V42],A2)):-
    not(greater_than_average(IA_COLOR,[V11,V21,V31,V41],[V12,V22,V32,V42],_)),
	opp_vector(IA_COLOR,[V11,V21,V31,V41],[O11,O21,O31]),
	opp_vector(IA_COLOR,[V12,V22,V32,V42],[O12,O22,O32]),
	AVG_OPP1 is (O11 + O21 + O31) / 3,
	AVG_OPP2 is (O12 + O22 + O32) / 3,
    not(greater_than_avg_diff_opp(O11,O21,O31,O12,O22,O32,AVG_OPP1,AVG_OPP2,_)),
	lower_than_avg_diff_opp(O11,O21,O31,O12,O22,O32,AVG_OPP1,AVG_OPP2,second).

worse_vector(IA_COLOR,
             ref([V11,V21,V31,V41],A1),
             ref([V12,V22,V32,V42],A2),
             ref([V11,V21,V31,V41],A1)):-
    better_vector(IA_COLOR,
             ref([V11,V21,V31,V41],A1),
             ref([V12,V22,V32,V42],A2),
             ref([V12,V22,V32,V42],A2)).
worse_vector(IA_COLOR,
             ref([V11,V21,V31,V41],A1),
             ref([V12,V22,V32,V42],A2),
             ref([V12,V22,V32,V42],A2)):-
    better_vector(IA_COLOR,
             ref([V11,V21,V31,V41],A1),
             ref([V12,V22,V32,V42],A2),
             ref([V11,V21,V31,V41],A1)).

/* --------------------------------------------------------------------- */
/*                                                                       */
/*        UTIL(STATE, VECTOR) :                                          */
/*                                                                       */
/*        Input : un état STATE reprenant l'état courrant du             */
/*                jeu                                                    */
/*        Output : Un vector correspondant à l'utilité de                */
/*                 l'état pour chacun des joueurs                        */
/*                                                                       */
/* --------------------------------------------------------------------- */

util(state(_,
           [player(bleu,NB1,[PosX1,PosY1]),
            player(rouge,NB2,[PosX2,PosY2]),
            player(vert,NB3,[PosX3,PosY3]),
            player(jaune,NB4,[PosX4,PosY4])],
     		SB),
     [NP1,NP2,NP3,NP4]):-
    util_player(bleu,NB1,[PosX1,PosY1],
                [player(bleu,NB1,[PosX1,PosY1]),
            	 player(rouge,NB2,[PosX2,PosY2]),
            	 player(vert,NB3,[PosX3,PosY3]),
            	 player(jaune,NB4,[PosX4,PosY4])]
                ,SB,NP1),
    util_player(rouge,NB2,[PosX2,PosY2],
                [player(bleu,NB1,[PosX1,PosY1]),
           		 player(rouge,NB2,[PosX2,PosY2]),
            	 player(vert,NB3,[PosX3,PosY3]),
            	 player(jaune,NB4,[PosX4,PosY4])]
                ,SB,NP2),
    util_player(vert,NB3,[PosX3,PosY3],
                [player(bleu,NB1,[PosX1,PosY1]),
            	 player(rouge,NB2,[PosX2,PosY2]),
            	 player(vert,NB3,[PosX3,PosY3]),
            	 player(jaune,NB4,[PosX4,PosY4])]
                ,SB,NP3),
    util_player(jaune,NB4,[PosX4,PosY4],
                [player(bleu,NB1,[PosX1,PosY1]),
           	 	 player(rouge,NB2,[PosX2,PosY2]),
            	 player(vert,NB3,[PosX3,PosY3]),
            	 player(jaune,NB4,[PosX4,PosY4])]
                ,SB,NP4),!.

% Calcule l'utilité d'un état pour un joueur donné
util_player(C,_,POS,_,_,NP):-
    findall(P,final_pos(C,P),FPOS),
    member(POS,FPOS),
    NP is 1,!.
util_player(C,NB,POS,PP,SB,NP):-
    findall(P,final_pos(C,P),FPOS),
    not(member(POS,FPOS)),
    C1 = 11.38,% 1.12, % 1.12, % 9.82, % 19.64, % 29.46, % 39.28
    C2 = 1.54, % 1.54, % 1.54, % 1.375, % 1.15,% 1, % 0.74
    C3 = 2.45, % 4.16, % 1.04, % 3.75, % 3.75, % 3.75, % 4.16
    L = 6,
    W = 48,
    players_pos(PP,PPos),
    number_path([POS],FPOS,PPos,SB,[],NPCC,PATHS),
    first(PATHS,PCC),
    tail(PATHS,LPCC),
    sum_of_difference_path_length(PCC,LPCC,SODPF),
    list_elem_length(LPCC,LL),
    length(PCC,L1),
    number_bad_path(L1,LL,L,NBL),
    NNP is (NPCC - NBL) / (NPCC + NBL),
    LNP is SODPF / NPCC - L1 + W,
    BNP is NB,
    NP is (C1 * NNP + C2 * LNP + C3 * BNP) / 100,!.


/* --------------------------------------------------------------------- */
/*                                                                       */
/*                          SPECIAL STATES                               */
/*                                                                       */
/* --------------------------------------------------------------------- */

% Cet état ne sera pas nécessaire, il faudra le récupérer
/*etat_initial(
    [bleu,
    [[bleu,5,[5,9]],[rouge,5,[9,5]],[vert,5,[1,5]],[jaune,5,[5,1]],
    []
    ]).*/

% États final bleu
final_state_bleu(state(_,[player(bleu,_,[PosX,PosY]),_,_,_],_)):-
    PosY == 0,
    pos([PosX,PosY]).

% État final rouge
final_state_rouge(state(_,[_,player(rouge,_,[PosX,PosY]),_,_],_)):-
    PosY == 8,
    pos([PosX,PosY]).

% État final vert
final_state_vert(state(_,[_,_,player(vert,_,[PosX,PosY]),_],_)):-
    PosX == 0,
    pos([PosX,PosY]).

% État finale jaune    
final_state_jaune(state(_,[_,_,_,player(jaune,_,[PosX,PosY])],_)):-
    PosX == 8,
    pos([PosX,PosY]).

% Positions finales
final_pos(bleu,[PosX,PosY]):-
    PosY is 0,
    pos([PosX,PosY]).
final_pos(rouge,[PosX,PosY]):-
    PosY is 8,
    pos([PosX,PosY]).
final_pos(vert,[PosX,PosY]):-
    PosX is 0,
    pos([PosX,PosY]).
final_pos(jaune,[PosX,PosY]):-
    PosX is 8,
    pos([PosX,PosY]).

% États finaux
final_state(state(CC,[player(C,NB,[PosX,PosY]),P2,P3,P4],SB)):-
    state(CC,[player(C,NB,[PosX,PosY]),P2,P3,P4],SB),
    final_pos(C,[PosX,PosY]).
final_state(state(CC,[P1,player(C,NB,[PosX,PosY]),P3,P4],SB)):-
    state(CC,[P1,player(C,NB,[PosX,PosY]),P3,P4],SB),
    final_pos(C,[PosX,PosY]).
final_state(state(CC,[P1,P2,player(C,NB,[PosX,PosY]),P4],SB)):-
    state(CC,[P1,P2,player(C,NB,[PosX,PosY]),P4],SB),
    final_pos(C,[PosX,PosY]).
final_state(state(CC,[P1,P2,P3,player(C,NB,[PosX,PosY])],SB)):-
    state(CC,[P1,P2,P3,player(C,NB,[PosX,PosY])],SB),
    final_pos(C,[PosX,PosY]).

/* --------------------------------------------------------------------- */
/*                                                                       */
/*                                FAITS                                  */
/*                                                                       */
/* --------------------------------------------------------------------- */

% Game Parameters
game_size(9,9).

max_barriers(5).

% Components parameters
plan(horizontal).
plan(vertical).

color(bleu).
color(rouge).
color(vert).
color(jaune).

/* --------------------------------------------------------------------- */
/*                                                                       */
/*                        REGLES D'ESPACE D'ETAT                         */
/*                                                                       */
/* --------------------------------------------------------------------- */

/* Etat :- [CPlayer, 
            [
                Player #Barriers Position,
                Player, #Barriers Position,
                Player, #Barriers Position,
                Player, #Barriers Position
            ],
            [
                Position Plan,
                Position Plan,
                ...
            ]
            ]
*/

% Position structure
pos([X,Y]):- 
    game_size(U1,U2),
    Up is U1 - 1,
    Right is U2 - 1,
    between(0,Up,X),
    between(0,Right,Y).

% Number of barriers structure
n_barriers(N):-
    max_barriers(M),
    between(0,M,N).

% Barrier structure
barrier([PosX,PosY], Plan):-
    pos([PosX,PosY]),
    PosX < 8,
    PosY > 0,
    plan(Plan).

% Player structure
player(Color, B, Pos):-
    color(Color),
    n_barriers(B),
    pos(Pos).

% Set of barriers structure
set_barriers([]).
set_barriers([barrier(X,Y)|XS]):-
    barrier(X,Y),
    not(taken_place(X,XS)),
    not(collision(X,Y,XS)),
    set_barriers(XS).

% Liste of players structure
list_players([
             player(bleu,B1,P1),
             player(rouge,B2,P2),
             player(vert,B3,P3),
             player(jaune,B4,P4)
             ]):-
    player(bleu,B1,P1),
    player(rouge,B2,P2),
    player(vert,B3,P3),
    player(jaune,B4,P4),
    is_set([P1,P2,P3,P4]).

% State structure
state(CPlayer, LPlayer, SBarriers):-
    color(CPlayer),
    list_players(LPlayer),
    set_barriers(SBarriers),
    not(player_deadlock(LPlayer,SBarriers)).

% List of State structure ne sera pas utilisée, il n'y a donc pas besoin 
% de la définir

/* --------------------------------------------------------------------- */
/*                                                                       */
/*               REGLES DE CONSULTAION DE STRUCTURE                      */
/*                                                                       */
/* --------------------------------------------------------------------- */

% Renvoi la couleur du joueur courrant de state
current_player(state(C,_,_),C).

% Renvoie les positions des joueurs d'une liste de joueurs
players_pos([player(_,_,Pos1),
             player(_,_,Pos2),
             player(_,_,Pos3),
             player(_,_,Pos4)],[Pos1,Pos2,Pos3,Pos4]).

% Renvoie la position du joueur courrant d'une liste de joueurs
current_player_pos(bleu, [player(bleu,_,Pos),_,_,_],Pos).
current_player_pos(rouge, [_,player(rouge,_,Pos),_,_],Pos).
current_player_pos(vert, [_,_,player(vert,_,Pos),_],Pos).
current_player_pos(jaune, [_,_,_,player(jaune,_,Pos)],Pos).

% Renvoie le nombre de barrières restant du joueur courrant d'une liste de
% barrières
current_player_nb_barrier(bleu,[player(bleu,NB,_),_,_,_],NB).
current_player_nb_barrier(rouge,[_,player(rouge,NB,_),_,_],NB).
current_player_nb_barrier(vert,[_,_,player(vert,NB,_),_],NB).
current_player_nb_barrier(jaune,[_,_,_,player(jaune,NB,_)],NB).

% Renvoie l'utilité du vecteur d'un joueur donné
vector_color(bleu,[V1,_,_,_],V1).
vector_color(rouge,[_,V2,_,_],V2).
vector_color(vert,[_,_,V3,_],V3).
vector_color(jaune,[_,_,_,V4],V4).

% Renvoie un vecteur d'utilité des joueurs opposant d'un joueur donné
opp_vector(bleu,[_,V2,V3,V4],[V2,V3,V4]).
opp_vector(rouge,[V1,_,V3,V4],[V1,V3,V4]).
opp_vector(vert,[V1,V2,_,V4],[V1,V2,V4]).
opp_vector(jaune,[V1,V2,V3,_],[V1,V2,V3]).

/* --------------------------------------------------------------------- */
/*                                                                       */
/*                       REGLES FONCTIONNELLES                           */
/*                                                                       */
/* --------------------------------------------------------------------- */

% Types d'action possible
act(move).
act(drop).

% Génère une action de mouvement possible
move(state(C,LP,SB),[act(move),C,M]):-
    current_player_pos(C,LP,Pos),
    players_pos(LP,LPos),
    accessible(Pos,LPos,SB,[],LS),
    member(M,LS).

% Génère une action de pose de barrière possible
drop(state(C,LP,SB),[act(drop),C,TNB,[B|SB]]):-
    current_player_nb_barrier(C,LP,NB),
    NB > 0,
    pos(Pos),
    plan(P),
    B = barrier(Pos,P),
    set_barriers([B|SB]),
    TNB is NB - 1.

% Génère une action
action(state(C,LP,SB),Act):-
    move(state(C,LP,SB),Act).
action(state(C,LP,SB),Act):-
    drop(state(C,LP,SB),Act).

/* --------------------------------------------------------------------- */
/*                                                                       */
/*                       REGLES DE TRANSITION                            */
/*                                                                       */
/* --------------------------------------------------------------------- */

% Effectue une transition d'un état à un autre suite à une action de
% mouvement
trans_mouv(state(bleu,[player(bleu,NB,_),P2,P3,P4],SB),
           [act(move),bleu,M],
           state(rouge,[player(bleu,NB,M),P2,P3,P4],SB)).
trans_mouv(state(rouge,[P1,player(rouge,NB,_),P3,P4],SB),
           [act(move),rouge,M],
           state(vert,[P1,player(rouge,NB,M),P3,P4],SB)).
trans_mouv(state(vert,[P1,P2,player(vert,NB,_),P4],SB),
           [act(move),vert,M],
           state(jaune,[P1,P2,player(vert,NB,M),P4],SB)).
trans_mouv(state(jaune,[P1,P2,P3,player(jaune,NB,_)],SB),
           [act(move),jaune,M],
           state(bleu,[P1,P2,P3,player(jaune,NB,M)],SB)).

% Effectue une transition d'un état à un autre suite à une action de 
% pose de barrière
trans_drop(state(bleu,[player(bleu,_,Pos),P2,P3,P4],_),
           [act(drop),bleu,NB,TB],
           state(rouge,[player(bleu,NB,Pos),P2,P3,P4],TB)).
trans_drop(state(rouge,[P1,player(rouge,_,Pos),P3,P4],_),
           [act(drop),rouge,NB,TB],
           state(vert,[P1,player(rouge,NB,Pos),P3,P4],TB)).
trans_drop(state(vert,[P1,P2,player(vert,_,Pos),P4],_),
           [act(drop),vert,NB,TB],
           state(jaune,[P1,P2,player(vert,NB,Pos),P4],TB)).
trans_drop(state(jaune,[P1,P2,P3,player(jaune,_,Pos)],_),
           [act(drop),jaune,NB,TB],
           state(bleu,[P1,P2,P3,player(jaune,NB,Pos)],TB)).

% Effectue une de transition d'un état à un autre suite à une action
trans(IS,Act,FS):-
    trans_mouv(IS,Act,FS).
trans(IS,Act,FS):-
    trans_drop(IS,Act,FS).

/* --------------------------------------------------------------------- */
/*                                                                       */
/*                           REGLES DE JEU                               */
/*                                                                       */
/* --------------------------------------------------------------------- */

% Détermine le prochain joueur
next_player(bleu,rouge).
next_player(rouge,vert).
next_player(vert,jaune).
next_player(jaune,bleu).

/* --------------------------------------------------------------------- */
/*                                                                       */
/*                        REGLES AUXILIAIRES                             */
/*                                                                       */
/* --------------------------------------------------------------------- */

% Reference between variables
ref(_,_).

% Create a reference map between a list and a variable
% Ex : LS :- [1,2,3]   E :- 5                       
% REF :- [ref(1,5),ref(2,5),ref(3,5)]              
create_ref([],_,[]).
create_ref([X|XS],E,[ref(X,E)|REF]):-
    create_ref(XS,E,REF).

% Return the domain of a reference
ref_domain([ref(D,_)],[D]).
ref_domain([ref(D,_)|RS],[D|DOM]):-
    ref_domain(RS,DOM).

% Return the image of a reference
ref_image([ref(_,I)],[I]).
ref_image([ref(_,I)|RS],[I|IMA]):-
    ref_image(RS,IMA).

% Return a surjection of a list of references
ref_surjection([],[]).
ref_surjection([ref(D,I)],[ref(D,I)]).
ref_surjection([ref(D,_)|RS],REF):-
    ref_domain(RS,DOM),
    elem(D,DOM),
    ref_surjection(RS,REF).
ref_surjection([ref(D,I)|RS],[ref(D,I)|REF]):-
    ref_domain(RS,DOM),
    not(elem(D,DOM)),
    ref_surjection(RS,REF).

% Renvoi le premier élément d'une liste
first([X|_],X).

% Renvoi le dernier élément d'une liste
last([X],X).
last([_|XS],H):-
    last(XS,H).

% Renvoie la queue d'une liste
tail([_|XS],XS).

% Check if a list is empty
empty_list([]).

% Check if a list is a set
is_set([]).
is_set([X|XS]):-not(elem(X,XS)),is_set(XS).

% Check if an element is part of a list
elem(E,[E|_]).
elem(E,[H|XS]):-
    E \= H,
    elem(E,XS).

% Renvoie le maximum de deux éléments
max_v(V1,V2,V1):-
    V1 >= V2.
max_v(V1,V2,V2):-
    V1 < V2.

% Renvoie l'élément maximum d'une liste
max_l([X1,X2],X1):-
    X1 >= X2.
max_l([X1,X2],X2):-
    X1 < X2.
max_l([X|XS],X):-
    max_l(XS,TX),
    X >= TX.
max_l([X|XS],TX):-
    max_l(XS,TX),
    X < TX.

% Crée une liste contenant la longueur des éléments
% de la liste passée en argument
list_elem_length([],[]).
list_elem_length([X|XS],[L|LL]):-
    length(X,L),
    list_elem_length(XS,LL).

% Check if a barrier position is already taken
taken_place(X,[barrier(X,_)]).
taken_place(X,[barrier(X,_)|_]).
taken_place(X,[barrier(H,_)|XS]):-
    X \= H,
    taken_place(X,XS).

% Check if a barrier's carcteristics collides another
collision([PosX,PosY],P,[barrier(Pos,P)]):-
    P == vertical,
    v_zone([PosX,PosY],Pos).  
collision([PosX,PosY],P,[barrier(Pos,P)]):-
    P == horizontal,
    h_zone([PosX,PosY],Pos).    
collision([PosX,PosY],P,[barrier(Pos,P)|_]):-
    P == vertical,
    v_zone([PosX,PosY],Pos). 
collision([PosX,PosY],P,[barrier(Pos,P)|_]):-
    P == horizontal,
    h_zone([PosX,PosY],Pos).  
collision([PosX,PosY],P,[barrier(_,H)|XS]):-
    P \= H,
    collision([PosX,PosY],P,XS).

% Define vertical zone of blast for a barrier
v_zone([X1,Y1],[X2,Y2]):-
    X1 == X2,
    Y1 is Y2 + 1.
v_zone([X1,Y1],[X2,Y2]):-
    X1 == X2,
    Y1 is Y2 - 1.

% Define horizontal zone of blast for a barrier
h_zone([X1,Y1],[X2,Y2]):-
    Y1 == Y2,
    X1 is X2 + 1.
h_zone([X1,Y1],[X2,Y2]):-
    Y1 == Y2,
    X1 is X2 - 1. 

% Generate a list of every adjacent place from another
adjacent([PosX,PosY],LS):-
    not(border([PosX,PosY],_)),
    not(corner([PosX,PosY],_)),
    Right is PosX+1,
    Left is PosX-1,
    Up is PosY+1,
    Down is PosY-1,
    LS = [[Right,PosY],[PosX,Up],[Left,PosY],[PosX,Down]].
adjacent([PosX,PosY],LS):-
    border([PosX,PosY],left),
    Right is PosX+1,
    Up is PosY+1,
    Down is PosY-1,
    LS = [[Right,PosY],[PosX,Up],[PosX,Down]].
adjacent([PosX,PosY],LS):-
    border([PosX,PosY],right),
    Left is PosX-1,
    Up is PosY+1,
    Down is PosY-1,
    LS = [[PosX,Up],[Left,PosY],[PosX,Down]].
adjacent([PosX,PosY],LS):-
    border([PosX,PosY],up),
    Right is PosX+1,
    Left is PosX-1,
    Down is PosY-1,
    LS = [[Right,PosY],[Left,PosY],[PosX,Down]].
adjacent([PosX,PosY],LS):-
    border([PosX,PosY],down),
    Right is PosX+1,
    Left is PosX-1,
    Up is PosY+1,
    LS = [[Right,PosY],[PosX,Up],[Left,PosY]].
adjacent([PosX,PosY],LS):-
    corner([PosX,PosY],down_left),
    Right is PosX+1,
    Up is PosY+1,
    LS = [[Right,PosY],[PosX,Up]].
adjacent([PosX,PosY],LS):-
    corner([PosX,PosY],up_left),
    Right is PosX+1,
    Down is PosY-1,
    LS = [[Right,PosY],[PosX,Down]].
adjacent([PosX,PosY],LS):-
    corner([PosX,PosY],down_right),
    Left is PosX-1,
    Up is PosY+1,
    LS = [[PosX,Up],[Left,PosY]].
adjacent([PosX,PosY],LS):-
    corner([PosX,PosY],up_right),
    Left is PosX-1,
    Down is PosY-1,
    LS = [[Left,PosY],[PosX,Down]].

% Check if a case is a border
border([PosX,PosY], left):-
    not(corner([PosX,PosY],_)),
    PosX == 0.
border([PosX,PosY], right):-
    not(corner([PosX,PosY],_)),
    PosX == 8.
border([PosX,PosY], down):-
    not(corner([PosX,PosY],_)),
    PosY == 0.
border([PosX,PosY], up):-
    not(corner([PosX,PosY],_)),
    PosY == 8.

% Check if a case is a corner
corner([PosX,PosY], down_left):-
    PosX == 0,
    PosY == 0.
corner([PosX,PosY], up_left):-
    PosX == 0,
    PosY == 8.
corner([PosX,PosY], down_right):-
    PosX == 8,
    PosY == 0.
corner([PosX,PosY], up_right):-
    PosX == 8,
    PosY == 8.

/* Generate a list of all accessible place from a place */
accessible([PosX,PosY], PP, B, BAN, LS):-
    set_barriers(B),
    adjacent([PosX,PosY],KS),
    intersection(KS,BAN,OS),
    subtract(KS,OS,PS),
    filter_move([PosX,PosY], PS, B, MS),
    expend_move([PosX,PosY], MS, PP, B, NS),
    intersection(NS,BAN,QS),
    subtract(NS,QS,RS),
    list_to_set(RS,LS),
    not(empty_list(LS)),!.

% Filtre en retirant les mouvements en direction de positions bloquées
filter_move(_, [], _, []).
filter_move([PosX,PosY], [X|XS], B, LS):-
    crowded([PosX,PosY], X, B),
    filter_move([PosX,PosY], XS, B, LS).
filter_move([PosX,PosY], [X|XS], B, [X|LS]):-
    not(crowded([PosX,PosY], X, B)),
    filter_move([PosX,PosY], XS, B, LS).

% Regardes si une barrière empêche le passage entre deux positions
crowded([PosX,PosY], [X,Y], B):-
    PosX == X,
    TempY is Y - 1,
    PosY == TempY, 
    elem(barrier([X,Y],horizontal),B).
crowded([PosX,PosY], [X,Y], B):-
    PosX == X,
    TempY is Y - 1,
    PosY == TempY,
    CrowdedX is X - 1, 
    elem(barrier([CrowdedX,Y],horizontal),B).
crowded([PosX,PosY], [X,Y], B):-
    PosX == X,
    TempY is Y + 1,
    PosY == TempY,
    elem(barrier([PosX,PosY],horizontal),B).
crowded([PosX,PosY], [X,Y], B):-
    PosX == X,
    TempY is Y + 1,
    PosY == TempY,
    CrowdedX is X - 1,
    elem(barrier([CrowdedX,PosY],horizontal),B).
crowded([PosX,PosY], [X,Y], B):-
    PosY == Y,
    TempX is X - 1,
    PosX == TempX,
    elem(barrier([PosX,PosY],vertical),B).
crowded([PosX,PosY], [X,Y], B):-
    PosY == Y,
    TempX is X - 1,
    PosX == TempX,
    CrowdedY is Y + 1,
    elem(barrier([PosX,CrowdedY],vertical),B).
crowded([PosX,PosY], [X,Y], B):-
    PosY == Y,
    TempX is X + 1,
    PosX == TempX,
    elem(barrier([X,Y],vertical),B).
crowded([PosX,PosY], [X,Y], B):-
    PosY == Y,
    TempX is X + 1,
    PosX == TempX,
    CrowdedY is Y + 1,
    elem(barrier([X,CrowdedY],vertical),B).

% Ajoute aux positions accessibles la dimention de saute mouton
expend_move(_,[],_,_,[]).
expend_move([IX,IY],[[PosX,PosY]|XS], PS, B, [[PosX,PosY]|LS]):-
    not(elem([PosX,PosY],PS)),
    expend_move([IX,IY],XS,PS,B,LS).
expend_move([IX,IY],[[PosX,PosY]|XS], PS, B, [FPos|LS]):-
    elem([PosX,PosY],PS),
    free_forward([IX,IY],[PosX,PosY],PS,B,FPos),
    expend_move([IX,IY],XS,PS,B,LS).
expend_move([IX,IY],[[PosX,PosY]|XS], PS, B, [FPos1, FPos2|LS]):-
    elem([PosX,PosY],PS),
    not(free_forward([IX,IY],[PosX,PosY],PS,B,_)),
    free_ldiagonale([IX,IY],[PosX,PosY],PS,B,FPos1),
    free_rdiagonale([IX,IY],[PosX,PosY],PS,B,FPos2),
    expend_move([IX,IY],XS,PS,B,LS).
expend_move([IX,IY],[[PosX,PosY]|XS], PS, B, [FPos2|LS]):-
    elem([PosX,PosY],PS),
    not(free_forward([IX,IY],[PosX,PosY],PS,B,_)),
    not(free_ldiagonale([IX,IY],[PosX,PosY],PS,B,_)),
    free_rdiagonale([IX,IY],[PosX,PosY],PS,B,FPos2),
    expend_move([IX,IY],XS,PS,B,LS).
expend_move([IX,IY],[[PosX,PosY]|XS], PS, B, [FPos1|LS]):-
    elem([PosX,PosY],PS),
    not(free_forward([IX,IY],[PosX,PosY],PS,B,_)),
    free_ldiagonale([IX,IY],[PosX,PosY],PS,B,FPos1),
    not(free_rdiagonale([IX,IY],[PosX,PosY],PS,B,_)),
    expend_move([IX,IY],XS,PS,B,LS).
expend_move([IX,IY],[[PosX,PosY]|XS], PS, B, LS):-
    elem([PosX,PosY],PS),
    not(free_forward([IX,IY],[PosX,PosY],PS,B,_)),
    not(free_ldiagonale([IX,IY],[PosX,PosY],PS,B,_)),
    not(free_rdiagonale([IX,IY],[PosX,PosY],PS,B,_)),
    expend_move([IX,IY],XS,PS,B,LS).

% Regarde si la diagonale droite d'une position est libre et renvoi sa 
% position
free_rdiagonale([IX,IY],[PosX,PosY],PS,B, [JumpPosX1,JumpPosY1]):-
    JumpPosX1 is PosX + IY - PosY,
    JumpPosY1 is PosY + IX - PosX,
    game_size(M,N),
    JumpPosX1 < M,
    JumpPosX1 >= 0,
    JumpPosY1 < N,
    JumpPosY1 >= 0,
	not(crowded([PosX,PosY], [JumpPosX1,JumpPosY1], B)),
	not(elem([JumpPosX1,JumpPosY1],PS)).

% Regarde si la diagonale gauche d'une position est libre et renvoi sa 
% position
free_ldiagonale([IX,IY],[PosX,PosY],PS,B, [JumpPosX2,JumpPosY2]):-
	JumpPosX2 is PosX - IY + PosY,
    JumpPosY2 is PosY - IX + PosX,
    game_size(M,N),
    JumpPosX2 < M,
    JumpPosX2 >= 0,
    JumpPosY2 < N,
    JumpPosY2 >= 0,
    not(crowded([PosX,PosY], [JumpPosX2,JumpPosY2], B)),
    not(elem([JumpPosX2,JumpPosY2],PS)).

% Regarde si deux positions en avant d'une position est libre et renvoi sa 
% position
free_forward([IX,IY],[PosX,PosY],PS,B,[JumpPosX,JumpPosY]):-
    JumpPosX is IX - (2 * (IX - PosX)),
    JumpPosY is IY - (2 * (IY - PosY)),
    game_size(M,N),
    JumpPosX < M,
    JumpPosX >= 0,
    JumpPosY < N,
    JumpPosY >= 0,
    not(crowded([PosX,PosY], [JumpPosX,JumpPosY], B)),
    not(elem([JumpPosX,JumpPosY],PS)).

% Revoi l'ensemble des successeurs de l'ensemble des positions passées en
% argument ainsi que le mapping entre prédécesseur et successeur
successeur([],_,_,F,_,[],F,[]).
successeur([O|OS],PP,B,F,BAN,OF,FFF,PAR):-
    elem(O,BAN),
    successeur(OS,PP,B,[O|F],BAN,OF,FFF,PAR).
successeur([O|OS],PP,B,F,BAN,OF,FFF,PAR):-
    not(elem(O,BAN)),
    accessible(O,PP,B,BAN,CF),
    union([O|OS],F,FERMETURE),
    subtract(CF,FERMETURE,DF),
    create_ref(DF,O,CPAR),
    successeur(OS,PP,B,[O|F],BAN,TOF,FFF,TPAR),
    union(DF,TOF,COF),
    subtract(COF,[O|OS],OF),
    union(CPAR,TPAR,DPAR),
    ref_surjection(DPAR,PAR).

% Retrouve le noeud père d'un fils grâce à la liste des références
find_parent(C,[ref(C,P)|_],P).
find_parent(C,[ref(H,_)|PARS],T):-
    H \= C,
    find_parent(C,PARS,T).

/* Calcule le plus court chemin entre un ensemble de positions et un autre 
 ensemble de positions (selon les mouvements autorisés par le jeu)
 REM : Pour calculer les second plus courts chemin et ainsi de suite,
 il faut retirer '!' dans le cas de base. /!\ le calcul prendre plus de
 temps                                                                      */
 shortest_path(_,Oi,Of,_,_,_,_,_,[P]):-
    intersection(Oi,Of,I),
    first(I,P),!.
shortest_path(true,Oi,Of,Fi,Ff,PP,B,BAN,[P|PATH]):-
    successeur(Oi,PP,B,Fi,BAN,OFi,FFi,PAR),
    not(empty_list(OFi)),
    shortest_path(false,OFi,Of,FFi,Ff,PP,B,BAN,PATH),
    first(PATH,LINK),
    find_parent(LINK,PAR,P),!.
shortest_path(false,Oi,Of,Fi,Ff,PP,B,BAN,PATHP):-
    successeur(Of,PP,B,Ff,BAN,OFf,FFf,PAR),
    not(empty_list(OFf)),
    shortest_path(true,Oi,OFf,Fi,FFf,PP,B,BAN,PATH),
    last(PATH,LINK),
    last(PATH,LINK),
    find_parent(LINK,PAR,P),
    append(PATH,[P],PATHP),!.

% Vérifie qu'une disposition de joueurs et de barrières ne crée pas un deadlock
player_deadlock([player(bleu,_,Pos1),
                 player(rouge,_,Pos2),
                 player(vert,_,Pos3),
                 player(jaune,_,Pos4)
                 ],SB):-
    findall(P1,final_pos(bleu,P1),PS1),
    not(shortest_path(true,[Pos1],PS1,[],[],[Pos1,Pos2,Pos3,Pos4],SB,[],_)).
player_deadlock([player(bleu,_,Pos1),
                 player(rouge,_,Pos2),
                 player(vert,_,Pos3),
                 player(jaune,_,Pos4)
                 ],SB):-
    findall(P2,final_pos(rouge,P2),PS2),
    not(shortest_path(true,[Pos2],PS2,[],[],[Pos1,Pos2,Pos3,Pos4],SB,[],_)).
player_deadlock([player(bleu,_,Pos1),
                 player(rouge,_,Pos2),
                 player(vert,_,Pos3),
                 player(jaune,_,Pos4)
                 ],SB):-
    findall(P3,final_pos(vert,P3),PS3),
    not(shortest_path(true,[Pos3],PS3,[],[],[Pos1,Pos2,Pos3,Pos4],SB,[],_)).
player_deadlock([player(bleu,_,Pos1),
                 player(rouge,_,Pos2),
                 player(vert,_,Pos3),
                 player(jaune,_,Pos4)
                 ],SB):-
    findall(P4,final_pos(jaune,P4),PS4),
    not(shortest_path(true,[Pos4],PS4,[],[],[Pos1,Pos2,Pos3,Pos4],SB,[],_)).

% Renvoie le nombre de plus court chemins vers une destination 
% en partant d'une position
number_path(Oi,Of,PP,B,BAN,0,[]):-
    not(shortest_path(true,Oi,Of,[],[],PP,B,BAN,_)).
number_path(Oi,Of,PP,B,BAN,N,[PATH|P]):-
    shortest_path(true,Oi,Of,[],[],PP,B,BAN,PATH),
    tail(PATH,ENDPATH),
    union(BAN,ENDPATH,TBAN),
    number_path(Oi,Of,PP,B,TBAN,M,P),
    N is M + 1.

% Calcule le nombre de mauvais chemins dans une liste de
% plus courts chemins
number_bad_path(_,[],_,0).
number_bad_path(L,[X|XS],C,N):-
    BAD is L + C,
    BAD < X,
    number_bad_path(L,XS,C,M),
    N is M + 1.
number_bad_path(L,[X|XS],C,N):-
    BAD is L + C,
    BAD >= X,
    number_bad_path(L,XS,C,N).

% Calcule la somme de la différence de longueur entre le plus
% court chemin et les autres
sum_of_difference_path_length(_,[],0).
sum_of_difference_path_length(PCC,[X|XS],N):-
    length(PCC,L1),
    length(X,L2),
    sum_of_difference_path_length(PCC,XS,M),
    N is M + L2 - L1.

% Transforme un état en une liste d'états en lui appliquant 
% une liste d'actions
from_laction_to_lstate(_,[],[]).
from_laction_to_lstate(STATE,[X|XS],[T|LT]):-
    trans(STATE,X,T),
    from_laction_to_lstate(STATE,XS,LT).

% Choisit le vecteur qui avantage un joueur donné lorsque son score
% dépasse la moyenne des autres
greater_than_average(IA_COLOR,[V11,V21,V31,V41],[V12,V22,V32,V42],first):-
    vector_color(IA_COLOR,[V11,V21,V31,V41],V1),
    vector_color(IA_COLOR,[V12,V22,V32,V42],V2),
    max_v(V1,V2,V),
    V == V1,
    AVR is (V11 + V21 + V31 + V41)/4,
	V > AVR.
greater_than_average(IA_COLOR,[V11,V21,V31,V41],[V12,V22,V32,V42],second):-
    vector_color(IA_COLOR,[V11,V21,V31,V41],V1),
    vector_color(IA_COLOR,[V12,V22,V32,V42],V2),
    max_v(V1,V2,V),
    V == V2,
    AVR is (V12 + V22 + V32 + V42)/4,
	V > AVR.

% Choisit le vecteur qui désavantage un adversaire
% qui prends trop d'avance
greater_than_avg_diff_opp(O1,O2,O3,O4,O5,O6,AVG1,_,first):-
    max_l([O1,O2,O3],OM1),
	max_l([O4,O5,O6],OM2),
    OM1 =< OM2,
    AVG_DIFF1 is O1 - AVG1,
    abs(AVG_DIFF1,ABS1),
    AVG_DIFF2 is O2 - AVG1,
    abs(AVG_DIFF2,ABS2),
    AVG_DIFF3 is O3 - AVG1,
    abs(AVG_DIFF3,ABS3),
    AVG_DIFFT is (ABS1 + ABS2 + ABS3) / 3,
    MAX_DIFF is OM1 - AVG1,
    MAX_DIFF >= AVG_DIFFT.
greater_than_avg_diff_opp(O1,O2,O3,O4,O5,O6,_,AVG2,second):-
    max_l([O1,O2,O3],OM1),
	max_l([O4,O5,O6],OM2),
    OM1 > OM2,
    AVG_DIFF4 is O4 - AVG2,
    abs(AVG_DIFF4,ABS4),
    AVG_DIFF5 is O5 - AVG2,
    abs(AVG_DIFF5,ABS5),
    AVG_DIFF6 is O6 - AVG2,
    abs(AVG_DIFF6,ABS6),
    AVG_DIFFT is (ABS4 + ABS5 + ABS6) / 3,
    MAX_DIFF is OM2 - AVG2,
    MAX_DIFF >= AVG_DIFFT.

% Choisit le vecteur qui désavantage au plus tous les autres joueurs
% si aucun d'eux n'a trop d'avance
lower_than_avg_diff_opp(O1,O2,O3,O4,O5,O6,AVG1,AVG2,first):-
    max_l([O1,O2,O3],OM1),
	max_l([O4,O5,O6],OM2),
    OM1 =< OM2,
    AVG_DIFF1 is O1 - AVG1,
    abs(AVG_DIFF1,ABS1),
    AVG_DIFF2 is O2 - AVG1,
    abs(AVG_DIFF2,ABS2),
    AVG_DIFF3 is O3 - AVG1,
    abs(AVG_DIFF3,ABS3),
    AVG_DIFFT is (ABS1 + ABS2 + ABS3) / 3,
    MAX_DIFF is OM1 - AVG1,
    MAX_DIFF < AVG_DIFFT,
    AVG1 =< AVG2.
lower_than_avg_diff_opp(O1,O2,O3,O4,O5,O6,AVG1,AVG2,second):-
    max_l([O1,O2,O3],OM1),
	max_l([O4,O5,O6],OM2),
    OM1 > OM2,
    AVG_DIFF4 is O4 - AVG2,
    abs(AVG_DIFF4,ABS4),
    AVG_DIFF5 is O5 - AVG2,
    abs(AVG_DIFF5,ABS5),
    AVG_DIFF6 is O6 - AVG2,
    abs(AVG_DIFF6,ABS6),
    AVG_DIFFT is (ABS4 + ABS5 + ABS6) / 3,
    MAX_DIFF is OM2 - AVG2,
    MAX_DIFF < AVG_DIFFT,
    AVG1 > AVG2.

/* --------------------------------------------------------------------- */
/*                                                                       */
/*                            TEST DE FIN                                */
/*                                                                       */
/* --------------------------------------------------------------------- */

/* NOT CHECKED */
fin(C_State) :- final_state(C_State).

/* --------------------------------------------------------------------- */
/*                                                                       */
/*                         BOUCLE PRINCIPALE                             */
/*                                                                       */
/* --------------------------------------------------------------------- */

/* NOT CHECKED */
quoridor_ia:-

    repeat,
        strat(C_State, N_action).
        /* Rajouter le lien à l'interface web et attendre la réponse */
    fin(C_State), !.

/* --------------------------------------------------------------------- */
/*                                                                       */
/*             ACTIVATION DU PROGRAMME APRES COMPILATION                 */
/*                                                                       */
/* --------------------------------------------------------------------- */

/* NOT CHECKED */
:- quoridor_ia.