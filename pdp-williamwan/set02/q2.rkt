;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Goal: design a finite-state machine and a set of functions that illustrate
;; the workings of that machine according to the following regular expression:
;; (d* | d* p d* | s d* | s d* p d*) (d | d e)

(require rackunit)
(require "extras.rkt")

(check-location "02" "q2.rkt")

(provide
  initial-state
  next-state
  accepting-state?
  rejecting-state?)

;; DATA DEFINITION:
;; A LegalInput is one of:
;; -- "d"
;; -- "p"
;; -- "s"
;; -- "e"
;; INTERPRETATION: self-evident

;; TEMPLATE
;; fsm-fn : LegalInput -> ??
#;
(define (fsm-fn li)
  (cond
    [(string=? li "d") ...]
    [(string=? li "p") ...]
    [(string=? li "s") ...]
    [(string=? li "e") ...]))

;; DATA DEFINITION:
;; A State is one of:
;; -- "s0"
;; -- "s1"
;; -- "s2"
;; -- "s3"
;; -- "s4"
;; -- "s5"
;; -- "err"
;; INTERPRETATION:
;; "s0" is the initial state.
;; "s1" is the next state from "s0", "s1", or "s3" given the LegalInput of "d".
;; "s2" is the next state from "s0", "s1", or "s3" given the LegalInput of "p".
;; "s3" is the next state from "s0" given the LegalInput of "s".
;; "s4" is the next state from "s1" or "s5" given the LegalInput of "e".
;; "s5" is the next state from "s2" or "s5" given the LegalInput of "d".
;; "err" is the next state from "s0" if given the LegalInput of "e", from "s1"
;; if given the LegalInput of "s", from "s2" if given the LegalInput of "s", "p",
;; or "e", from "s3" if given the LegalInput of "s" or "e", from "s4" if given
;; the LegalInput of "s", "d", "p", or "e", from "s5" if given the LegalInput of
;; "s" or "p".
;; "err" is the rejecting state.
;; "s1", "s4", and "s5" are the accepting states. 

;; TEMPLATE
;; fsm-fn : State -> ??
#;
(define (fsm-fn st)
  (cond
    [(string=? st "s0") ...]
    [(string=? st "s1") ...]
    [(string=? st "s2") ...]
    [(string=? st "s3") ...]
    [(string=? st "s4") ...]
    [(string=? st "s5") ...]
    [(string=? st "err") ...]))

;; initial-state : Number -> State
;; GIVEN: a number
;; RETURNS: a representation of the initial state of FSM. The given number is ignored.
;; EXAMPLES:
;; (initial-state 2) = "s0"
;; (initial-state 1.23) = "s0"
;; (initial-state -3) = "s0"
;; (initial-state (sqrt -1)) = "s0"
;; STRATEGY: combine simpler functions

(define (initial-state num)
  "s0")

(begin-for-test
  (check-equal? (initial-state 2) "s0"
                "the initial state should be 's0'.")
  (check-equal? (initial-state 1.23) "s0"
                "the initial state should be 's0'.")
  (check-equal? (initial-state -3) "s0"
                "the initial state should be 's0'.")
  (check-equal? (initial-state (sqrt -1)) "s0"
                "the initial state should be 's0'."))

;; next-state : State LegalInput -> State
;; GIVEN: a state of the machine and a machine input
;; RETURNS: the state the machine should enter if it is in the given state and
;; sees the given input.
;; EXAMPLES:
;; (next-state "s0" "d") = "s1"
;; (next-state "s1" "d") = "s1"
;; (next-state "s2" "d") = "s5"
;; (next-state "s4" "p") = "err"
;; (next-state "err" "s") = "err"
;; STRATEGY: use template for State on st and use template for LegalInput on li.

(define (next-state st li)
  (cond
    [(string=? st "s0")
     (cond
       [(string=? li "d") "s1"]
       [(string=? li "p") "s2"]
       [(string=? li "s") "s3"]
       [(string=? li "e") "err"])]
    [(string=? st "s1")
     (cond
       [(string=? li "d") "s1"]
       [(string=? li "p") "s2"]
       [(string=? li "s") "err"]
       [(string=? li "e") "s4"])]
    [(string=? st "s2")
     (cond
       [(string=? li "d") "s5"]
       [(string=? li "p") "err"]
       [(string=? li "s") "err"]
       [(string=? li "e") "err"])]
    [(string=? st "s3")
     (cond
       [(string=? li "d") "s1"]
       [(string=? li "p") "s2"]
       [(string=? li "s") "err"]
       [(string=? li "e") "err"])]
    [(string=? st "s4")
     (cond
       [(string=? li "d") "err"]
       [(string=? li "p") "err"]
       [(string=? li "s") "err"]
       [(string=? li "e") "err"])]
    [(string=? st "s5")
     (cond
       [(string=? li "d") "s5"]
       [(string=? li "p") "err"]
       [(string=? li "s") "err"]
       [(string=? li "e") "s4"])]
    [(string=? st "err")
     (cond
       [(string=? li "d") "err"]
       [(string=? li "p") "err"]
       [(string=? li "s") "err"]
       [(string=? li "e") "err"])]))

(begin-for-test
  (check-equal? (next-state "s0" "d") "s1"
                "the next state with input 's0' and 'd' should be 's1'.")
  (check-equal? (next-state "s0" "p") "s2"
                "the next state with input 's0' and 'p' should be 's2'.")
  (check-equal? (next-state "s0" "s") "s3"
                "the next state with input 's0' and 's' should be 's3'.")
  (check-equal? (next-state "s0" "e") "err"
                "the next state with input 's0' and 'e' should be 'err'.")
  (check-equal? (next-state "s1" "d") "s1"
                "the next state with input 's1' and 'd' should be 's1'.")
  (check-equal? (next-state "s1" "p") "s2"
                "the next state with input 's1' and 'p' should be 's2'.")
  (check-equal? (next-state "s1" "s") "err"
                "the next state with input 's1' and 's' should be 'err'.")
  (check-equal? (next-state "s1" "e") "s4"
                "the next state with input 's1' and 'e' should be 's4'.")
  (check-equal? (next-state "s2" "d") "s5"
                "the next state with input 's2' and 'd' should be 's5'.")
  (check-equal? (next-state "s2" "p") "err"
                "the next state with input 's2' and 'p' should be 'err'.")
  (check-equal? (next-state "s2" "s") "err"
                "the next state with input 's2' and 's' should be 'err'.")
  (check-equal? (next-state "s2" "e") "err"
                "the next state with input 's2' and 'e' should be 'err'.")
  (check-equal? (next-state "s3" "d") "s1"
                "the next state with input 's3' and 'd' should be 's1'.")
  (check-equal? (next-state "s3" "p") "s2"
                "the next state with input 's3' and 'p' should be 's2'.")
  (check-equal? (next-state "s3" "s") "err"
                "the next state with input 's3' and 's' should be 'err'.")
  (check-equal? (next-state "s3" "e") "err"
                "the next state with input 's3' and 'e' should be 'err'.")
  (check-equal? (next-state "s4" "d") "err"
                "the next state with input 's4' and 'd' should be 'err'.")
  (check-equal? (next-state "s4" "p") "err"
                "the next state with input 's4' and 'p' should be 'err'.")
  (check-equal? (next-state "s4" "s") "err"
                "the next state with input 's4' and 's' should be 'err'.")
  (check-equal? (next-state "s4" "e") "err"
                "the next state with input 's4' and 'e' should be 'err'.")
  (check-equal? (next-state "s5" "d") "s5"
                "the next state with input 's5' and 'd' should be 's5'.")
  (check-equal? (next-state "s5" "p") "err"
                "the next state with input 's5' and 'p' should be 'err'.")
  (check-equal? (next-state "s5" "s") "err"
                "the next state with input 's5' and 's' should be 'err'.")
  (check-equal? (next-state "s5" "e") "s4"
                "the next state with input 's5' and 'e' should be 's4'.")
  (check-equal? (next-state "err" "d") "err"
                "the next state with input 'err' and 'd' should be 'err'.")
  (check-equal? (next-state "err" "p") "err"
                "the next state with input 'err' and 'p' should be 'err'.")
  (check-equal? (next-state "err" "s") "err"
                "the next state with input 'err' and 's' should be 'err'.")
  (check-equal? (next-state "err" "e") "err"
                "the next state with input 'err' and 'e' should be 'err'."))

;; accepting-state? : State -> Boolean
;; GIVEN: a state of the machine
;; RETURNS: true iff the given state is a final (accepting) state
;; EXAMPLES:
;; (accepting-state? "s1") = #true
;; (accepting-state? "err") = #false
;; (accepting-state? "s2") = #false
;; STRATEGY: use template for State on st.

(define (accepting-state? st)
  (cond
    [(string=? st "s0") #false]
    [(string=? st "s1") #true]
    [(string=? st "s2") #false]
    [(string=? st "s3") #false]
    [(string=? st "s4") #true]
    [(string=? st "s5") #true]
    [(string=? st "err") #false]))

(begin-for-test
  (check-equal? (accepting-state? "s0") #false
                "the 's0' state is not an accepting state.")
  (check-equal? (accepting-state? "s1") #true
                "the 's1' state is an accepting state.")
  (check-equal? (accepting-state? "s2") #false
                "the 's2' state is not an accepting state.")
  (check-equal? (accepting-state? "s3") #false
                "the 's3' state is not an accepting state.")
  (check-equal? (accepting-state? "s4") #true
                "the 's4' state is an accepting state.")
  (check-equal? (accepting-state? "s5") #true
                "the 's5' state is an accepting state.")
  (check-equal? (accepting-state? "err") #false
                "the 'err' state is not an accepting state."))

;; rejecting-state? : State -> Boolean
;; GIVEN: a state of the machine
;; RETURNS: true iff there is no path (empty or non-empty) from the given state
;; to an accepting state.
;; EXAMPLES:
;; (rejecting-state? "s1") = #false
;; (rejecting-state? "err") = #true
;; STRATEGY: use template for State on st

(define (rejecting-state? st)
  (cond
    [(string=? st "s0") #false]
    [(string=? st "s1") #false]
    [(string=? st "s2") #false]
    [(string=? st "s3") #false]
    [(string=? st "s4") #false]
    [(string=? st "s5") #false]
    [(string=? st "err") #true]))

(begin-for-test
  (check-equal? (rejecting-state? "s0") #false
                "the 's0' state is not a rejecting state.")
  (check-equal? (rejecting-state? "s1") #false
                "the 's1' state is not a rejecting state.")
  (check-equal? (rejecting-state? "s2") #false
                "the 's2' state is not a rejecting state.")
  (check-equal? (rejecting-state? "s3") #false
                "the 's3' state is not a rejecting state.")
  (check-equal? (rejecting-state? "s4") #false
                "the 's4' state is not a rejecting state.")
  (check-equal? (rejecting-state? "s5") #false
                "the 's5' state is not a rejecting state.")
  (check-equal? (rejecting-state? "err") #true
                "the 'err' state is a rejecting state."))
