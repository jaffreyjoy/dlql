#lang racket
(require eopl)
(require racket/trace)
(require racket/pretty)
(require "parser.rkt")

(define env (make-hash))

(define (eval-query q-ast)
  (cases query q-ast
      [qvar (id)                    (lookup-env id)]
      [conj (qlist)                 (string-join (map eval-query qlist)
                                                   ")+AND+("
                                                   #:before-first "("
                                                   #:after-last ")")]
      [disj (qlist)                 (string-join (map eval-query qlist)
                                                   ")+OR+("
                                                   #:before-first "(("
                                                   #:after-last "))")]
      [select-conj (sattr val-list) (string-append (select-attr-str-eq sattr)
                                                    ":"
                                                    (string-join val-list
                                                                "\"AND+\""
                                                                #:before-first "(\""
                                                                #:after-last "\")"))]
      [select-disj (sattr val-list) (string-append (select-attr-str-eq sattr)
                                                    ":"
                                                    (string-join val-list
                                                                "\"+OR+\""
                                                                #:before-first "(\""
                                                                #:after-last "\")"))]
      [_ (error "not query")]
  )
)
;;; (trace eval-query)


(define (lookup-env id)
  (let
    ([exp (hash-ref env id)])
    (match exp
      [(? query?) (let ([evald-exp (eval-query exp)])
                       (hash-set! env id evald-exp)
                       evald-exp)]
      [(? string?) exp]
    )
  )
)
;;; (trace lookup-env)


(define (eval-def dq-ast)
  (cases defineq dq-ast
    [define-query (id q) (hash-set! env id q)]
    [_ (error "not a define-query")]
  )
)
;;; (trace eval-def)

(define (eval-prog prog-ast)
  (cases ast prog-ast
    [defineq-run-q 
      (defs q)
      (let ()
           (map eval-def defs)
           (eval-query q))]
  )
)
;;; (trace eval-prog)


;;; --------------------------------------------------------------------


(let* ([qs '(([define-query func-lambda-church
              (conj (abstract
                      (disj "functional"
                            "lambda calculus"))
                    (author (conj "church"))
              )
            ]
            [define-query term-klop
              (conj (abstract
                      (disj "term rewriting"))
                    (author (conj "klop"))
              )
            ])
            [run-query (disj func-lambda-church term-klop)]
          )]
      [baseurl "https://dl.acm.org/action/doSearch?fillQuickSearch=false&target=advanced&expand=dl&AllField="]
      [pqs (parse qs)]
      [eqs (eval-prog pqs)])
    (pretty-print pqs)
    (printf "\n\n")
    (printf eqs)
    (printf "\n\n")
    (printf (string-append baseurl eqs))
    (printf "\n\n")
)