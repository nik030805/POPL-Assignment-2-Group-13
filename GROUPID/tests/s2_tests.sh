#!/bin/sh
# tests/s2_tests.sh -- run from the repo root:  sh tests/s2_tests.sh
# Mimics the grader: appends a call to the end of code/id_q4.rkt and pipes stdin.
CODE=code/id_q4.rkt
TMP=$(mktemp /tmp/s2_XXXXXX.rkt)
cp "$CODE" "$TMP"; echo '(print-insert-result)' >> "$TMP"
pass=0; fail=0
check() {  # name, input, expected
  got=$(printf '%s\n' "$2" | racket "$TMP")
  if [ "$got" = "$3" ]; then pass=$((pass+1)); echo "PASS $1"
  else fail=$((fail+1)); echo "FAIL $1"; echo "  got:      $(echo "$got" | cut -c1-80)"; echo "  expected: $(echo "$3" | cut -c1-80)"; fi
}
check ex1            "42 ((1 2) (3 4 5) (6) ()) 3"        "((42 1 2) (3 4 5) (42 6) (42))"
check ex2            "0 (((1) 2) (3) ((4 5 6) ())) 3"     "((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))"
check ex3            "7 () 3"                             "(7)"
check ex4            "7 () 0"                             "()"
check n0-nested      "7 ((1) () (2 3)) 0"                 "((1) () (2 3))"
check empty-nested   "x (() (())) 1"                      "((x) ((x)))"
check symbols        "z (a (b c) d) 3"                    "(a (z b c) d)"

# depth 100: 100 nested "()" levels; innermost () -> (9), each wrapper has length 1 < 2
open=$(printf '(%.0s' $(seq 1 100)); close=$(printf ')%.0s' $(seq 1 100))
exp="(9)"; i=1; while [ $i -lt 100 ]; do exp="(9 $exp)"; i=$((i+1)); done
check depth-100      "9 ${open}${close} 2"                "$exp"

# 10,000 elements: n=10001 inserts at the front, n=10000 does not
elems=$(seq 1 10000 | tr '\n' ' ' | sed 's/ $//')
check 10k-insert     "5 ($elems) 10001"                   "(5 $elems)"
check 10k-noinsert   "5 ($elems) 10000"                   "($elems)"

rm -f "$TMP"; echo "passed=$pass failed=$fail"; [ $fail -eq 0 ]
