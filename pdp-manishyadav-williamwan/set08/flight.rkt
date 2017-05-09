;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname flight) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Goal: Write data definitions for the UTC and Flight data types specified in
;;       the problem statements. 

(require rackunit)
(require "extras.rkt")
(check-location "08" "flight.rkt")

(provide
  make-UTC
  UTC-hour
  UTC-minute
  UTC=?
  make-flight
  flight-name
  departs
  arrives
  departs-at
  arrives-at
  flight=?)


;; DATA DEFINITIONS:

(define-struct UTC [hour minute])
;; A UTC is a structure:
;;  (make-UTC NonNegInt NonNegInt)
;; INTERPRETATION:
;; hour is the hour in UTC, it is less than 24
;; minute is the minute in UTC, it is less than 60

;; TEMPLATE:
;; utc-fn : UTC -> ??
#;
(define (utc-fn u)
  (... (UTC-hour u)
       (UTC-minute u)))

;; Example of UTC, for testing
(define UTC1 (make-UTC 20 03))
(define UTC2 (make-UTC 00 00))
(define UTC3 (make-UTC 01 11))


(define-struct flight [name departs arrives departs-at arrives-at])
;; A Flight is a structure:
;;  (make-Flight String String String UTC UTC)
;; INTERPRETATION:
;; name is the name of a flight
;; departs is the name of the airport from which the flight departs
;; arrives is the name of the airport at which the flight arrives
;; departs-at is the time (in UTC) at which the flight departs
;; arrives-at is the time (in UTC) at which the flight arrives

;; TEMPLATE:
;; flight-fn : Flight -> ??
#;
(define (flight-fn f)
  (... (flight-name f)
       (flight-departs f)
       (flight-arrives f)
       (flight-departs-at f)
       (flight-arrives-at f)))

;; Example of Flight, for testing
(define flt1 (make-flight "United 448" "BOS" "DEN"
                          (make-UTC 20 03) (make-UTC 00 53)))
(define flt2 (make-flight "United 256" "JFK" "LAX"
                          (make-UTC 18 06) (make-UTC 01 23)))

;; END DATA DEFINITION


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FUNCTIONS:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; UTC=? : UTC UTC -> Boolean
;; GIVEN: two UTC's
;; RETURNS: true iff the two UTC's have the same hour and minute parts
;; EXAMPLE:
;; (UTC=? UTC2 (make-UTC 00 00)) = true
;; (UTC=? UTC1 UTC2) = false
;; STRATEGY: Combine simpler fuctions

(define (UTC=? utc1 utc2)
  (equal? utc1 utc2))

;; TESTS:
(begin-for-test
  (check-equal? (UTC=? UTC2 (make-UTC 00 00)) true
    "(UTC=? UTC2 (make-UTC 00 00)) should return true. ")
  (check-equal? (UTC=? UTC1 UTC2) false
    "(UTC=? UTC1 UTC2) should return false. "))


;; departs : Flight -> String
;; GIVEN: a Flight
;; RETURN: the name of the airport from which the flight departs
;; EXAMPLES:
;; (departs flt1) = "BOS"
;; STRATEGY: Use template for Flight on f

(define (departs f)
  (flight-departs f))

;; TESTS:
(begin-for-test
  (check-equal? (departs flt1) "BOS"
    "(departs flt1) should return 'BOS'. "))


;; arrives : Flight -> String
;; GIVEN: a Flight
;; RETURN: the name of the airport at which the flight arrives
;; EXAMPLES:
;; (departs flt1) = "DEN"
;; STRATEGY: Use template for Flight on f

(define (arrives f)
  (flight-arrives f))

;; TESTS:
(begin-for-test
  (check-equal? (arrives flt1) "DEN"
    "(arrives flt1) should return 'DEN'. "))


;; departs-at : Flight -> UTC
;; GIVEN: a Flight
;; RETURN: the time (in UTC) at which the flight departs
;; EXAMPLES:
;; (departs flt1) = (make-UTC 20 03)
;; STRATEGY: Use template for Flight on f

(define (departs-at f)
  (flight-departs-at f))

;; TESTS:
(begin-for-test
  (check-equal? (departs-at flt1) (make-UTC 20 03)
    "(departs-at flt1) should return (make-UTC 20 03)."))


;; arrives-at : Flight -> UTC
;; GIVEN: a Flight
;; RETURN: the time (in UTC) at which the flight arrives
;; EXAMPLES:
;; (departs flt1) = (make-UTC 00 53)
;; STRATEGY: Use template for Flight on f

(define (arrives-at f)
  (flight-arrives-at f))

;; TESTS:
(begin-for-test
  (check-equal? (arrives-at flt1) (make-UTC 00 53)
    "(arrives-at flt1) should return (make-UTC 00 53)."))


;; flight=? : Flight Flight -> Boolean
;; GIVEN: two Flights
;; RETURNS: true iff the two Flights have the same name, depart from the same
;;          airport, arrive at the same airport, depart at the same time, and
;;          arrive at the same time.
;; EXAMPLE:
;; (flight=? flt1 flt2) = false
;; (flight=? flt1 flt1) = true
;; STRATEGY: Combine simpler fuctions

(define (flight=? flight1 flight2)
  (equal? flight1 flight2))

;; TESTS:
(begin-for-test
  (check-equal? (flight=? flt1 flt2) false
    "(flight=? flt1 flt2) should return false.")
  (check-equal? (flight=? flt1 flt1) true
    "(flight=? flt1 flt1) should return true."))


