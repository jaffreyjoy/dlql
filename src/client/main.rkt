#lang racket

; raco pkg install http-easy-lib
(require net/http-easy)

(define res
    (get "http://localhost:5001/"))

(displayln (response-status-code res))
(displayln (response-status-message res))
(displayln (response-headers-ref res 'date))
(displayln (subbytes (response-body res) 0 30))


