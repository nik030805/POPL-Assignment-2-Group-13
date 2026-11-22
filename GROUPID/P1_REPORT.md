# P1 Report: Department Assignment Puzzle, Reloaded

## P1.b: number of solutions

`count_solutions([1,2,3,4,5,6,7,8], N)` gives **N = 3**.

(The search space is 4! x 4! x 4! = 13824 candidate assignments; the eight clues cut it down to 3.)

## What N = 3 tells us about the puzzle

A well-posed puzzle has exactly one solution. Here N = 3, so the eight clues are **not enough**:
the puzzle is *under-constrained* (it has more than one valid answer), and `main` could legitimately
print any of the three. The three solutions are:

| | Alex | Ben | Carla | Dana |
|---|---|---|---|---|
| Solution A | design, java, AI | development, javascript, web | research, c++, data | testing, python, embedded |
| Solution B | design, java, embedded | development, javascript, web | testing, python, AI | research, c++, data |
| Solution C | testing, python, embedded | development, javascript, web | design, java, AI | research, c++, data |

The clues fully determine Ben (development, javascript, web in all three). What they leave open is
who holds the AI project and who is in testing/design/research: the clues contradict none of A, B or C.

## P1.c: the repair

Clue 9 (in `code/id_q1.pl`):

> The friend who prefers the AI project works in the testing department.

It mentions no friend by name. It is true only in Solution B (Carla, AI, testing); in Solution A
the AI friend (Alex) is in design, and in Solution C the AI friend (Carla) is in design, so it is false there.
Hence `count_solutions([1,2,3,4,5,6,7,8,9], N)` gives **N = 1**, and the kept solution is B:

```
Alex = [design, java, embedded]
Ben = [development, javascript, web]
Carla = [testing, python, AI]
Dana = [research, c++, data]
```
