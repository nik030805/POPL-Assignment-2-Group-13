---
name: prolog-dev
description: Write, test and review SWI-Prolog 9.x code for CS F301 Assignment 2 (P1 puzzle, P2 equations). Use for any Prolog predicate, test or review in this repo.
---

# prolog-dev

## Language and environment
- SWI-Prolog 9.x. Allowed libraries: `lists`, `apply`, `yall`, `aggregate` only.
- Files contain ONLY definitions (plus `:- use_module(...)`). No `initialization/1`, no `halt/0`, no printing on load.
- Run: `swipl -q -f code/id_q1.pl -g main -t halt` and
  `swipl -q -f code/id_q1.pl -g "<goal>" -t halt`.
- Forbidden: `assert*`, `retract*`, `b_setval`, `nb_setval` (no global state).
- P2: never build a string and parse it back to evaluate it; evaluate the expression TREE.

## Conventions
- One predicate = one job. Name predicates for what they mean (`apply_op`, `expr_tree`), not how.
- Every predicate gets a comment: signature with modes (`+In`, `-Out`, `?Either`) and a
  one-or-two-line DECLARATIVE reading ("X holds when ...").
- Prefer pure recursion over `if-then-else` tricks. Use `once/1` or `->` only where one answer is wanted.
- Use `format(string(S), ...)` for strings. Quoted atoms where the spec says so: `'Alex'`, `'AI'`, `'c++'`.
- Counting: `findall/3` then `length/2`, or `aggregate_all(count, ..., N)`.

## How to run and test
1. Load the file: `swipl -q -f code/id_qN.pl -g halt` must print NOTHING and not error.
2. Run the test file: `swipl -q -f tests/pN_tests.pl -g run_tests -t halt`; any line starting with
   `FAIL` is a bug, the last line is the tally.
3. Check every example in the assignment text, plus edge cases (empty list, one element, no solution).

## Self-review checklist (apply BEFORE giving an answer)
- [ ] Does it load silently? No `initialization`, no `halt`, no stray `format`/`print`.
- [ ] Only allowed libraries; no assert/retract/global variables.
- [ ] Output types exactly as specified (string vs atom vs code list; quoted atoms; no spaces).
- [ ] Does it FAIL (not loop, not throw) when no answer exists, incl. `[]`, one element, non-list, unbound?
- [ ] Division: divisor tested for zero BEFORE `mod`/`//`; no evaluation_error possible.
- [ ] No duplicates where the spec says "without duplicates"; sorted with `sort/2` where required.
- [ ] Is each clause readable declaratively ("this holds when ...")?
- [ ] Does it work with backtracking (no accidental cuts removing valid solutions)?
- [ ] Tested with at least one case where the expected answer was computed independently.

## Known AI failure modes in Prolog
1. Adds `:- initialization(main).` or calls `halt.` inside the file (breaks the grader).
2. Uses `assert/retract` or `nb_setval` for "memoisation" or counting.
3. Confuses atoms, strings and code lists (`"abc"` is a string in SWI-Prolog 7+; `'abc'` is an atom).
4. Uses `\=` where `\==` is meant (or the reverse), or compares non-ground terms with `==`.
5. Forgets quoting: `ai` vs `'AI'`, `c++` vs `'c++'`, `alex` vs `'Alex'`.
6. Evaluates `A mod B` or `A // B` before checking `B =\= 0` -> `evaluation_error`.
7. Generates an infinite list or loops on an unbound / partial list (`append/3` with unbound args).
8. Counts clues with a cut or `forall` in the wrong place so `count_solutions` miscounts.
9. Uses `length/2`, `msort/2` or `sort/2` where `sort/4`/dedup semantics differ from what the spec needs.
10. Parenthesises output "to be safe" so different trees no longer print differently, or prints extra spaces.
11. Hard-codes the answer instead of deriving it from the clues.
12. Claims code "works" without running it. Always run the test file.
