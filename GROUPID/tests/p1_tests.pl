% tests/p1_tests.pl -- tests for P1 (replace id_q1.pl with your group's file name)
% Run from the repo root:
%   swipl -q -f tests/p1_tests.pl -g run_tests -t halt
% Every line printed starting with FAIL is a bug; the last line gives the tally.

:- ensure_loaded('../code/id_q1.pl').

% ---- the three solutions of clues 1-8 (derived by hand, cross-checked) ----
s1([p('Alex',design,java,'AI'),       p('Ben',development,javascript,web),
    p('Carla',research,'c++',data),   p('Dana',testing,python,embedded)]).
s2([p('Alex',design,java,embedded),   p('Ben',development,javascript,web),
    p('Carla',testing,python,'AI'),   p('Dana',research,'c++',data)]).
s3([p('Alex',testing,python,embedded),p('Ben',development,javascript,web),
    p('Carla',design,java,'AI'),      p('Dana',research,'c++',data)]).

% ---- negative cases: valid permutations that each break (at least) the named clue ----
neg(1, [p('Alex',design,java,embedded),p('Ben',development,javascript,web),
        p('Carla',research,'c++',data),p('Dana',testing,python,'AI')]).     % Dana prefers AI
neg(2, [p('Alex',design,'c++','AI'),p('Ben',development,javascript,web),
        p('Carla',research,java,data),p('Dana',testing,python,embedded)]).  % Alex likes c++
neg(3, [p('Alex',design,java,'AI'),p('Ben',development,python,web),
        p('Carla',research,'c++',data),p('Dana',testing,javascript,embedded)]). % tester not python
neg(4, [p('Alex',design,java,'AI'),p('Ben',development,javascript,embedded),
        p('Carla',research,'c++',data),p('Dana',testing,python,web)]).       % Ben not web
neg(5, [p('Alex',research,java,'AI'),p('Ben',development,javascript,web),
        p('Carla',design,'c++',data),p('Dana',testing,python,embedded)]).    % java not in design
neg(6, [p('Alex',design,java,'AI'),p('Ben',research,javascript,web),
        p('Carla',development,'c++',data),p('Dana',testing,python,embedded)]). % Carla in development
neg(7, [p('Alex',design,java,'AI'),p('Ben',testing,javascript,web),
        p('Carla',research,'c++',data),p('Dana',development,python,embedded)]). % Dana in development
neg(8, [p('Alex',design,java,'AI'),p('Ben',development,javascript,data),
        p('Carla',research,'c++',web),p('Dana',testing,python,embedded)]).   % data person not research

% ---- test(Name, Goal): Goal must succeed ----
test(s1_satisfies(N), (s1(S), clue(N,S))) :- between(1, 8, N).
test(s2_satisfies(N), (s2(S), clue(N,S))) :- between(1, 9, N).
test(s3_satisfies(N), (s3(S), clue(N,S))) :- between(1, 8, N).
test(s1_clue9_false, (s1(S), \+ clue(9,S))).
test(s3_clue9_false, (s3(S), \+ clue(9,S))).
test(neg_clue_fails(N), (neg(N,S), \+ clue(N,S))) :- between(1, 8, N).

test(exactly_three_solutions,
     ( findall(S, solution(S), L), msort(L, M),
       s1(A), s2(B), s3(C), msort([A,B,C], M) )).
test(clue9_keeps_only_s2,
     ( findall(S, (solution(S), clue(9,S)), L), s2(B), L == [B] )).

test(count_1_to_8_is_3,  ( count_solutions([1,2,3,4,5,6,7,8], N), N =:= 3 )).
test(count_1_to_9_is_1,  ( count_solutions([1,2,3,4,5,6,7,8,9], N), N =:= 1 )).
test(count_no_clues,     ( count_solutions([], N), N =:= 13824 )).      % 24^3
test(count_clue3_alone,  ( count_solutions([3], N), N =:= 3456 )).      % 13824/4
test(count_clue9_alone,  ( count_solutions([9], N), N =:= 3456 )).
test(count_order_free,   ( count_solutions([9,8,7,6,5,4,3,2,1], N), N =:= 1 )).
test(count_duplicates,   ( count_solutions([1,1,2,2,3,4,5,6,7,8], N), N =:= 3 )).
test(count_unknown_clue, ( count_solutions([10], N), N =:= 0 )).        % no clause: fails, so 0

test(candidates_unique_values,
     ( candidate(S), findall(D, member(p(_,D,_,_),S), Ds), sort(Ds, SDs), length(SDs, 4),
                     findall(L, member(p(_,_,L,_),S), Ls), sort(Ls, SLs), length(SLs, 4),
                     findall(P, member(p(_,_,_,P),S), Ps), sort(Ps, SPs), length(SPs, 4) )).

test(main_output_exact,
     ( with_output_to(string(Out), main),
       member(X, [ "Alex = [design, java, AI]\nBen = [development, javascript, web]\nCarla = [research, c++, data]\nDana = [testing, python, embedded]\n",
                   "Alex = [design, java, embedded]\nBen = [development, javascript, web]\nCarla = [testing, python, AI]\nDana = [research, c++, data]\n",
                   "Alex = [testing, python, embedded]\nBen = [development, javascript, web]\nCarla = [design, java, AI]\nDana = [research, c++, data]\n" ]),
       Out == X )).

% ---- runner ----
passes(Goal) :- catch(Goal, _, fail), !.

run_tests :-
    findall(Name, test(Name, _), All),
    findall(Name, ( test(Name, Goal), \+ passes(Goal) ), Failed),
    forall(member(F, Failed), format("FAIL ~w~n", [F])),
    length(All, Total), length(Failed, NF), Pass is Total - NF,
    format("~w/~w tests passed~n", [Pass, Total]).
