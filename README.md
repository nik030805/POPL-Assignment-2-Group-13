# POPL Assignment 2 – Group 13

**Course:** CS F301 – Principles of Programming Languages  
**Assignment:** Logic and Functional Programming

## Team Members

| Name | ID |
|---|---|
| Nikunj Srivastava | 2024A7PS0112H |
| Khushi Bharadwaj | 2024A7PS0145H |
| Kshitij Vijay Sharma | 2024A7PS0063H |

## Project Overview

This repository contains our solutions for Assignment 2, covering two Prolog problems and two Scheme problems. All three team members collaborated on problem-solving, implementation, testing, and reviewing the solutions.

## Task Distribution

| Member | Primary Focus Areas |
|---|---|
| **Nikunj Srivastava** | P1 – Department Assignment Puzzle (Prolog), solution development and testing |
| **Khushi Bharadwaj** | P2 – Arithmetic Equation Generation (Prolog), solution development and testing |
| **Kshitij Vijay Sharma** | S1 – Binary Tree Traversals and S2 – Conditional Insert (Scheme), implementation and testing |

**Collaborative Responsibilities:**
- Discussing approaches and designing solutions.
- Reviewing code and identifying edge cases.
- Testing all four problems against the provided test cases.
- Preparing documentation, prompts, and skill files.

*The primary focus areas above describe the proposed responsibility breakdown; all members contributed collaboratively.*

## Technologies Used

- **SWI-Prolog 9.x** – P1 and P2
- **Racket 8.x** – S1 and S2
- Git and GitHub – Version control and collaboration

## Repository Structure

```text
GROUPID/
├── code/
│   ├── 13_q1.pl
│   ├── 13_q2.pl
│   ├── 13_q3.rkt
│   └── 13_q4.rkt
├── tests/
├── skills/
│   ├── prolog-dev/
│   └── scheme-dev/
├── prompts/
│   ├── P1.md
│   ├── P2.md
│   ├── S1.md
│   └── S2.md
└── P1_REPORT.md
```

## Running the Programs

### Prolog

```bash
swipl -q -f code/13_q1.pl -g main -t halt
```

```bash
swipl -q -f code/13_q2.pl
```

### Scheme

```bash
racket code/13_q3.rkt
```

```bash
racket code/13_q4.rkt
```

## Testing

All four problems were tested using the provided test cases and additional edge cases.

- P1 – Department Assignment Puzzle
- P2 – Arithmetic Equation Generation
- S1 – Binary Tree Traversals
- S2 – Conditional Insertion into Nested Lists

## Conclusion

This assignment provided practical experience with declarative programming using Prolog and functional programming using Scheme. Through collaborative implementation and testing, we explored logical constraints, recursion, higher-order functions, and nested data structures.
