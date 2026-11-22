#!/bin/sh
# Usage (from inside this folder):  sh rename_to_group.sh G12
# Renames id_q1.pl ... to G12_q1.pl ... and fixes every reference in tests/ and skills/.
# Run it ONCE, then delete this script before submitting.
[ -z "$1" ] && { echo "usage: sh rename_to_group.sh <GROUPID>"; exit 1; }
G="$1"
for q in q1.pl q2.pl q3.rkt q4.rkt; do mv "code/id_$q" "code/${G}_$q"; done
sed -i "s/id_q/${G}_q/g" tests/* skills/*/SKILL.md code/* P1_REPORT.md 2>/dev/null
echo "renamed. Now rename this folder to $G too."
