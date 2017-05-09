;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Exercise 12. Define the function cvolume, which accepts the length of a side of an equilateral cube and computes its volume. If you have time, consider defining csurface, too.
;; Goal: accepts the length of a side of an equilateral cube and computes its volume. 

(require rackunit)
(require "extras.rkt")

(check-location "01" "q1.rkt")

(provide cvolume)
(provide csurface)

;; DATA DEFINITION: none.

;; cvolume: NonNegReal -> NonNegReal
;; GIVEN: the length of a side of an equilateral cube
;; RETURNS: the volume of the cube
;; EXAMPLES:
;; (cvolume 0.1) = 0.001
;; (cvolume 2) = 8
;; (cvolume 0) = 0
;; STRATEGY: combine simpler functions

(define (cvolume sidelen)
 (expt sidelen 3))
(begin-for-test
  (check-equal? (cvolume 0.1) 0.001
                "the volume for a cube with side 0.1 should be 0.001")
  (check-equal? (cvolume 2) 8
                "the volume for a cube with side 2 should be 8")
  (check-equal? (cvolume 0) 0
                "the volume for a cube with side 0 should be 0"))

;; DATA DEFINITION: none.

;; csurface: NonNegReal -> NonNegReal
;; GIVEN: the length of a side of an equilateral cube
;; RETURNS: the surface area of the cube
;; EXAMPLES:
;; (csurface 0.1) = 0.06
;; (csurface 2) = 24
;; (csurface 0) = 0
;; STRATEGY: combine simpler functions

(define (csurface sidelen)
 (* 6 (expt sidelen 2)))
(begin-for-test
  (check-equal? (csurface 0.1) 0.06
                "the surface for a cube with side 0.1 should be 0.06")
  (check-equal? (csurface 2) 24
                "the surface for a cube with side 2 should be 24")
  (check-equal? (csurface 0) 0
                "the surface for a cube with side 0 should be 0"))