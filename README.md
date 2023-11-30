# dlql
A DSL to query the ACM digital library


## How to Run
The query can be modified in `src/query.rkt` and then run:
```
racket main.rkt
```

If the query is valid it would open the result of the query in a chrome window.

To change the browser in which you want the results to be displayed, change the path string assigned to the `browser-bin-path` variable in the `src/main.rkt`.


## Example
An example query would look like:
```racket
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
```

## Grammar
### Program Expression
```racket
;;  <exp> ::= ((<list-of-define-query>) <run-stmt>)
;;
;;  <list-of-define-query> := 
;;                          | (define-query <symbol> <query>) <list-of-define-query>
;;
;;  <run-stmt> ::= (run-query <query>)
```
### Query Expression
```racket
;;  <query> ::= <symbol>
;;            | (conj (<list-of-query>))
;;            | (disj (<list-of-query>))
;;            | (<select-attr> (conj (<list-of-attr>)))
;;            | (<select-attr> (disj (<list-of-attr>)))
;;
;;  <list-of-query> ::= 
;;                   | <query> <list-of-query>
;;
;;  <list-of-attr> ::= 
;;                   | <attr> <list-of-attr>
;;
;;  <attr> ::= <string>
```
### Select Attributes
```racket
;;  <select-attr> ::= paper-title
;;                  | pub-title
;;                  | author
;;                  | abstract
;;                  | full-text
;;                  | conf-location
;;                  | conf-sponsor
;;                  | isbn
;;                  | doi
```