/*
 * INF6120
 * A2023
 * TP2
 * First name     : Keven Jude
 * Last name      : Anténor
 * Permanent code : ANTK08129004
*/
:- discontiguous generate_word/2.

/* Affiche le mot en sorti entré */
print_word(word([])) :- write('e'), !.
print_word(word(L)) :- atomic_list_concat(L, ' ', A), write(A).

/* Affiche les mots de la liste*/
print_word_list([]).
print_word_list([H]) :- print_word(H), nl, !.
print_word_list([H|T]) :- print_word(H), write(','), nl, print_word_list(T).

/* Affiche les deux mots de la règle*/
print_rule(rule(W1, W2)) :- print_word(W1), write('->'), print_word(W2).

/* Affiche toutes les rules de la liste*/
print_rule_set(rule_set([H|T])) :- print_rule(H), nl, print_rule_set_2(T).
print_rule_set_2([]).
print_rule_set_2([H|T]) :- print_rule(H),nl, print_rule_set_2(T).

/*Affiiche le mot et règle du le puzzle */
print_puzzle(puzzle(R, W)) :-
    print_rule_set(R), write('Word:'), nl, print_word(W).

/* Affiche le chemin d'un mot à l'autre */
print_path(path([])) :- !.
print_path(path([H])) :- print_word(H), !.
print_path(path([H|T])) :- print_word(H), write(' => '), print_path(path(T)).

/* Affiche la liste des chemins */
print_path_list([]).
print_path_list([H|T]) :- print_path(H), nl, print_path_list(T).

/* Concatene les mots */
word_concatenation(word(W1), word(W2), word(W3)) :-
    append(W1, W2, W3).


/* Réécrit le préfix d'un mot avec la règle donnné */
rewrite_prefix_by_rule(rule(word(W1), word(W2)), word(W3), word(W4)) :- fail.
rewrite_factor_by_rule(rule(word(W1), word(W2)), word(W3), word(W4)) :-
    word_concatenation(P, S, word(W3)), word_concatenation(word(W1), R, S), 
    word_concatenation(P, word(W2), T), word_concatenation(T, R, word(W4)).

/* Réécrit un mot à l'aide de ensemble de règle */
rewrite(rule_set([]), _, _) :- fail.
rewrite(rule_set([R|RS]), W1, W2) :-
    (rewrite_factor_by_rule(R, W1, W2); rewrite(rule_set(RS), W1, W2)).


/* Donné les chemins d'une certaine longue */
connecting_path(_, 0, W1, path([W1]), W1).
connecting_path(R, L, W1, path([W1|P]), W3) :-
    L > 0, rewrite(R, W1, W2), L1 is L - 1,
    connecting_path(R, L1, W2, path(P), W3).

/* Touver le chemin entre le mot donné et le mot vide */
puzzle_solution(puzzle(R, W1), L, S) :-
    connecting_path(R, L, W1, S, W2),
    W2 = word([]).

/* Affiche toutes les solutions du puzzles*/
all_puzzle_solutions(puzzle(R, W1), L, SS) :-
    findall(S, puzzle_solution(puzzle(R, W1), L, S), SS1),
    sort(SS1, SS).

/* Inversion des mots d'une règles */
rule_reversion(rule(word(W1), word(W2)), rule(word(W2), word(W1))).

/* Trouve tout les mots magiques */
magic_word_of_rule_set(_, 0, W, W) :- !.
magic_word_of_rule_set(R, L, W, RS) :-
    L > 0, 
    L1 is L - 1,
    maplist(rule_reversion, R, R1),
    rewrite(rule_set(R1), W, W1),
    magic_word_of_rule_set(R, L1, W1, RS).

magic_word_of_rule_set(rule_set(R), L, W) :- magic_word_of_rule_set(R, L, word([]), W).

/* Produire la liste des mots magiques */
all_magic_words_of_rule_set(R, L, M) :-
    findall(W, magic_word_of_rule_set(R, L, W), M1), sort(M1, M).