# TP2 - Mots magiques
L'objectif de ce TP est d'implanter en `Prolog` à la fois un résolveur et un générateur de
problèmes dans le cadre du casse-tête combinatoire des _mots magiques_.

## Informations pratiques
Il se peut que dans le document présent visualisé sous `GitLab`, l'affichage de certains
symboles mathématiques soit sensible au navigateur internet utilisé. Se référer à la
**version `pdf` de ce document** le cas échéant.

Le TP est à rendre pour le **mardi 12 décembre 2023** avant 23 h 59.


### Fichiers constitutifs du TP
+ `README.md` --- Le sujet du TP.
+ `README.pdf` --- La version `pdf` du sujet.
+ `MagicWords.pl` --- Le fichier `Prolog` squelette à compléter.
+ `Tests.pl` --- Le fichier `Prolog` contenant des tests. Ce fichier importe
  `MagicWords.pl`.


### Historique des modifications
+ 2023-11-14 --- Publication du sujet.


## Définitions
Un _mot_ est une suite finie d'entiers strictement positifs comme par exemple $(1, 2, 1, 3,
2)$. Nous noterons ici de manière plus concise les mots en juxtaposant simplement leurs
lettres. Ainsi, le mot précédent se note $12132$. Le _mot vide_, qui est le seul mot de
longueur $0$, est noté $\epsilon$. Un _facteur_ d'un mot $w$ est un mot $w'$ tel qu'il
existe deux mots $v_1$ et $v_2$ vérifiant $w = v_1 w' v_2$. Lorsque $v_1 = \epsilon$, le
facteur $w'$ est un _préfixe_ de $w$. Par exemple, les mots $213$ et $32$ sont des facteurs
de $12132$. Les mots $\epsilon$, $12$ et $121$ sont des préfixes de $12132$.

Une _règle de réécriture_ est un couple $r = (u_1, u_2)$ de mots. Un mot $v_1$ se _réécrit
par $r$_ en un mot $v_2$ si $v_1 = w_1 u_1 w_2$ et $v_2 = w_1 u_2 w_2$ où $w_1$ et $w_2$
sont des mots. Cette propriété est notée $v_1 \Rightarrow_r v_2$. En d'autres termes, $v_1
\Rightarrow_r v_2$ s'il existe un facteur $u_1$ de $v_1$, qui, en le remplaçant par $u_2$,
donne le mot $v_2$. Par exemple, en posant $r = (12, 212)$, nous avons

> $3\mathbf{12}312 \Rightarrow_r 3\mathbf{212}312$

et

> $3123\mathbf{12} \Rightarrow_r 3123\mathbf{212}$.

Si $R$ est un ensemble de règles de réécriture, nous notons par $v_1 \Rightarrow_R v_2$ le
fait qu'il existe une règle de réécriture $r \in R$ telle que $v_1 \Rightarrow_r v_2$.

Étant donné un ensemble $R$ de règles de réécriture, un mot $w$ est _$R$-magique_ s'il
existe un entier $\ell$ et une suite de mots $s = (w_0, w_1, \dots, w_\ell)$ telle que

+ $w_0 = w$,
+ pour tout $i \in \{1, \dots, \ell\}$, $w_{i - 1} \Rightarrow_R w_i$,
+ $w_\ell = \epsilon$.

En d'autres termes, ceci signifie qu'il est possible d'effacer totalement le mot $w$ en lui
appliquant successivement des réécritures qui proviennent de règles de réécriture de $R$.

La suite $s$ de mots est un _témoin_ du fait que $w$ est $R$-magique et l'entier $\ell$ est
la _longueur_ du témoin $s$.

Par exemple, soit $R = \{r_1, r_2, r_3\}$ avec

+ $r_1 = (11, 1)$,
+ $r_2 = (12, 212)$,
+ $r_3 = (21, \epsilon)$.

Nous avons

> $1211 \Rightarrow_R 121 \Rightarrow_R 2121 \Rightarrow_R 21 \Rightarrow_R \epsilon$.

Ceci montre que le mot $w = 1211$ est $R$-magique. La longueur de ce témoin est
$4$. Remarquons qu'il existe d'autres témoins du fait que $w$ est $R$-magique. Nous avons
ainsi par exemple

> $1211 \Rightarrow_R 21211 \Rightarrow_R 211 \Rightarrow_R 21 \Rightarrow_R \epsilon$

en longueur $4$ également et

> $1211 \Rightarrow_R 21211 \Rightarrow_R 221211 \Rightarrow_R 2211 \Rightarrow_R 21 \Rightarrow_R \epsilon$

en longueur $5$.

Un mot $R$-magique est _parfait_ quand il admet un unique témoin.


## Description du casse-tête
Une _instance du casse-tête du mot magique_ est spécifiée par un couple $(R, w)$ où $R$ est
un ensemble de règles de réécriture et $w$ est un mot $R$-magique. Une _solution_ de $(R,
w)$ est un témoin du fait que $w$ est $R$-magique.


## Programmation
Décrivons maintenant le travail attendu. Les choix principaux d'implantation vont aussi être
précisés. Les prédicats les plus importants à implanter vont être décrits.


### Objectifs
Le but du TP est double :

1. implanter un **résolveur** du casse-tête du mot magique. Il doit pouvoir calculer toutes
   les solutions d'une longueur donnée pour une instance du casse-tête ;

2. implanter un **générateur d'instances du casse-tête**. Il doit pouvoir engendrer, sur
   l'entrée d'un ensemble $R$ de règles de réécriture et d'un entier $\ell$, un mot
   $R$-magique dont la solution est de longueur $\ell$.


### Termes principaux
Voici les spécifications d'implantation afférentes aux divers structures de données qui
apparaissent dans ce TP.

+ Un **mot** est représenté par un terme `word(LST)` où `LST` est la liste d'entiers
  spécifiant les lettres du mot. Par exemple
  ```prolog
      word([1, 2, 1, 1])
  ```
  est un terme qui représente le mot $1211$.

+ Une **règle de réécriture** est représentée par un terme `rule(W1, W2)` où `W1` et `W2`
  sont les mots qui forment les deux membres de la règle. Par exemple,
  ```prolog
      rule(word([1, 2]), word([2, 1, 2]))
  ```
  est un terme qui représente la règle de réécriture $(12, 212)$.

+ Un **ensemble de règles de réécriture** est représenté par un terme `rule_sset(LST)` où
  `LST` est une liste qui contient les règles de réécriture de l'ensemble. Par exemple,
  ```prolog
      rule_set(
          [
              rule(word([1, 1]), word([1])),
              rule(word([1, 2]), word([2, 1, 2])),
              rule(word([2, 1]), word([]))
          ]
      )
  ```
  est un terme qui représente l'ensemble de règles de réécritures

  > $\{(11, 1), (12, 212), (21, \epsilon)\}$.

+ Un **chemin** est représenté par un terme `path(LST)` où `LST` la liste des mots qui
  forment le chemin. Par exemple,
  ```prolog
      path(
          [
              word([1, 2, 1, 1]),
              word([1, 2, 1]),
              word([2, 1, 2, 1]),
              word([2, 1]),
              word([])
          ]
      )
  ```
  est un terme qui représente le chemin

  > $1211 \Rightarrow_R 121 \Rightarrow_R 2121 \Rightarrow_R 21 \Rightarrow_R \epsilon$.

+ Une **instance de casse-tête** est représente par un terme `puzzle(RULE_SET, WORD)` où
  `RULE_SET` est un terme qui représente un ensemble $R$ des règles de réécriture et `WORD`
  est un mot $R$-magique. Par exemple,
  ```prolog
      puzzle(
          rule_set(
              [
                  rule(word([1, 1]), word([1])),
                  rule(word([1, 2]), word([2, 1, 2])),
                  rule(word([2, 1]), word([]))
              ]
          ),
          word([1, 2, 1, 1])
      )
  ```
  est un terme qui représente l'instance de casse-tête

  > $(\{(11, 1), (12, 212), (21, \epsilon)\}, 1211)$.


### Prédicats obligatoires
Les explications suivantes s'appuieront sur des exemples basés sur l'ensemble `rule_set_123`
de règles et l'instance `puzzle_1` de casse-tête définis par
```prolog
    rule_1(rule(word([1, 1]), word([1]))).

    rule_2(rule(word([1, 2]), word([2, 1, 2]))).

    rule_3(rule(word([2, 1]), word([]))).

    rule_set_123(rule_set([_rule_1, _rule_2, _rule_3])) :-
        rule_1(_rule_1),
        rule_2(_rule_2),
        rule_3(_rule_3).

    puzzle_1(puzzle(_rule_set, word([1, 2, 1, 1]))) :-
        rule_set_123(_rule_set).
```

Les deux prédicats suivants sont obligatoires à implanter.


1. > `all_puzzle_solutions(_puzzle, _len, _solutions)`

   Ce prédicat met en relation l'instance de casse-tête `_puzzle`, l'entier `_len` et la
   liste de chemins `_solutions` lorsque l'instance de casse-tête en question possède comme
   solutions de longueur `_len` exactement les chemins de `_solutions`. Par exemple, le
   prédicat de test
   ```prolog
       test_1 :-
           puzzle_1(_puzzle),
           _len is 4,
           write("Puzzle:\n"),
           print_puzzle(_puzzle),
           nl,
           format("Solutions of length ~d:\n", [_len]),
           all_puzzle_solutions(_puzzle, _len, _solutions),
           print_path_list(_solutions).
   ```
   a pour effet d'imprimer
   ```
       Puzzle puzzle_1:
       Rule set:
       11 -> 1
       12 -> 212
       21 -> e
       Word:
       1211
       Solutions of length 4:
       1211 => 121 => 2121 => 21 => e
       1211 => 21211 => 211 => 21 => e
       1211 => 21211 => 2121 => 21 => e
   ```

2. > `all_magic_words_of_rule_set(_rule_set, _len, _magic_words)`

   Ce prédicat met en relation l'ensemble de de règles `_rule_set`, l'entier `_len` et la
   liste de mots `_magic_words` lorsque les mots de cette liste forment, avec `_rule_set`,
   toutes les instances de casse-tête admettant une solution de longueur `_len`. Par
   exemple, le prédicat de test
   ```prolog
       test_2 :-
           rule_set_123(_rule_set),
           _len is 3,
           write("Rule set:\n"),
           print_rule_set(_rule_set),
           format("Magic words having solutions of length ~d:\n", [_len]),
           all_magic_words_of_rule_set(_rule_set, _len, _magic_words),
           print_word_list(_magic_words).
   ```
   a pour effet d'imprimer
   ```
       Rule set:
       11 -> 1
       12 -> 212
       21 -> e
       Magic words having solutions of length 3:
       121
       2111
       21121
       21211
       212121
       212211
       22111
       221121
       221211
       222111
   ```

### Prédicats intermédiaires
Voici des prédicats non obligatoires à implanter mais qui peuvent aider grandement
dans l'obtention des deux prédicats primordiaux précédents.

Commençons par les prédicats qui provoquent des effets secondaires d'impression.

1. > `print_word(_w)`

   Ce prédicat est vrai lorsque`_w` est un mot et l'imprime.

1. > `print_word_list(_lst)`

   Ce prédicat est vrai lorsque `_lst` est une liste de mots et l'imprime, avec un mot par
   ligne.

1. > `print_rule(_rule)`

   Ce prédicat est vrai lorsque `_rule` est une règle et l'imprime.

1. > `print_rule_set(_rule_set)`

   Ce prédicat est vrai lorsque `_rule_set` est un ensemble de règles et l'imprime, avec une
   règle par ligne.

1. > `print_puzzle(_puzzle)`

   Ce prédicat est vrai lorsque le terme `_puzzle` est une instance de casse-tête et
   l'imprime.

1. > `print_path(_path)`

   Ce prédicat est vrai lorsque `_path` est un chemin et l'imprime.

1. > `print_path_list(_lst)`

   Ce prédicat est vrai lorsque `_lst` est une liste de chemins et l'imprime, avec un chemin
   par ligne.

Voici les autres prédicats intermédiaires, qui permettent de représenter les mécaniques du
jeu.

1. > `word_concatenation(_w1, _w2, _w3)`

   Ce prédicat met en relation les trois mots `_w1`, `_w2` et `_w3` lorsque `_w3` est la
   concaténation de `_w1` et `_w2`.

1. > `rewrite_prefix_by_rule(_rule, _w1, _w2)`

   Ce prédicat met en relation la règle `_rule` et les deux mots `_w1` et `_w2` lorsque
   `_w2` peut être obtenu à partir de `_w1` en y appliquant `_rule` sur l'un de ses
   préfixes.

1. > `rewrite_factor_by_rule(_rule, _w1, _w2)`

   Ce prédicat met en relation la règle `_rule` et les deux mots `_w1` et `_w2` lorsque
   `_w2` peut être obtenu à partir de `_w1` en y appliquant `_rule` sur l'un de ses
   facteurs.

1. > `rewrite(_rule_set, _w1, _w2)`

   Ce prédicat met en relation l'ensemble de règles `_rule_set` et les deux mots `_w1` et
   `_w2` lorsque `_w2` peut être obtenu à partir de `_w1` en y appliquant une règle de
   `_rule_set` sur l'un de ses facteurs.

1. > `connecting_path(_rule_set, _len, _w1, _path, _w2)`

   Ce prédicat met en relation l'ensemble de règles `_rule_set`, l'entier `_len`, le mot
   `_w1`, le chemin `_path` et le mot `_w2` lorsque `_path` est un chemin de longueur `_len`
   de réécritures permettant de transformer `_w1` en `_w2` par le biais des règles de
   réécriture de `_regles`.

1. > `puzzle_solution(_puzzle, _len, _solution)`

   Ce prédicat met en relation l'instance de casse-tête `_puzzle`, l'entier `_len` et le
   chemin `_solution` lorsque `_solution` est une solution de longueur `_len` de l'instance
   `_puzzles` de casse-tête.

1. > `rule_reversion(_rule_1, _rule_2)`

   Ce prédicat met en relation les règles `_rule_1` et `_rule_2` lorsque `_rule_2` est
   obtenue en échangeant les deux mots constituant `_rule_1`.

1. > `magic_word_of_rule_set(_rule_set, _len, _w)`

   Ce prédicat met en relation l'ensemble de règles `_rule_set`, l'entier `_len` et le mot
   `_w` lorsque `_w` est un mot $R$-magique admettant une solution de longueur `_len` où $R$
   est l'ensemble `_rule_set`.


### Conseils et idées
+ Écrire des tests unitaires pour tous les prédicats. Il est important de s'assurer que
  tout fonctionne bien et que tout est utilisé de manière adéquate (attention notamment au
  fait qu'il n'y a pas vraiment de vérification de types en `Prolog`).

+ Essayer tout d'abord de comprendre parfaitement le mécanisme de la réécriture de mots.
  Il est utile d'exprimer l'application d'une règle de réécriture sur un facteur d'un mot
  en appliquant de manière récursive la réécriture sur ses préfixes.

+ Essayer aussi de comprendre comment détecter si un chemin est une solution. Pour cela,
  définir le prédicat `connecting_path` introduit plus haut en utilisant une description
  récursive.

+ Il est possible d'utiliser le prédicat prédéfini `findall` pour collecter vers une liste
  toutes les solutions possibles d'une requête donnée.

+ Dans le même ordre d'idées, il est possible d'utiliser le prédicat prédéfini `sort` pour
  trier une liste et supprimer ses doublons. Ceci est utile pour améliorer une liste qui
  contient des solutions.

+ Pour engendrer un mot $R$-magique à partir d'un ensemble $R$ de règles, une idée simple et
  efficace consiste à considérer l'ensemble $R'$ de règles obtenu en inversant les règles de
  $R$ et à engendrer un mot à partir de $\epsilon$ en lui appliquant des réécritures par des
  règles de réécriture de $R'$.


## Évaluation
Le TP est noté sur $100$, avec $10$ supplémentaires en bonus, répartis de la manière
suivante.

| #     | Élément                    | Points |
|-------|----------------------------|--------|
| 1.    | Calcul des solution        | 25     |
| 2.    | Création des mots magiques | 25     |
| 3.    | Succès aux tests           | 20     |
| 4.    | Documentation              | 10     |
| 5.    | Élégance du code           | 10     |
| 6.    | Élégance des techniques    | 10     |
| 7.    | Ajouts intéressants        | (10)   |

Le point 3. évalue dans quelle mesure l'implantation proposée donne des bonnes réponses
aux tests donnés, ainsi que sa performance de réponse. Le point 5. évalue le respect des
principes de la programmation logique. Le point 6. évalue la pertinence algorithmique des
méthodes employées. Le point 7. apporte des points bonus pour récompenser des ajouts
méritants. Pour cela, une idée pourrait être de développer le nécessaire pour engendrer les
mots magiques parfaits (voir la définition de ce concept plus haut).


## Remise du TP

La remise doit se faire sous la forme d'une archive au format `zip` qui contient exactement
les deux fichiers

1. `MagicWords.pl` --- Il s'agit de remplir ce fichier. Le travail principal attendu doit y
   figurer.

2. `Tests.pl` --- Ce fichier peut être rendu dans le même état que le fichier fourni. Il
   est néanmoins autorisé de le modifier si besoin.

Ces deux fichiers doivent chacun contenir **prénon**, **nom** et **code permanent**.

À partir de 23 h 59, heure du jour de la date de rendu (voir la date au début de ce
document), une pénalité de **2 points par heure entamée** sera appliqué, avec un retard
maximal de **24 heures**. Un travail remis à 00 h 00 ou 00 h 59 aura donc une pénalité de 2
points, tandis qu'un travail remis à 01:00 aura une pénalité de 4 points.

**Aucune remise par courriel** ne sera acceptée. Une remise **au delà de 24 heures** après
la date limite **ne sera pas acceptée.**

Liste de contrôle :

+ [ ] ce sujet a été relu en entier pour voir si rien n'a été oublié ;

+ [ ] le fichier `MagicWords.pl` contient les identifiants ;

+ [ ] le fichier `Tests.pl` contient les identifiants (même s'il n'est pas modifié) ;

+ [ ] les deux fichiers se chargent sans erreur ni message d'avertissement dans `swipl` avec
  la commande `swipl Tests.pl` ;

+ [ ] les tests s'exécutent avec succès ;

+ [ ] les fichiers sonts documentés ;

+ [ ] les principes élémentaires de la programmation logique sont respectés.

