#lang racket

(require eopl)
(require racket/trace)
(require racket/pretty)

(provide (all-defined-out))


;;;  Concrete syntax
;;
;;  <exp> ::= <query-result>
;;          | ((<list-of-define-query>) <run-stmt>)
;;
;;  <query> ::= <symbol>
;;            | (conj <list-of-query>)
;;            | (disj <list-of-query>)
;;            | (<select-attr> (conj <list-of-val>)
;;            | (<select-attr> (disj <list-of-val>)
;;
;;  <list-of-query> ::=
;;                   | <query> <list-of-query>
;;
;;  <val> ::= <string>
;;
;;  <list-of-val> ::=
;;                   | <val> <list-of-val>
;;
;;  <list-of-define-query> := 
;;                          | (define-query <symbol> <query>) <list-of-define-query>
;;
;;
;;  <run-stmt> ::= (run-query <query>)
;;               | (run-query (project (<list-of-project-attr>) <query>))
;;
;;  <list-of-project-attr> ::=
;;                           | <project-attr> <list-of-project-attr>
;;
;;
;;  <select-attr> ::= pub-date (TODO: move this to run query)
;;                  | paper-title
;;                  | pub-title
;;                  | author
;;                  | abstract
;;                  | full-text
;;                  | conf-location
;;                  | conf-sponsor
;;                  | isbn
;;                  | doi
;;
;;
;;  <project-attr> ::= paper-title
;;                   | authors
;;                   | issued-in
;;                   | page-count
;;                   | pub-date
;;                   | doi
;;                   | abstract
;;                   | citation-count
;;                   | references
;;                   | citations
;;


;;; SELECTION attributes
;;
;;  pub-date           : qparams: AfterMonth, AfterYear, BeforeMonth, BeforeYear
;;  { qparam: AllField }
;;  paper-title        : Title
;;  pub-title          : ContentGroupTitle
;;  author             : ContribAuthor
;;  abstract           : Abstract
;;  full-text          : Fulltext
;;  conf-location      : ConferenceLocation
;;  conf-sponsor       : ConferenceSponsor
;;  isbn               : PubIdSortField
;;  doi                : DOI


;;; PROJECTION attributes
;;
;;  paper-title        
;;  authors            
;;  issued-in          
;;  page-count         
;;  pub-date           
;;  doi                
;;  abstract           
;;  citation-count     
;;  references         
;;  citations          


(define-datatype q-ast q-ast?
  [query-result (qres list?)]
  [defineq-run-q (defs (list-of defineq?)) (run query?)]
  [defineq-run-var (defs (list-of defineq?)) (run symbol?)]
)

(define-datatype defineq defineq?
  [define-query (id symbol?) (q query?)]
)

(define-datatype query query?
  [conj (qlist (list-of query?))]
  [disj (qlist (list-of query?))]
  [select-conj (sattr select-attr?) (val-list (list-of string?))]
  [select-disj (sattr select-attr?) (val-list (list-of string?))]
)


(define-datatype select-attr select-attr?
  [paper-title   (sattr-str-eq string?)]
  [pub-title     (sattr-str-eq string?)]
  [author        (sattr-str-eq string?)]
  [abstract      (sattr-str-eq string?)]
  [full-text     (sattr-str-eq string?)]
  [conf-location (sattr-str-eq string?)]
  [conf-sponsor  (sattr-str-eq string?)]
  [isbn          (sattr-str-eq string?)]
  [doi           (sattr-str-eq string?)]
)


(define (sattr-sym? sattr)
  (match sattr
    ['paper-title   #t]
    ['pub-title     #t]
    ['author        #t]
    ['abstract      #t]
    ['full-text     #t]
    ['conf-location #t]
    ['conf-sponsor  #t]
    ['isbn          #t]
    ['doi           #t]
    [_              #f]
  )
)

(define (sattr-sym->sattr-type sattr)
  (match sattr
    ['paper-title   paper-title  ]
    ['pub-title     pub-title    ]
    ['author        author       ]
    ['abstract      abstract     ]
    ['full-text     full-text    ]
    ['conf-location conf-location]
    ['conf-sponsor  conf-sponsor ]
    ['isbn          isbn         ]
    ['doi           doi          ]
  )
)

(define (sattr-sym->sattr-str sattr)
  (match sattr
    ['paper-title   "Title"             ]
    ['pub-title     "ContentGroupTitle" ]
    ['author        "ContribAuthor"     ]
    ['abstract      "Abstract"          ]
    ['full-text     "Fulltext"          ]
    ['conf-location "ConferenceLocation"]
    ['conf-sponsor  "ConferenceSponsor" ]
    ['isbn          "PubIdSortField"    ]
    ['doi           "DOI"               ]
  )
)


(struct exn:parse-error exn:fail ())
(define raise-exec-not-implemented
  (lambda ()
    (raise (exn:parse-error "not implemented" (current-continuation-marks))))
)


(define (parse exp)
  (match exp
    [(list defineq-l (list 'run-query (? symbol? qid)))   (defineq-run-var (map parse defineq-l) qid)]
    [(list defineq-l (list 'run-query q))                 (defineq-run-q (map parse defineq-l) (parse q))]
    [(list 'define-query (? symbol? id) q)                (define-query id (parse q))]
    [(list 'conj q-l ...)                                 (conj (map parse q-l))]
    [(list 'disj q-l ...)                                 (disj (map parse q-l))]
    [(list (? sattr-sym? sattr) (list 'conj val-l ...))   (select-conj ((sattr-sym->sattr-type sattr) (sattr-sym->sattr-str sattr)) val-l)]
    [(list (? sattr-sym? sattr) (list 'disj val-l ...))   (select-disj ((sattr-sym->sattr-type sattr) (sattr-sym->sattr-str sattr)) val-l)]
    [_ (raise-exec-not-implemented)]
  )
)
;;; (trace parse)


(pretty-print
  (parse
    '(([define-query query-name
        (conj (abstract
                (disj "functional"
                      "lambda calculus"))
              (author (conj "church"))
        )
      ])
      [run-query (abstract
                  (disj "functional"
                        "lambda calculus"))]
    )
  )
)