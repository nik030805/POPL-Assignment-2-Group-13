#!/bin/sh
# Run from the repo root:  sh tests/run_all.sh
# Needs swipl (9.x) and racket (8.x) on the PATH.
echo "== P1 ==";  swipl -q -f tests/p1_tests.pl -g run_tests -t halt
echo "== P1 main =="; swipl -q -f code/id_q1.pl -g main -t halt
echo "== P2 ==";  swipl -q -f tests/p2_tests.pl -g run_tests -t halt
echo "== S1 =="
cat code/id_q3.rkt tests/s1_calls.rkt > /tmp/s1_all.rkt
racket /tmp/s1_all.rkt | diff - tests/s1_expected.txt && echo "S1 OK (no diff)"
echo "== S2 =="; sh tests/s2_tests.sh
echo "== load silently (must print nothing) =="
swipl -q -f code/id_q1.pl -g halt; swipl -q -f code/id_q2.pl -g halt
racket code/id_q3.rkt; racket code/id_q4.rkt
echo "done"
