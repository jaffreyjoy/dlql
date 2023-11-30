#lang racket

(provide (all-defined-out))

(define q
    '(  (
        [define-query func-lambda-church
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
        ]
        )
        (run-query (disj func-lambda-church term-klop))
    )
)