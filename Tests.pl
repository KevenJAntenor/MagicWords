/*
 * INF6120
 * A2023
 * TP2
 * First name     : Keven Jude
 * Last name      : Anténor
 * Permanent code : ANTK08129004
*/


% Importation of the content of MagicWords.pl.
:- consult('MagicWords.pl').


/******************************************************************************************/
/* Definitions of rules.                                                                  */
/******************************************************************************************/
rule_1(rule(word([1, 1]), word([1]))).
rule_2(rule(word([1, 2]), word([2, 1, 2]))).
rule_3(rule(word([2, 1]), word([]))).
rule_4(rule(word([1, 1]), word([]))).
rule_5(rule(word([2, 2]), word([]))).
rule_6(rule(word([3, 3]), word([]))).
rule_7(rule(word([1, 3]), word([3, 1]))).
rule_8(rule(word([1, 2, 1]), word([2, 1, 2]))).
rule_9(rule(word([2, 3, 2]), word([3, 2, 3]))).
rule_10(rule(word([2, 1]), word([1, 2]))).
rule_11(rule(word([1, 1, 2]), word([2, 2, 1]))).
rule_12(rule(word([1, 1, 1]), word([]))).
rule_13(rule(word([2, 2, 2]), word([]))).


/******************************************************************************************/
/* Definitions of sets of rules.                                                          */
/******************************************************************************************/
rule_set_123(rule_set([_rule_1, _rule_2, _rule_3])) :-
    rule_1(_rule_1),
    rule_2(_rule_2),
    rule_3(_rule_3).

rule_set_456789(rule_set([_rule_4, _rule_5, _rule_6, _rule_7, _rule_8, _rule_9])) :-
    rule_4(_rule_4),
    rule_5(_rule_5),
    rule_6(_rule_6),
    rule_7(_rule_7),
    rule_8(_rule_8),
    rule_9(_rule_9).

rule_set_10_11_12_13(rule_set([_rule_10, _rule_11, _rule_12, _rule_13])) :-
    rule_10(_rule_10),
    rule_11(_rule_11),
    rule_12(_rule_12),
    rule_13(_rule_13).

puzzle_2(puzzle(_rule_set, word([3, 2, 2, 1, 3, 2, 2, 3, 1, 3]))) :-
    rule_set_456789(_rule_set).

puzzle_3(puzzle(_rule_set, word([2, 2, 2, 2, 1, 1, 2, 2, 1, 1, 1, 2, 1, 2, 2]))) :-
    rule_set_10_11_12_13(_rule_set).


/******************************************************************************************/
/* Definitions of puzzles.                                                                */
/******************************************************************************************/
puzzle_1(puzzle(_rule_set, word([1, 2, 1, 1]))) :-
    rule_set_123(_rule_set).


/******************************************************************************************/
/* Definitions of testing predicates.                                                     */
/******************************************************************************************/
test_1 :-
    puzzle_1(_puzzle),
    _len is 4,
    write("Puzzle:\n"),
    print_puzzle(_puzzle),
    nl,
    format("Solutions of length ~d:\n", [_len]),
    all_puzzle_solutions(_puzzle, _len, _solutions),
    print_path_list(_solutions).

test_2 :-
    rule_set_123(_rule_set),
    _len is 3,
    write("Rule set:\n"),
    print_rule_set(_rule_set),
    format("Magic words having solutions of length ~d:\n", [_len]),
    all_magic_words_of_rule_set(_rule_set, _len, _magic_words),
    print_word_list(_magic_words).

