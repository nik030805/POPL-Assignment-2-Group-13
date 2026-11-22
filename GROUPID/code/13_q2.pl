% id_q2.pl -- P2: Form a Valid Arithmetic Equation
% Only definitions here: nothing runs on load and nothing is printed.
% Everything for P2: trees, evaluation, splitting, canonical printing and
% the public predicates generate_equation/2, all_equations/2, count_equations/2.

:- use_module(library(lists)).

% ---------------------------------------------------------------
% Representation of an expression tree
%   N                  a leaf: an integer from the input list
%   bin(Op, L, R)      Op is one of +, -, *, /; L and R are trees
% Every different tree is a different parenthesization and/or
% different operator choice, so trees are the objects that the
% canonical string of the assignment distinguishes.
% ---------------------------------------------------------------

operator(+).
operator(-).
operator(*).
operator(/).

% ---------------------------------------------------------------
% apply_op(+Op, +A, +B, -V)
% V is A Op B.  Division succeeds only when it is exact and the
% divisor is not zero.  The zero test comes first, so "mod" is
% never evaluated with a zero divisor: no evaluation_error is
% ever raised, the call simply fails.
% ---------------------------------------------------------------

apply_op(+, A, B, V) :- V is A + B.
apply_op(-, A, B, V) :- V is A - B.
apply_op(*, A, B, V) :- V is A * B.
apply_op(/, A, B, V) :-
    B =\= 0,
    A mod B =:= 0,
    V is A // B.

% ---------------------------------------------------------------
% eval(+Tree, -Value)
% Evaluates a tree directly from its structure (no strings, no
% term parsing).  Fails if ANY division inside the tree is inexact
% or has a zero divisor, because apply_op/4 is used at every node.
% Declarative reading: a leaf has its own value; a node has the
% value obtained by applying its operator to the values of its
% two subtrees.
% ---------------------------------------------------------------

eval(N, N) :-
    integer(N).
eval(bin(Op, L, R), V) :-
    eval(L, VL),
    eval(R, VR),
    apply_op(Op, VL, VR, V).

% ---------------------------------------------------------------
% leaves(+Tree, -Numbers)
% The numbers at the leaves, left to right.  Used to check that a
% tree preserves the order of the input list.
% ---------------------------------------------------------------

leaves(N, [N]) :-
    integer(N).
leaves(bin(_, L, R), Ns) :-
    leaves(L, Ls),
    leaves(R, Rs),
    append(Ls, Rs, Ns).

% ---------------------------------------------------------------
% expr_tree(+Numbers, -Tree, -Value)
% Tree is an expression tree whose leaves are exactly Numbers, in
% order, and Value is its (integer) value.  On backtracking it
% enumerates every such tree whose divisions are all exact.
% Declarative reading:
%   - one number is a tree by itself;
%   - otherwise cut the list into a non-empty left part and a
%     non-empty right part, take a tree for each part, and join
%     them with any of the four operators.
% Every way of cutting, at every level, is a different
% parenthesization, so all parenthesizations are produced and the
% input order is never changed.
% Value is computed while the tree is built, so a tree with an
% invalid division is abandoned immediately instead of being
% built completely and evaluated afterwards.  An empty list has
% no tree: the call fails (it does not loop or raise an error).
% ---------------------------------------------------------------

expr_tree([N], N, N) :-
    integer(N).
expr_tree(Numbers, bin(Op, TL, TR), V) :-
    append([X|Xs], [Y|Ys], Numbers),
    expr_tree([X|Xs], TL, VL),
    expr_tree([Y|Ys], TR, VR),
    operator(Op),
    apply_op(Op, VL, VR, V).

% ---------------------------------------------------------------
% split_list(+List, ?Left, ?Right)
% Cuts List into two NON-EMPTY contiguous parts, Left followed by
% Right, so that append(Left, Right, List).  On backtracking it
% gives every cut point j with 1 =< j < length(List), shortest
% Left first.  Lists of length 0 or 1 have no cut: it fails.
% ---------------------------------------------------------------

split_list(List, [X|Xs], [Y|Ys]) :-
    append([X|Xs], [Y|Ys], List).

% ---------------------------------------------------------------
% equation_trees(+Numbers, -LeftTree, -RightTree)
% LeftTree is an expression over the first j numbers, RightTree an
% expression over the remaining ones, and both have the SAME
% integer value (the right tree is built with that value already
% fixed, so only trees of equal value succeed).  All divisions in
% both trees are exact.
% ---------------------------------------------------------------

equation_trees(Numbers, TL, TR) :-
    split_list(Numbers, Left, Right),
    expr_tree(Left, TL, V),
    expr_tree(Right, TR, V).

% ---------------------------------------------------------------
% Canonical printing
%
% prec(+Op, -P): * and / bind tighter than + and -.
% Operators are left-associative, so for a node with operator Op
% (precedence P):
%   left operand  gets parentheses only if its top operator has
%                 LOWER precedence than P         (Q <  P)
%   right operand gets parentheses if its top operator has the
%                 SAME or lower precedence than P (Q =< P)
%   a single number never gets parentheses.
% ---------------------------------------------------------------

prec(+, 1).
prec(-, 1).
prec(*, 2).
prec(/, 2).

% needs_parens(+Side, +Operand, +ParentPrec)
needs_parens(left, bin(Op, _, _), P) :-
    prec(Op, Q),
    Q < P.
needs_parens(right, bin(Op, _, _), P) :-
    prec(Op, Q),
    Q =< P.

% operand_string(+Side, +Tree, +ParentPrec, -String)
operand_string(Side, Tree, ParentPrec, String) :-
    tree_string(Tree, S0),
    (   needs_parens(Side, Tree, ParentPrec)
    ->  format(string(String), "(~w)", [S0])
    ;   String = S0
    ).

% tree_string(+Tree, -String)
% String is the canonical SWI-Prolog string of the expression
% tree: no spaces, numbers in decimal.  The string is built
% directly from the tree (never converted back into a term).
tree_string(N, String) :-
    integer(N),
    format(string(String), "~w", [N]).
tree_string(bin(Op, L, R), String) :-
    prec(Op, P),
    operand_string(left, L, P, LS),
    operand_string(right, R, P, RS),
    format(string(String), "~w~w~w", [LS, Op, RS]).

% ---------------------------------------------------------------
% equation_string(+Numbers, -Equation)
% Equation is the canonical string "L=R" of one valid equation for
% Numbers.  On backtracking it enumerates every valid equation
% (every cut, every pair of equal-valued trees).  Each solution is
% a different string because different trees print differently.
% ---------------------------------------------------------------

equation_string(Numbers, Equation) :-
    equation_trees(Numbers, TL, TR),
    tree_string(TL, LS),
    tree_string(TR, RS),
    format(string(Equation), "~w=~w", [LS, RS]).

% ---------------------------------------------------------------
% Public predicates
% ---------------------------------------------------------------

% valid_numbers(+List)
% List is a proper list of non-negative integers.  Anything else
% (unbound or partial list, non-list, floats, atoms, negative
% numbers) is not valid input, so no equation exists for it.
% This also guarantees the enumeration below cannot loop on an
% unbound list.
valid_numbers(List) :-
    is_list(List),
    forall(member(X, List), ( integer(X), X >= 0 )).

% equation_of(+List, -Equation)
% Enumerates the canonical strings of all valid equations for a
% valid list; fails for invalid input.
equation_of(List, Equation) :-
    valid_numbers(List),
    equation_string(List, Equation).

% generate_equation(+List, -Equation)
% Equation is ONE valid equation for List (the first one found).
% Fails, without error or loop, if there is none (including for
% lists of length 0 or 1) and for invalid input.
generate_equation(List, Equation) :-
    once(equation_of(List, Equation)).

% all_equations(+List, -Equations)
% Equations is the list of ALL valid equations for List, as
% canonical strings, without duplicates, ordered by sort/2
% (standard order of terms; sort/2 also removes duplicates).
% [] if there is none.
all_equations(List, Equations) :-
    findall(E, equation_of(List, E), Es),
    sort(Es, Equations).

% count_equations(+List, -N)
% N is the number of equations in all_equations(List, _).
count_equations(List, N) :-
    all_equations(List, Equations),
    length(Equations, N).
