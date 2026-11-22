% tests/p2_tests.pl -- tests for the public P2 predicates
% Run from the repo root (rename id_q2.pl to your group's file):
%   swipl -q -f tests/p2_tests.pl -g run_tests -t halt

:- ensure_loaded('../code/id_q2.pl').

seven(["4*2-5=3", "4*2=5+3", "4-2=5-3", "4/2=5-3",
       "4=2*(5-3)", "4=2+(5-3)", "4=2+5-3"]).        % exactly as in the assignment

% ---------- generate_equation/2: assignment examples ----------
test(gen_4253_is_one_of_seven,  ( generate_equation([4,2,5,3], E), seven(S), member(E, S) )).
test(gen_returns_string,        ( generate_equation([4,2,5,3], E), string(E) )).
test(gen_deterministic,         ( call_cleanup(generate_equation([4,2,5,3], _), D = true), D == true )).
test(gen_234_fails,             \+ generate_equation([2,3,4], _)).
test(gen_248,                   ( generate_equation([2,4,8], E), E == "2*4=8" )).

% ---------- generate_equation/2: edge cases ----------
test(gen_empty_fails,           \+ generate_equation([], _)).
test(gen_single_fails,          \+ generate_equation([7], _)).
test(gen_single_zero_fails,     \+ generate_equation([0], _)).
test(gen_two_equal,             ( generate_equation([5,5], E), E == "5=5" )).
test(gen_two_unequal_fails,     \+ generate_equation([5,6], _)).
test(gen_div_zero_no_error,     \+ generate_equation([6,3,0], _)).
test(gen_checks_given_valid,    generate_equation([4,2,5,3], "4*2=5+3")).
test(gen_checks_given_invalid,  \+ generate_equation([4,2,5,3], "2+2=4")).
test(gen_non_list_fails,        \+ generate_equation(foo, _)).
test(gen_unbound_list_fails,    \+ generate_equation(_, _)).
test(gen_partial_list_fails,    \+ generate_equation([1,1|_], _)).
test(gen_non_integer_fails,     \+ generate_equation([a,b], _)).
test(gen_float_fails,           \+ generate_equation([1.0,1.0], _)).
test(gen_negative_fails,        \+ generate_equation([-1,-1], _)).

% ---------- all_equations/2: assignment examples ----------
test(all_4253_exact,            ( all_equations([4,2,5,3], Es), seven(S), Es == S )).
test(all_234_empty,             ( all_equations([2,3,4], Es), Es == [] )).
test(all_248,                   ( all_equations([2,4,8], Es), Es == ["2*4=8"] )).

% ---------- all_equations/2: edge cases and further exact answers ----------
test(all_empty_list,            ( all_equations([], Es), Es == [] )).
test(all_single,                ( all_equations([7], Es), Es == [] )).
test(all_00,                    ( all_equations([0,0], Es), Es == ["0=0"] )).
test(all_33,                    ( all_equations([3,3], Es), Es == ["3=3"] )).
test(all_123,                   ( all_equations([1,2,3], Es), Es == ["1+2=3"] )).
test(all_multi_digit,           ( all_equations([10,5,50], Es), Es == ["10*5=50"] )).
test(all_111,                   ( all_equations([1,1,1], Es), Es == ["1*1=1","1/1=1","1=1*1","1=1/1"] )).
test(all_000,                   ( all_equations([0,0,0], Es),
                                  Es == ["0*0=0","0+0=0","0-0=0","0=0*0","0=0+0","0=0-0"] )).
test(all_632,                   ( all_equations([6,3,2], Es), Es == ["6/3=2","6=3*2"] )).
test(all_840,                   ( all_equations([8,4,2], Es), Es == ["8/4=2","8=4*2"] )).
test(all_550,                   ( all_equations([5,5,0], Es), Es == ["5-5=0","5=5+0","5=5-0"] )).
test(all_050,                   ( all_equations([0,5,0], Es), Es == ["0*5=0","0/5=0","0=5*0"] )).
test(all_div_by_zero_only,      ( all_equations([6,3,0], Es), Es == [] )).
test(all_3120_parenthesisations,
     ( all_equations([3,1,2,0], Es),
       Es == ["3-(1+2)=0","3-1-2=0","3-1=2+0","3-1=2-0",
              "3=1+(2+0)","3=1+(2-0)","3=1+2+0","3=1+2-0"] )).

% sorted by sort/2 and duplicate-free: sort/2 of the result changes nothing
test(all_sorted_and_unique,
     forall(member(L, [[4,2,5,3],[1,1,1],[0,0,0],[2,2,2,2],[1,2,3,4,5],[3,1,2,0]]),
            ( all_equations(L, Es), sort(Es, Es) ))).
test(all_are_strings,
     forall(( member(L, [[4,2,5,3],[2,2,2,2]]), all_equations(L, Es), member(E, Es) ),
            string(E))).
% the result does not depend on how many solutions generate_equation would skip
test(gen_member_of_all,
     forall(member(L, [[4,2,5,3],[1,1,1],[2,2,2,2],[3,1,2,0]]),
            ( generate_equation(L, E), all_equations(L, Es), memberchk(E, Es) ))).

% ---------- all_equations/2: invalid input gives [] ----------
test(all_non_list,              ( all_equations(foo, Es), Es == [] )).
test(all_unbound_list,          ( all_equations(_, Es), Es == [] )).
test(all_partial_list,          ( all_equations([1,1|_], Es), Es == [] )).
test(all_non_integers,          ( all_equations([a,b], Es), Es == [] )).
test(all_floats,                ( all_equations([1.0,1.0], Es), Es == [] )).
test(all_negatives,             ( all_equations([-1,-1], Es), Es == [] )).
test(all_checks_bound_result,   all_equations([2,4,8], ["2*4=8"])).
test(all_checks_wrong_result,   \+ all_equations([2,4,8], [])).

% ---------- count_equations/2 ----------
test(count_4253,                ( count_equations([4,2,5,3], N), N =:= 7 )).
test(count_234,                 ( count_equations([2,3,4], N), N =:= 0 )).
test(count_248,                 ( count_equations([2,4,8], N), N =:= 1 )).
test(count_empty,               ( count_equations([], N), N =:= 0 )).
test(count_single,              ( count_equations([7], N), N =:= 0 )).
test(count_111,                 ( count_equations([1,1,1], N), N =:= 4 )).
test(count_000,                 ( count_equations([0,0,0], N), N =:= 6 )).
test(count_2222,                ( count_equations([2,2,2,2], N), N =:= 26 )).
test(count_12345,               ( count_equations([1,2,3,4,5], N), N =:= 14 )).
test(count_3120,                ( count_equations([3,1,2,0], N), N =:= 8 )).
test(count_invalid,             ( count_equations(foo, N), N =:= 0 )).
test(count_matches_length,
     forall(member(L, [[4,2,5,3],[2,3,4],[2,2,2,2],[3,1,2,0]]),
            ( count_equations(L, N), all_equations(L, Es), length(Es, N) ))).
test(count_checks_bound,        count_equations([4,2,5,3], 7)).

% ---------- runner ----------
passes(Goal) :- catch(Goal, _, fail), !.

run_tests :-
    findall(Name, test(Name, _), All),
    findall(Name, ( test(Name, Goal), \+ passes(Goal) ), Failed),
    forall(member(F, Failed), format("FAIL ~w~n", [F])),
    length(All, Total), length(Failed, NF), Pass is Total - NF,
    format("~w/~w tests passed~n", [Pass, Total]).
