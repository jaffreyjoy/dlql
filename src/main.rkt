#lang racket

(require eopl)

(provide (all-defined-out))


;;;  Concrete syntax
;;
;;  <exp> ::= <query-result>
;;          | (<list-of-define-query> <run-stmt>)
;;
;;  <query> ::= <symbol>
;;            | (conj <list-of-query>)
;;            | (disj <list-of-query>)
;;            | (<select-attr> (conj <list-of-attr>))
;;            | (<select-attr> (disj <list-of-attr>))
;;
;;  <list-of-query> ::= ()
;;                   | (<query> <list-of-query>)
;;
;;  <attr> ::= <string>
;;
;;  <list-of-attr> ::= ()
;;                   | (<attr> <list-of-attr>)
;;
;;  <list-of-define-query> := ()
;;                          | ((define-query <symbol> <query>) <list-of-define-query>)
;;
;;
;;  <run-stmt> ::= (run-query <query>)
;;               | (run-query (project <list-of-project-attr> <query>))
;;
;;  <list-of-project-attr> ::= ()
;;                           | (<project-attr> <list-of-project-attr>)
;;
;;
;;  <select-attr> ::= pub-date
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
;;  pub-date
;;  paper-title
;;  pub-title
;;  author
;;  abstract
;;  full-text
;;  conf-location
;;  conf-sponsor
;;  isbn
;;  doi


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