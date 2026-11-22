#lang racket/base
;; id_q3.rkt -- S1: Binary Tree Traversals
;; Only definitions: nothing is called or printed when the file is loaded.
;; A tree is either '() or (value left right).
;; Built-ins used: define, if, cond, else, and, null?, cons, list, car, cadr,
;; caddr, +, max, display, newline, quote.

;; ---------------------------------------------------------------
;; Traversals build the answer list with an ACCUMULATOR, so that no
;; list-joining or list-reversing helper is needed.  Each function takes a tree and the
;; list `acc` that must come AFTER the tree's values, and returns
;; (values of tree, in the wanted order) followed by acc.
;; To get the left subtree's values before the right subtree's, we
;; fill the accumulator from the right: the right subtree is handled
;; first (innermost call), the left subtree last (outermost call).
;; ---------------------------------------------------------------

;; (inorder-list tree acc): left subtree, node, right subtree, then acc
(define (inorder-list tree acc)
  (if (null? tree)
      acc
      (inorder-list (cadr tree)                        ; left, last to be consed on
                    (cons (car tree)                   ; node
                          (inorder-list (caddr tree)   ; right, built first
                                        acc)))))

;; (preorder-list tree acc): node, left subtree, right subtree, then acc
(define (preorder-list tree acc)
  (if (null? tree)
      acc
      (cons (car tree)
            (preorder-list (cadr tree)
                           (preorder-list (caddr tree) acc)))))

;; (postorder-list tree acc): left subtree, right subtree, node, then acc
(define (postorder-list tree acc)
  (if (null? tree)
      acc
      (postorder-list (cadr tree)
                      (postorder-list (caddr tree)
                                      (cons (car tree) acc)))))

;; ---------------------------------------------------------------
;; S1.a  (print-inorder tree): the inorder list on one line.
;; ---------------------------------------------------------------
(define (print-inorder tree)
  (display (inorder-list tree '()))
  (newline))

;; ---------------------------------------------------------------
;; S1.b  (print-all-traversals tree): inorder, preorder, postorder,
;; one list per line.
;; ---------------------------------------------------------------
(define (print-all-traversals tree)
  (display (inorder-list tree '()))
  (newline)
  (display (preorder-list tree '()))
  (newline)
  (display (postorder-list tree '()))
  (newline))

;; ---------------------------------------------------------------
;; Height and leaf count
;; ---------------------------------------------------------------

;; (tree-height tree): height of () is 0; a node is 1 plus the larger
;; of the heights of its two subtrees (so a single node has height 1).
(define (tree-height tree)
  (if (null? tree)
      0
      (+ 1 (max (tree-height (cadr tree))
                (tree-height (caddr tree))))))

;; (leaf-count tree): the empty tree has no leaves; a node whose two
;; subtrees are both () is one leaf; any other node has as many
;; leaves as its two subtrees together.
(define (leaf-count tree)
  (cond ((null? tree) 0)
        ((and (null? (cadr tree)) (null? (caddr tree))) 1)
        (else (+ (leaf-count (cadr tree))
                 (leaf-count (caddr tree))))))

;; ---------------------------------------------------------------
;; S1.c  (print-height-and-leaves tree): prints the list
;; (height leaf-count) on one line.
;; ---------------------------------------------------------------
(define (print-height-and-leaves tree)
  (display (list (tree-height tree) (leaf-count tree)))
  (newline))
