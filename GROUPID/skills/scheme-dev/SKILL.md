---
name: scheme-dev
description: Write, test and review Racket (#lang racket/base) code restricted to a small allowed built-in set, for CS F301 Assignment 2 (S1 tree traversals, S2 nested-list insert). Use for any Scheme function, test or review in this repo.
---

# scheme-dev

## Language and environment
- Racket 8.x, file starts with `#lang racket/base`. Run: `racket code/id_q3.rkt`, `racket code/id_q4.rkt`.
- Files contain ONLY definitions: no top-level calls, nothing printed when the file loads
  (the grader appends its own calls).
- ALLOWED: `define lambda let let* letrec` (and named let) `if cond(with else) and or not begin quote '`
  `cons car cdr list`, all `c[ad]{2,4}r` (cadr, cddr, caddr, ... up to four levels), `null? pair? eq? assq assoc`,
  `+ - * < > <= >= =`, `max`, `display`, `newline`. S2 also allows `read`.
- FORBIDDEN (write your own helper instead): `set!` and relatives, vectors, hash tables, strings,
  `do`/`for` loops, `length append reverse map filter member memq list-ref list-tail`.
  Also NOT on the list, so avoid: `list? zero? add1 sub1 abs equal? number? symbol? empty? first rest`.

## Conventions
- Pass all state through arguments (accumulators). Prefer tail recursion where natural (`my-length`).
- Helpers named `my-...` when they replace a forbidden built-in. One function = one job.
- Every function has a comment: what it takes, what it returns, and its recursive reading
  ("the answer for () is ...; the answer for (a . rest) is ... of rest").
- Comments at the top of each file list the built-ins actually used.

## How to run and test
1. `racket code/id_qN.rkt` must print nothing and not error.
2. S1: `cat code/id_q3.rkt tests/s1_calls.rkt > /tmp/s1_all.rkt && racket /tmp/s1_all.rkt | diff - tests/s1_expected.txt`
3. S2: `sh tests/s2_tests.sh` (appends `(print-insert-result)` and pipes stdin like the grader).
4. Always include: empty input, one element, deep nesting (depth 100), long lists (10,000 elements).

## Self-review checklist (apply BEFORE giving an answer)
- [ ] First line is `#lang racket/base`; only `define`s at top level.
- [ ] Every symbol used is on the allowed list above (grep the file for the forbidden names).
- [ ] Output is exactly as specified: `display`, one line per list, ends with `newline`, no prompts.
- [ ] `'()` handled explicitly (note `(pair? '())` is `#f`).
- [ ] Length/height measured on the ORIGINAL structure, before any insertion.
- [ ] Reading order for `read` is x, then lst, then n (use `let*`, not `let`).
- [ ] No quadratic behaviour hidden in helpers (10,000-element lists must be fast).
- [ ] Final S2 file has exactly ONE definition of `insert-if-short` (the `make-inserter` one).

## Known AI failure modes in Scheme/Racket
1. Silently uses `length`, `append`, `map`, `reverse`, `list?`, `zero?`, `add1` or `for` loops.
2. Treats `'()` as an atom because `(pair? '())` is `#f`, so empty nested lists are skipped.
3. Measures list length AFTER inserting `x`, so lists are compared with the wrong length.
4. Uses `let` instead of `let*` for several `read`s: argument evaluation order is not something to rely on.
5. Prints a prompt, extra spaces, or forgets the final `newline`; uses `write` instead of `display`.
6. Leaves test calls like `(print-inorder t1)` at top level of the submitted file.
7. Leaves two definitions of `insert-if-short` (the old one and the `make-inserter` one).
8. Builds lists by repeated `append` (quadratic) or uses mutation (`set!`) for accumulators.
9. Forgets `else` in `cond`, or writes `cond` clauses that fall through and return void.
10. Uses `define` forms or syntax from full `#lang racket` that `racket/base` does not provide.
11. Claims the code is tested without running it; always run the test script and diff the output.
