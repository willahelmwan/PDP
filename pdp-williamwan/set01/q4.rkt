;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname q4) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Exercise 27. Our solution to the sample problem contains several constants in the middle of functions. As One Program, Many Definitions already points out, it is best to give names to such constants so that future readers understand where these numbers come from. Collect all definitions in DrRacket’s definitions area and change them so that all magic numbers are refactored into constant definitions.  (refactoring the profit program)
;; Goal: refactoring the profit program. 

(require rackunit)
(require "extras.rkt")

(check-location "01" "q4.rkt")

(provide profit)

;; DATA DEFINITION: none.

(define regular-num-attendees 120) ; regular number of attendees
(define regular-ticket-price 5.0) ; regular ticket price
(define price-change 0.1); ticket price change
(define attendance-change 15) ; number of attendees change based on ticket price change

;; attendees: NonNegReal -> NonNegInt
;; GIVEN: a ticket price with increment or decrement of ticket price change. The price cannot be less than regular-ticket-price - (regular-num-attendees/attendance-change)*price-change. 
;; RETURNS: the number of attendees
;; EXAMPLES:
;; (attendees 0.0) = 870
;; (attendees 5.8) = 0
;; (attendees 4.8) = 150
;; (attendees 5.0) = 120
;; STRATEGY: combine simpler functions

(define (attendees ticket-price)
  (- regular-num-attendees (* (- ticket-price regular-ticket-price) (/ attendance-change price-change))))

;; DATA DEFINITION: none.

;; revenue: NonNegReal -> NonNegReal
;; GIVEN: a ticket price with increment or decrement of ticket price change. The price cannot be less than regular-ticket-price - (regular-num-attendees/attendance-change)*price-change. 
;; RETURNS: the revenue
;; EXAMPLES:
;; (revenue 0.0) = 0
;; (revenue 5.8) = 0
;; (revenue 4.8) = 720
;; (revenue 5.0) = 600
;; STRATEGY: combine simpler functions

(define (revenue ticket-price)
  (* ticket-price (attendees ticket-price)))

;; DATA DEFINITION: none.

(define fixed-cost 180) ; fixed cost of putting together a show
(define variable-cost 0.04) ; varible cost per attendee

;; cost: NonNegReal -> NonNegReal
;; GIVEN: a ticket price with increment or decrement of ticket price change. The price cannot be less than regular-ticket-price - (regular-num-attendees/attendance-change)*price-change. 
;; RETURNS: the cost
;; EXAMPLES:
;; (cost 0.0) = 214.8
;; (cost 5.8) = 180
;; (cost 4.8) = 186
;; (cost 5.0) = 184.8
;; STRATEGY: combine simpler functions

(define (cost ticket-price)
  (+ fixed-cost (* variable-cost (attendees ticket-price))))

;; DATA DEFINITION: none.

;; profit: NonNegReal -> Real
;; GIVEN: a ticket price with increment or decrement of ticket price change. The price cannot be less than regular-ticket-price - (regular-num-attendees/attendance-change)*price-change. 
;; RETURNS: the profit
;; EXAMPLES:
;; (profit 0.0) = -214.8
;; (profit 5.8) = -180
;; (profit 4.8) = 534
;; (profit 5.0) = 415.2
;; STRATEGY: combine simpler functions

(define (profit ticket-price)
  (- (revenue ticket-price)
     (cost ticket-price)))

(begin-for-test
  (check-equal? (profit 0.0) -214.8
                "the profit with a price of $0.0 is $-214.5.")
  (check-equal? (profit 5.8) -180
                "the profit with a price of $5.8 is $-180.")
  (check-equal? (profit 4.8) 534
                "the profit with a price of $4.8 is $534.")
  (check-equal? (profit 5.0) 415.2
                "the profit with a price of $5.0 is $415.2."))