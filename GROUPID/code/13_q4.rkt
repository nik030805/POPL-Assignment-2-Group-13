#lang racket/base
;; id_q4.rkt -- S2: Conditionally Insert into a Nested List
;; Only definitions: nothing is called or printed when the file is loaded.
;; Built-ins used: define, let, let*, letrec, lambda, if, or, null?, pair?,
;; cons, car, cdr, <, +, quote, read, display, newline.

;; ---------------------------------------------------------------
;; (my-length lst): number of top-level elements of lst.
;; Tail recursive: the running count is passed as the argument `count`,
;; so a 10,000-element list needs no growing stack of pending additions.
;;   length of ()         = count
;;   length of (a . rest) = length of rest, with count + 1
;; ---------------------------------------------------------------
(define (my-length lst)
  (let loop ((rest lst) (count 0))
    (if (null? rest)
        count
        (loop (cdr rest) (+ count 1)))))

;; ---------------------------------------------------------------
;; (my-map f lst): the list of (f e) for each element e, in order.
;;   map of ()         = ()
;;   map of (a . rest) = (f a) consed onto the map of rest
;; ---------------------------------------------------------------
(define (my-map f lst)
  (if (null? lst)
      '()
      (cons (f (car lst))
            (my-map f (cdr lst)))))

;; ---------------------------------------------------------------
;; (list-like? e): #t for a list element (a pair or the empty list '()).
;; (pair? '()) is #f, but '() is a list that must be processed.
;; ---------------------------------------------------------------
(define (list-like? e)
  (or (pair? e) (null? e)))

;; ---------------------------------------------------------------
;; (make-inserter x len-ok?): higher-order function.
;; Returns a ONE-ARGUMENT function `insert` that takes a list and puts x
;; at the front of every list, at every level of nesting, whose ORIGINAL
;; length satisfies (len-ok? length).
;;
;; `insert` is a closure: it remembers x and len-ok? from the call to
;; make-inserter that created it, even after make-inserter has returned.
;; letrec lets `insert` refer to itself so it can recurse into sublists.
;;
;; For a list lst:
;;   1. len       = (my-length lst), measured before any insertion.
;;   2. new-elems = lst with each list element replaced by (insert e),
;;                  atoms left unchanged.
;;   3. if (len-ok? len), return (cons x new-elems), else new-elems.
;; ---------------------------------------------------------------
(define (make-inserter x len-ok?)
  (letrec ((insert
            (lambda (lst)
              (let ((len (my-length lst))
                    (new-elems (my-map (lambda (e)
                                         (if (list-like? e)
                                             (insert e)
                                             e))
                                       lst)))
                (if (len-ok? len)
                    (cons x new-elems)
                    new-elems)))))
    insert))

;; ---------------------------------------------------------------
;; (insert-if-short x lst n): the ONLY definition of insert-if-short.
;; Builds an inserter whose length test is the closure
;; (lambda (len) (< len n)), which captures n, then applies it to lst.
;; ---------------------------------------------------------------
(define (insert-if-short x lst n)
  ((make-inserter x (lambda (len) (< len n))) lst))

;; ---------------------------------------------------------------
;; (print-insert-result): S2.a.  Takes no arguments.
;; Reads x, lst and n from standard input, in that order, then prints
;; the result of (insert-if-short x lst n) with display, then a newline.
;; No prompt and no other text is printed.
;; let* is used (not let) because it evaluates its bindings strictly
;; top to bottom, so the three reads happen in the order x, lst, n.
;; ---------------------------------------------------------------
(define (print-insert-result)
  (let* ((x (read))
         (lst (read))
         (n (read)))
    (display (insert-if-short x lst n))
    (newline)))
