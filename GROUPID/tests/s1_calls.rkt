;; tests/s1_calls.rkt -- calls appended AFTER code/id_q3.rkt (no #lang line here).
;; Run from the repo root:
;;   cat code/id_q3.rkt tests/s1_calls.rkt > /tmp/s1_all.rkt && racket /tmp/s1_all.rkt | diff - tests/s1_expected.txt
;; No output from diff means every line matches.

(define (label s) (display s) (newline))
(define (make-chain n)                         ; right chain 1 -> 2 -> ... of n nodes (n at the top)
  (if (= n 0) '() (list n '() (make-chain (- n 1)))))

(define t1 '(4 (2 (1 () ()) (3 () ())) (6 (5 () ()) (7 () ()))))
(define t2 '(1 () (2 () (3 () ()))))
(define t3 '(a (b () ()) (c () ())))
(define t0 '())
(define single '(9 () ()))
(define left-only '(1 (2 () ()) ()))
(define right-only '(1 () (2 () ())))
(define mixed '(x (1 () ()) (y () ())))
(define negative '(-1 (-2 () ()) (0 () ())))
(define unbalanced '(5 (3 (2 (1 () ()) ()) (4 () ())) (8 () (9 () ()))))

(label 't1)         (print-inorder t1)         (print-all-traversals t1)         (print-height-and-leaves t1)
(label 't2)         (print-inorder t2)         (print-all-traversals t2)         (print-height-and-leaves t2)
(label 't3)         (print-inorder t3)         (print-all-traversals t3)         (print-height-and-leaves t3)
(label 'empty)      (print-inorder t0)         (print-all-traversals t0)         (print-height-and-leaves t0)
(label 'single)     (print-inorder single)     (print-all-traversals single)     (print-height-and-leaves single)
(label 'left-only)  (print-inorder left-only)  (print-all-traversals left-only)  (print-height-and-leaves left-only)
(label 'right-only) (print-inorder right-only) (print-all-traversals right-only) (print-height-and-leaves right-only)
(label 'mixed)      (print-inorder mixed)      (print-all-traversals mixed)      (print-height-and-leaves mixed)
(label 'negative)   (print-inorder negative)   (print-all-traversals negative)   (print-height-and-leaves negative)
(label 'unbalanced) (print-inorder unbalanced) (print-all-traversals unbalanced) (print-height-and-leaves unbalanced)
(label 'chain-10000) (print-height-and-leaves (make-chain 10000))
