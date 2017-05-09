;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname q5) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Exercise 38. Design the function string-remove-last, which produces a string like the given one with the last character removed.
;; Goal: accepts a string returns a string with the last character removed. 

(require rackunit)
(require "extras.rkt")

(check-location "01" "q5.rkt")

(provide string-remove-last)

;; DATA DEFINITION: none.

;; string-remove-last: Str -> Str
;; GIVEN: a string str
;; RETURNS: a string with the last character removed from the original string
;; EXAMPLES:
;; (string-remove-last "hello!") = "hello"
;; (string-remove-last "hi ") = "hi"
;; (string-remove-last "hello hi \t") = "hello hi "
;; (string-remove-last " ") = ""
;; (string-remove-last "") = ""
;; STRATEGY: combine simpler functions

(define (string-remove-last str)
 (cond
   [(= (string-length str) 0) ""]
   [(> (string-length str) 0) (substring str 0 (- (string-length str) 1))]))


(begin-for-test
  (check-equal? (string-remove-last "hello!") "hello"
                "the string after removing the last character from 'hello!' should be 'hello'.")
  (check-equal? (string-remove-last "hi ") "hi"
                "the string after removing the last character from 'hi ' should be 'hi'.")
  (check-equal? (string-remove-last "hello hi \t") "hello hi "
                "the string after removing the last character from 'hello hi \t' should be 'hello hi '.")
  (check-equal? (string-remove-last " ") ""
                "the string after removing the last character from ' ' should be ''.")
  (check-equal? (string-remove-last "") ""
                "the string after removing the last character from '' should be ''."))