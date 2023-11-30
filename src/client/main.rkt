#lang racket
;;; (require "parser.rkt")
(require "parser.rkt")
(require "interpreter.rkt")
(require "query.rkt")

; raco pkg install http-easy-lib
;;; (require net/http-easy)

(define chrome-bin-path "\"C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe\"")


(define baseurl "https://dl.acm.org/action/doSearch?fillQuickSearch=false&target=advanced&expand=dl&AllField=")
(define link-to-open (string-append baseurl (eval-prog (parse q))))

(shell-execute #f chrome-bin-path link-to-open
               (current-directory) 'sw_shownormal)



;;; (define res
;;;     (get "http://localhost:5001/"))

;;; (displayln (response-status-code res))
;;; (displayln (response-status-message res))
;;; (displayln (response-headers-ref res 'date))
;;; (displayln (subbytes (response-body res) 0 30))


