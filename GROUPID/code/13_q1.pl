% id_q1.pl -- P1: Department Assignment Puzzle, Reloaded
% Only definitions here: no initialization directive, no halt/0.

:- use_module(library(lists)).

% ---------------------------------------------------------------
% Representation
% A solution is a list of four terms p(Name, Dept, Lang, Project),
% in the order Alex, Ben, Carla, Dana.
% ---------------------------------------------------------------

names(['Alex', 'Ben', 'Carla', 'Dana']).
depts([research, development, design, testing]).
langs([python, java, 'c++', javascript]).
projects(['AI', web, embedded, data]).

% ---------------------------------------------------------------
% candidate(-Solution)
% Generates every assignment in which each attribute uses its four
% values exactly once (a permutation per attribute), without
% looking at any clue.  4! * 4! * 4! = 13824 candidates.
% ---------------------------------------------------------------

candidate(Solution) :-
    names(Names),
    depts(Ds0),    permutation(Ds0, Ds),
    langs(Ls0),    permutation(Ls0, Ls),
    projects(Ps0), permutation(Ps0, Ps),
    build(Names, Ds, Ls, Ps, Solution).

% build(+Names, +Depts, +Langs, +Projects, -Solution)
build([], [], [], [], []).
build([N|Ns], [D|Ds], [L|Ls], [P|Ps], [p(N, D, L, P)|Rest]) :-
    build(Ns, Ds, Ls, Ps, Rest).

% ---------------------------------------------------------------
% Clues: clue(N, Solution) succeeds exactly when clue N holds in a
% fully (ground) filled-in Solution.
% ---------------------------------------------------------------

% 1. The friend who prefers the AI project does not work in
%    research and is not Dana.
clue(1, Solution) :-
    member(p(Name, Dept, _, 'AI'), Solution),
    Dept \== research,
    Name \== 'Dana'.

% 2. Alex does not work in development and does not prefer C++.
clue(2, Solution) :-
    member(p('Alex', Dept, Lang, _), Solution),
    Dept \== development,
    Lang \== 'c++'.

% 3. The friend working in the testing department likes Python.
clue(3, Solution) :-
    member(p(_, testing, python, _), Solution).

% 4. Ben prefers web projects and does not work in testing.
clue(4, Solution) :-
    member(p('Ben', Dept, _, web), Solution),
    Dept \== testing.

% 5. The friend whose favorite language is Java works in design.
clue(5, Solution) :-
    member(p(_, design, java, _), Solution).

% 6. Carla's project preference is not embedded, and her
%    department is not development.
clue(6, Solution) :-
    member(p('Carla', Dept, _, Project), Solution),
    Project \== embedded,
    Dept \== development.

% 7. Dana's favorite language is not Java, and she works in
%    research or testing.
clue(7, Solution) :-
    member(p('Dana', Dept, Lang, _), Solution),
    Lang \== java,
    memberchk(Dept, [research, testing]).

% 8. The friend who prefers data projects works in research and
%    does not use JavaScript.
clue(8, Solution) :-
    member(p(_, research, Lang, data), Solution),
    Lang \== javascript.

% CLUE 9: The friend who prefers the AI project works in the testing department.
clue(9, Solution) :-
    member(p(_, testing, _, 'AI'), Solution).

% ---------------------------------------------------------------
% solution(-Solution): a candidate satisfying clues 1 to 8.
% ---------------------------------------------------------------

solution(Solution) :-
    candidate(Solution),
    forall(between(1, 8, N), clue(N, Solution)).

% ---------------------------------------------------------------
% count_solutions(+Active, -N)
% N is the number of candidates satisfying exactly the clues listed
% in Active; all other clues are ignored.
% ---------------------------------------------------------------

count_solutions(Active, N) :-
    findall(S,
            ( candidate(S),
              forall(member(C, Active), clue(C, S)) ),
            Solutions),
    length(Solutions, N).

% ---------------------------------------------------------------
% main/0: print one solution in the required format.  It prints the
% solution that is kept after the repair, i.e. the one that also
% satisfies clue 9 (it therefore satisfies clues 1 to 8 as well).
% ---------------------------------------------------------------

main :-
    once(( solution(Solution), clue(9, Solution) )),
    print_solution(Solution).

print_solution([]).
print_solution([p(Name, Dept, Lang, Project)|Rest]) :-
    format("~w = [~w, ~w, ~w]~n", [Name, Dept, Lang, Project]),
    print_solution(Rest).
