;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Exercise 14. Define the function string-last, which extracts the last 1String from a non-empty string. Don’t worry about empty strings.
;; Goal: accepts a non-empty string and extracts the last 1String. 

(require rackunit)
(require "extras.rkt")

(check-location "01" "q2.rkt")

(provide string-last)

;; DATA DEFINITION: none.

;; string-last: NonEmptyStr -> 1String
;; GIVEN: a non-empty string
;; RETURNS: the last 1String
;; EXAMPLES:
;; (string-last "hello") = "o"
;; (string-last "hi ") = " "
;; (string-last "hello hi \t") = "\t"
;; (string-last " ") = " "
;; STRATEGY: combine simpler functions

(define (string-last str)
 (string-ith str (- (string-length str) 1)))


(begin-for-test
  (check-equal? (string-last "hello") "o"
                "the last 1String for 'hello' should be 'o'")
  (check-equal? (string-last "hi ") " "
                "the last 1String for 'hi ' should be ' '")
  (check-equal? (string-last "hello hi \t") "\t"
                "the last 1String for 'hello hi \t' should be '\t'")
  (check-equal? (string-last " ") " "
                "the last 1String for ' ' should be ' '"))
