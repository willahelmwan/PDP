;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Goal: Build a simple animation with two doodads moving around in a
;; rectangular enclosure, both doodads are selectable and draggable,
;; more doodads can be created or destroyed when certain keys are pressed.

(require rackunit)
(require "extras.rkt")
(require 2htdp/universe)
(require 2htdp/image)
(check-location "04" "q1.rkt")

(provide
  animation
  initial-world
  world-after-tick
  world-paused?
  world-after-key-event
  world-doodads-star
  world-doodads-square
  doodad-x
  doodad-y
  doodad-vx
  doodad-vy
  doodad-color
  doodad-selected?
  doodad-age
  world-after-mouse-event)

;; DATA DEFINITIONS:


;; CONSTANTS:

;; dimensions of the canvas
(define CANVAS-WIDTH 601)
(define CANVAS-HEIGHT 449)
(define EMPTY-CANVAS (empty-scene CANVAS-WIDTH CANVAS-HEIGHT))
;; initial position of star
(define STAR-X 125)
(define STAR-Y 120)
;; initial star speed
(define STAR-VX 10)
(define STAR-VY 12)
;; initial star color
(define STAR-COLOR "gold")
;; initial position of square
(define SQUARE-X 460)
(define SQUARE-Y 350)
;; initial square speed
(define SQUARE-VX -13)
(define SQUARE-VY -9)
;; initial square color
(define SQUARE-COLOR "gray")
;; star colors
(define TCOLOR1 "gold")
(define TCOLOR2 "green")
(define TCOLOR3 "blue")
;; square colors
(define QCOLOR1 "gray")
(define QCOLOR2 "olivedrab")
(define QCOLOR3 "khaki")
(define QCOLOR4 "orange")
(define QCOLOR5 "crimson")
;; Star's four vx's
(define tvx1 -12)
(define tvx2 -10)
(define tvx3 12)
(define tvx4 10)
;; Star's four vy's
(define tvy1 10)
(define tvy2 -12)
(define tvy3 -10)
(define tvy4 12)
;; Square's four vx's
(define qvx1 9)
(define qvx2 13)
(define qvx3 -9)
(define qvx4 -13)
;; Square's four vy's
(define qvy1 -13)
(define qvy2 9)
(define qvy3 13)
(define qvy4 -9) 


;; a DoodadType is one of
;; -- "star"
;; -- "square"
;; INTERPRETATION: self-evident
;; TEMPLATE:
;; doodad-type-fn : DoodadType -> ??
#;
(define (doodad-type-fn type)
  (cond
    [(string=? type "star") ...]
    [(string=? type "square") ...]))



(define-struct doodad [x y vx vy color selected? type dx dy age])
;; A Doodad is a structure:
;;  (make-doodad Integer Integer Integer Integer String Boolean
;;               DoodadType Integer Integer NonNegInteger)
;; INTERPRETATION:
;; x is the x-position of the Doodad
;; y is the y-position of the Doodad
;; vx is the x direction velocity of the Doodad
;; vy is the y direction velocity of the Doodad
;; color is the color of the Doodad
;; selected? describes whether or not the Doodad is selected
;; type describes whether the Doodad is a star or a square
;; dx is mouse's x position - x
;; dy is mouse's y position - y
;; age is a non-negative integer represents the number of ticks that have
;;  elapsed since the doodad was added to the world.


;; TEMPLATE:
;; doodad-fn : Doodad -> ??
#;
(define (doodad-fn d)
  (... (doodad-x d)
       (doodad-y d)
       (doodad-vx d)
       (doodad-vy d)
       (doodad-color d)
       (doodad-selected? d)
       (doodad-type d)
       (doodad-dx)
       (doodad-dy)
       (doodad-age)))

;; Examples of Doodads, for testing
(define star-gold-at-top-left (make-doodad 1 1 -10 -12 TCOLOR1 true "star"
                                           0 0 2))
(define star-green-at-top-right (make-doodad 600 1 10 -12 TCOLOR2 false "star"
                                             0 0 3))
(define star-blue-at-bottom-left (make-doodad 0 448 -10 12 TCOLOR3 true "star"
                                              6 6 5))
(define square-gray-at-top-left (make-doodad 1 1 -13 -9 QCOLOR1 true "square"
                                             0 0 7))
(define square-gray-at-bottom-right (make-doodad 600 448 13 9 QCOLOR1 false
                                                 "square" 0 0 2))
(define square-olivedrab-at-bottom (make-doodad 300 448 13 9 QCOLOR2 true
                                                "square" 7 7 8))
(define square-khaki-at-top (make-doodad 300 1 13 -9 QCOLOR3 true "square"
                                         5 7 6))
(define square-orange-at-left (make-doodad 1 225 -13 9 QCOLOR4 true "square"
                                           8 9 9))
(define square-crimson-at-right (make-doodad 600 225 13 9 QCOLOR5 false
                                             "square" 0 0 10))
(define star-gold-at-center (make-doodad 300 225 10 12 TCOLOR1 true "star"
                                         3 8 7))
;; initial Doodad of the RAD-STAR
(define RAD-STAR (make-doodad STAR-X STAR-Y STAR-VX STAR-VY
                              STAR-COLOR false "star" 0 0 0))
;; initial Doodad of the SQUARE
(define SQUARE (make-doodad SQUARE-X SQUARE-Y SQUARE-VX SQUARE-VY
                            SQUARE-COLOR false "square" 0 0 0))


;; A ListOfDoodads (LOD) is either
;; -- empty
;; -- (cons Doodad LOD)
;; INTERPRETATION:
;; empty is a sequence of Doodads with no elements
;; (cons d lst) represents a sequence of Doodads whose first element is d and
;; whose other elements are represented by lst.

;; TEMPLATE:
;; lod-fn : LOD -> ??
;; HALTING MEASURE: length of lst
#;
(define (lod-fn lst)
  (cond
    [(empty? lst) ...]
    [else (...
           (doodad-fn (first lst))
           (lod-fn (rest lst)))]))

;; Example of List of Doodads
(define initial-star-list (cons RAD-STAR empty))
(define initial-square-list (cons SQUARE empty))
(define empty-list-doodad empty)
(define LOD-star1 (cons star-gold-at-top-left (cons star-green-at-top-right
                                               (cons RAD-STAR empty))))
(define LOD-star2 (cons star-gold-at-center
                        (cons star-green-at-top-right
                              (cons star-blue-at-bottom-left empty))))
(define LOD-square1 (cons square-gray-at-top-left
                          (cons square-gray-at-bottom-right
                                (cons square-olivedrab-at-bottom
                                      (cons SQUARE empty)))))
(define LOD-square2 (cons square-crimson-at-right
                          (cons square-orange-at-left
                                (cons square-khaki-at-top empty))))
(define star-list (list star-gold-at-top-left star-green-at-top-right
                    star-blue-at-bottom-left))
(define square-list (list square-orange-at-left))
(define square-empty empty)
(define star-empty empty)



(define-struct world [doodads-star doodads-square paused? tvx tvy qvx qvy])
;; A World is a structure:
;;  (make-world LOD LOD Boolean Integer Integer Integer Integer)
;; INTERPRETATION:
;; doodads-star is a list of radial-star Doodads
;; doodads-square is a list of square Doodads
;; paused? describes whether or not the Doodad is paused.
;; tvx is the last added star's vx
;; tvy is the last added star's vy
;; qvx is the last added square's vx
;; qvy is the last added square's vy

;; TEMPLATE:
;; world-fn : World -> ??
#;
(define (world-fn w)
  (... (world-doodads-star w)
       (world-doodads-square w)
       (world-paused? w)
       (world-tvx w)
       (world-tvy w)
       (world-qvx w)
       (world-qvy w)))


;; Examples of worlds, for testing

(define unpaused-initial-world (make-world initial-star-list
                                           initial-square-list
                                           false 10 12 -13 -9))
(define paused-initial-world (make-world initial-star-list
                                         initial-square-list
                                         true 10 12 -13 -9))
(define unpaused-1 (make-world LOD-star1 initial-square-list false
                               -12 10 9 -13))
(define paused-1 (make-world LOD-star1 initial-square-list true
                             -12 10 9 -13))
(define unpaused-2 (make-world LOD-star1 LOD-square1 false
                               -10 -12 13 9))
(define paused-2 (make-world LOD-star1 LOD-square1 true
                             -10 -12 13 9))
(define unpaused-3 (make-world LOD-star2 LOD-square2 false
                               12 -10 -9 13))
(define unpaused-4 (make-world initial-star-list LOD-square2 false
                               12 -10 -9 13))
(define unpaused-5 (make-world LOD-star2 initial-square-list false
                               -12 10 -13 -9))
(define unpaused-6 (make-world initial-star-list LOD-square1 false
                               -10 -12 -13 -9))
(define unpaused-7 (make-world LOD-star1 LOD-square2 false
                               10 12 9 -13))
(define ex-world3 (make-world star-empty square-list true 10 12 -13 -9))
(define ex-world2 (make-world star-empty square-empty true 10 12 -13 -9))
(define ex-world (make-world star-list square-empty true 10 12 -13 -9))

;; END DATA DEFINITIONS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helper functions:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; in-square? : Doodad Integer Integer -> Boolean
;; GIVEN: a square Doodad, the x and y position of the mouse
;; RETURN: true iff the given coordinate is inside the bounding box of
;;         the square Doodad
;; EXAMPLES:
;; (in-square? SQUARE 30 20) = false
;; (in-square? SQUARE 450 340) = true
;; STRATEGY: Use template for Doodad on d

(define (in-square? d x y)
  (and
   (<= (- (doodad-x d) (/ 71 2)) x (+ (doodad-x d) (/ 71 2)))
   (<= (- (doodad-y d) (/ 71 2)) y (+ (doodad-y d) (/ 71 2)))))


;; in-star? : Doodad Integer Integer -> Boolean
;; GIVEN: a star Doodad, the x and y position of the mouse
;; RETURN: true iff the given coordinate is inside the bounding circle of
;;         the star Doodad
;; EXAMPLES:
;; (in-star? RAD-STAR 20 30) = false
;; (in-star? RAD-STAR 120 110) = true
;; STRATEGY: Use template for Doodad on d

(define (in-star? d x y)
  (<= (+ (sqr (- x (doodad-x d))) (sqr (- y (doodad-y d)))) (sqr 50)))
  

;; doodad-after-button-down : Doodad Integer Integer -> Doodad
;; GIVEN: a Doodad and the location of the button-down
;; RETURNS: the Doodad following a button-down at the given location.
;; if the button-down is inside the Doodad, returns a Doodad just like the
;; given one, except that it is selected.
;; EXAMPLES:
;; (doodad-after-button-down SQUARE 440 330) =
;;    (make-doodad 460 350 -13 -9 "gray" #true "square" -20 -20 0)
;; (doodad-after-button-down RAD-STAR 120 110) =
;;    (make-doodad 125 120 0 0 TCOLOR1 #true "star" -5 -10 0)
;; (doodad-after-button-down RAD-STAR 20 30) =
;;    (make-doodad 125 120 10 12 TCOLOR1 #false "star" 0 0 0)
;; STRATEGY: Use template for Doodad on d

(define (doodad-after-button-down d mx my)
  (cond
    [(and (string=? (doodad-type d) "square") (in-square? d mx my))
     (make-doodad (doodad-x d) (doodad-y d) (doodad-vx d) (doodad-vy d)
                  (doodad-color d) true (doodad-type d) (- mx (doodad-x d))
                  (- my (doodad-y d)) (doodad-age d))]
    [(and (string=? (doodad-type d) "star") (in-star? d mx my))
     (make-doodad (doodad-x d) (doodad-y d) (doodad-vx d) (doodad-vy d)
                  (doodad-color d) true (doodad-type d) (- mx (doodad-x d))
                  (- my (doodad-y d)) (doodad-age d))]
    [else d]))



;; doodad-list-after-button-down : LOD  Integer Integer -> LOD
;; GIVEN: a List of Doodads and the location of the button-down
;; RETURNS: the next List of Doodads follows the one given after button down.
;; EXAMPLES:
;; (doodad-list-after-button-down initial-star-list 120 110) =
;;         (list (make-doodad 125 120 10 12 "gold" #true "star" -5 -10 0))
;; (doodad-list-after-button-down initial-square-list 440 330) =
;;         (list (make-doodad 460 350 -13 -9 "gray" #true "square" -20 -20 0))
;; STRATEGY: Use template for LOD on lst
;; HALTING MEASURE: length of lst
  
(define (doodad-list-after-button-down lst mx my)
  (cond
    [(empty? lst) empty]
    [else (cons
           (doodad-after-button-down (first lst) mx my)
           (doodad-list-after-button-down (rest lst) mx my))]))



;; doodad-after-drag : Doodad Integer Integer -> Doodad
;; GIVEN: a Doodad and the location of the drag event
;; RETURNS: the Doodad following a drag at the given location.
;; if the Doodad is selected, then return a Doodad just like the given
;; one, with the new location, the position of the mouse within the
;; Doodad does not change relative to the Doodad's center.
;; EXAMPLES:
;; (doodad-after-drag star-blue-at-bottom-left 10 438) = 
;;     (make-doodad 4 432 -10 12 TCOLOR3 #true "star" 6 6 5)
;; (doodad-after-drag square-gray-at-bottom-right 590 438) =
;;     (make-doodad 600 448 13 9 QCOLOR1 #false "square" 0 0 2)
;; STRATEGY: Use template for Doodad on d

(define (doodad-after-drag d mx my)
  (if (doodad-selected? d)
      (make-doodad (- mx (doodad-dx d)) (- my (doodad-dy d)) (doodad-vx d)
                   (doodad-vy d) (doodad-color d) true (doodad-type d)
                   (doodad-dx d) (doodad-dy d) (doodad-age d))
      d))
  

;; doodad-list-after-drag : LOD  Integer Integer -> LOD
;; GIVEN: a List of Doodads and the location of the button-down
;; RETURNS: the next List of Doodads follows the one given after drag.
;; EXAMPLES:
;; (doodad-list-after-drag LOD-star1 10 438) =
;;         (list
;;           (make-doodad 10 438 -10 -12 "gold" #true "star" 0 0 2)
;;           (make-doodad 600 1 10 -12 "green" #false "star" 0 0 3)
;;           (make-doodad 125 120 10 12 "gold" #false "star" 0 0 0))
;; (doodad-list-after-drag LOD-square1 590 438) =
;;         (list
;;          (make-doodad 590 438 -13 -9 "gray" #true "square" 0 0 7)
;;          (make-doodad 600 448 13 9 "gray" #false "square" 0 0 2)
;;          (make-doodad 583 431 13 9 "olivedrab" #true "square" 7 7 8)
;;          (make-doodad 460 350 -13 -9 "gray" #false "square" 0 0 0))
;; STRATEGY: Use template for LOD on lst
;; HALTING MEASURE: length of lst
  
(define (doodad-list-after-drag lst mx my)
  (cond
    [(empty? lst) empty]
    [else (cons
           (doodad-after-drag (first lst) mx my)
           (doodad-list-after-drag (rest lst) mx my))]))



;; doodad-after-button-up : Doodad Integer Integer -> Doodad
;; GIVEN: a Doodad and the location of the button up
;; RETURNS: the Doodad following a button-up at the given location.
;; if the Doodad is selected, return a Doodad just like the given one,
;; except that it is no longer selected.
;; EXAMPLES:
;; (doodad-after-button-up star-green-at-top-right 590 10) =
;;      (make-doodad 600 1 10 -12 TCOLOR2 #false "star" 0 0 3)
;; (doodad-after-button-up square-khaki-at-top 302 10) =
;;      (make-doodad 300 1 13 -9 QCOLOR3 #false "square" 0 0 6)
;; (doodad-after-button-up square-gray-at-bottom-right 10 10) =
;;      (make-doodad 600 448 13 9 QCOLOR1 #false "square" 0 0 2)
;; STRATEGY: use template for Doodad on d

(define (doodad-after-button-up d mx my)
  (if (doodad-selected? d)
      (make-doodad (doodad-x d) (doodad-y d) (doodad-vx d)
                   (doodad-vy d) (doodad-color d) false (doodad-type d) 0 0
                   (doodad-age d))
      d))


;; doodad-list-after-button-up : LOD  Integer Integer -> LOD
;; GIVEN: a List of Doodads and the location of the button-down
;; RETURNS: the next List of Doodads follows the one given after button up.
;; EXAMPLES:
;; (doodad-list-after-button-up LOD-star1 590 10) =
;;          (list
;;           (make-doodad 1 1 -10 -12 "gold" #false "star" 0 0 2)
;;           (make-doodad 600 1 10 -12 "green" #false "star" 0 0 3)
;;           (make-doodad 125 120 10 12 "gold" #false "star" 0 0 0))
;; STRATEGY: Use template for LOD on lst
;; HALTING MEASURE: length of lst
  
(define (doodad-list-after-button-up lst mx my)
  (cond
    [(empty? lst) empty]
    [else (cons
           (doodad-after-button-up (first lst) mx my)
           (doodad-list-after-button-up (rest lst) mx my))]))


;; world-after-button-down : World Integer Integer -> World
;; GIVEN: a World and the location of the button-down
;; RETURNS: the World following a button-down at the given location.
;; if the button-down is inside the Doodad, returns a World just like the
;; given one, with the new Doodads.
;; EXAMPLES:
;; (world-after-button-down unpaused-initial-world 2 2) =
;;            (make-world
;;             (list (make-doodad 125 120 10 12 "gold" #false "star" 0 0 0))
;;             (list (make-doodad 460 350 -13 -9 "gray" #false "square" 0 0 0))
;;             #false 10 12 -13 -9)
;; (world-after-button-down unpaused-1 10 10) =
;;            (make-world
;;             (list
;;              (make-doodad 1 1 -10 -12 "gold" #true "star" 9 9 2)
;;              (make-doodad 600 1 10 -12 "green" #false "star" 0 0 3)
;;              (make-doodad 125 120 10 12 "gold" #false "star" 0 0 0))
;;             (list (make-doodad 460 350 -13 -9 "gray" #false "square" 0 0 0))
;;             #false  -12 10 9 -13)
;; STRATEGY: Use template for World on w
  
(define (world-after-button-down w mx my)
  (make-world (doodad-list-after-button-down (world-doodads-star w) mx my)
              (doodad-list-after-button-down (world-doodads-square w) mx my)
              (world-paused? w)
              (world-tvx w)
              (world-tvy w)
              (world-qvx w)
              (world-qvy w)))


;; world-after-drag : World Integer Integer -> World
;; GIVEN: a World and the location of the drag event
;; RETURNS: the World following a drag at the given location.
;; EXAMPLES:
;; (world-after-drag unpaused-3 10 438) =
;;         (make-world
;;          (list
;;           (make-doodad 7 430 10 12 "gold" #true "star" 3 8 7)
;;           (make-doodad 600 1 10 -12 "green" #false "star" 0 0 3))
;;          (list
;;           (make-doodad 5 431 13 -9 "khaki" #true "square" 5 7 6)
;;           (make-doodad 2 429 -13 9 "orange" #true "square" 8 9 9)
;;           (make-doodad 600 225 13 9 "crimson" #false "square" 0 0 10))
;;          #false 12 -10 -9 13)
;; (world-after-drag paused-2 590 438) =
;;         (make-world
;;          (list
;;           (make-doodad 590 438 -10 -12 "gold" #true "star" 0 0 2)
;;           (make-doodad 600 1 10 -12 "green" #false "star" 0 0 3)
;;           (make-doodad 125 120 10 12 "gold" #false "star" 0 0 0))
;;          (list
;;           (make-doodad 590 438 -13 -9 "gray" #true "square" 0 0 7)
;;           (make-doodad 600 448 13 9 "gray" #false "square" 0 0 2)
;;           (make-doodad 583 431 13 9 "olivedrab" #true "square" 7 7 8)
;;           (make-doodad 460 350 -13 -9 "gray" #false "square" 0 0 0))
;;          #true -10 -12 13 9)
;; STRATEGY: Use template for World on w

(define (world-after-drag w mx my)
  (make-world (doodad-list-after-drag (world-doodads-star w) mx my)
              (doodad-list-after-drag (world-doodads-square w) mx my)
              (world-paused? w)
              (world-tvx w)
              (world-tvy w)
              (world-qvx w)
              (world-qvy w)))


;; world-after-button-up : World Integer Integer -> World
;; GIVEN: a World and the location of the button up
;; RETURNS: the World following a button-up at the given location.
;; EXAMPLE:
;; (world-after-button-up unpaused-2 590 10) =
;;         (make-world
;;          (list
;;           (make-doodad 1 1 -10 -12 "gold" #false "star" 0 0 2)
;;           (make-doodad 600 1 10 -12 "green" #false "star" 0 0 3)
;;           (make-doodad 125 120 10 12 "gold" #false "star" 0 0 0))
;;          (list
;;           (make-doodad 1 1 -13 -9 "gray" #false "square" 0 0 7)
;;           (make-doodad 600 448 13 9 "gray" #false "square" 0 0 2)
;;           (make-doodad 300 448 13 9 "olivedrab" #false "square" 0 0 8)
;;           (make-doodad 460 350 -13 -9 "gray" #false "square" 0 0 0))
;;          #false  -10 -12 13 9)
;; (world-after-button-up unpaused-4 302 10) =
;;         (make-world
;;          (list (make-doodad 125 120 10 12 "gold" #false "star" 0 0 0))
;;          (list
;;           (make-doodad 300 1 13 -9 "khaki" #false "square" 0 0 6)
;;           (make-doodad 1 225 -13 9 "orange" #false "square" 0 0 9)
;;           (make-doodad 600 225 13 9 "crimson" #false "square" 0 0 10))
;;          #false 12 -10 -9 13)
;; STRATEGY: use template for World on w

(define (world-after-button-up w mx my)
  (make-world (doodad-list-after-button-up (world-doodads-star w) mx my)
              (doodad-list-after-button-up (world-doodads-square w) mx my)
              (world-paused? w)
              (world-tvx w)
              (world-tvy w)
              (world-qvx w)
              (world-qvy w)))


;; star-to-scene : World -> Scene
;; GIVEN: a World 
;; RETURNS: a Scene that portrays the given World.
;; EXAMPLE:
;; (define star-list (list star-gold-at-top-left star-green-at-top-right
;;                    star-blue-at-bottom-left))
;; (define square-list empty)
;; (define ex-world (make-world star-list square-list true 10 12 -13 -9))
;; (star-to-scene ex-world) = (place-image (radial-star 8 10 50 "solid" "gold")
;;                             1 1 (place-image (radial-star 8 10 50 "solid"
;;                             "green") 600 1 (place-image (radial-star 8 10 50
;;                             "solid" "blue") 0 448 EMPTY-CANVAS)))
;; STRATEGY: Use template for World on w

(define (star-to-scene w)
  (cond
    [(empty? (world-doodads-star w)) EMPTY-CANVAS]
    [else (place-image (radial-star 8 10 50 "solid"
                               (doodad-color (first (world-doodads-star w))))
                       (doodad-x (first (world-doodads-star w)))
                       (doodad-y (first (world-doodads-star w)))
                       (star-to-scene (make-world (rest (world-doodads-star w))
                                                  (world-doodads-square w)
                                                  (world-paused? w)
                                                  (world-tvx w)
                                                  (world-tvy w)
                                                  (world-qvx w)
                                                  (world-qvy w))))]))
     
                  

;; TESTS:
(begin-for-test
  (check-equal?
    (star-to-scene ex-world)
    (place-image (radial-star 8 10 50 "solid" "gold")
                             1 1 (place-image (radial-star 8 10 50 "solid"
                             "green") 600 1 (place-image (radial-star 8 10 50
                             "solid" "blue") 0 448 EMPTY-CANVAS)))
    "(star-to-scene ex-world) returned incorrect image")

  (check-equal?
    (star-to-scene ex-world2)
    EMPTY-CANVAS
    "(star-to-scene ex-world2) returned incorrect image"))


;; square-to-scene : World -> Scene
;; GIVEN: a World 
;; RETURNS: a Scene that portrays the given world.
;; EXAMPLE:
;; (square-to-scene ex-world3) =
;;       (place-image (square 71 "solid" "orange") 1 225 EMPTY-CANVAS)
;; (square-to-scene ex-world2) =
;;       EMPTY-CANVAS
;; STRATEGY: Use template for World on w

(define (square-to-scene w)
  (cond
    [(empty? (world-doodads-square w)) (star-to-scene w)]
    [else (place-image (square 71 "solid"
                               (doodad-color (first (world-doodads-square w))))
                       (doodad-x (first (world-doodads-square w)))
                       (doodad-y (first (world-doodads-square w)))
                       (square-to-scene (make-world
                                         (world-doodads-star w)
                                         (rest (world-doodads-square w))
                                         (world-paused? w)
                                         (world-tvx w)
                                         (world-tvy w)
                                         (world-qvx w)
                                         (world-qvy w))))]))

;; TEST:                                 
(begin-for-test
  (check-equal?
    (square-to-scene ex-world3)
    (place-image (square 71 "solid" "orange") 1 225 EMPTY-CANVAS)
    "(square-to-scene ex-world3) returned incorrect image")
  (check-equal?
    (square-to-scene ex-world2)
    EMPTY-CANVAS
    "(square-to-scene ex-world2) returned incorrect image"))


;; first-selected-doodad : LOD -> LOD
;; GIVEN: a List of Doodads
;; RETURNS: a the List of the first Doodad in the List of Doodads that is
;;          selected by mouse, otherwise returns empty List.
;; EXAMPLE:
;; (first-selected-doodad initial-star-list) = empty
;; (first-selected-doodad  LOD-star1) =
;;       (list (make-doodad 1 1 -10 -12 "gold" #true "star" 0 0 2))
;; STRATEGY: Use template for LOD on lst
;; HALTING MEASURE: length of lst

(define (first-selected-doodad lst)
  (cond
    [(empty? lst) empty]
    [else (if (doodad-selected? (first lst))
              (cons (first lst) empty)
              (first-selected-doodad (rest lst)))]))

;; TEST:
(begin-for-test
  (check-equal?
    (first-selected-doodad LOD-square2)
    (list (make-doodad 1 225 -13 9 "orange" #true "square" 8 9 9))
    "(first-selected-doodad LOD-star1) returned incorrect list"))


;; world-to-scene : World -> Scene
;; GIVEN: a World 
;; RETURNS: a Scene that portrays the given world.
;; EXAMPLE:
;; (world-to-scene ex-world2) = EMPTY-CANVAS
;; (world-to-scene ex-world3) = (place-image (circle 3 "solid" "black") 9 234
;;             (place-image (square 71 "solid" "orange") 1 225 EMPTY-CANVAS))
;; (world-to-scene ex-world) = (place-image (circle 3 "solid" "black") 1 1
;;             (place-image (radial-star 8 10 50 "solid" "gold")
;;                           1 1 (place-image (radial-star 8 10 50 "solid"
;;                           "green") 600 1 (place-image (radial-star 8 10 50
;;                           "solid" "blue") 0 448 EMPTY-CANVAS))))
;; STRATEGY: Use template for World on w

(define (world-to-scene w)
  (cond
    [(not (empty? (first-selected-doodad (world-doodads-star w))))
     (place-image (circle 3 "solid" "black")
                  (+ (doodad-x (first (first-selected-doodad
                                       (world-doodads-star w))))
                     (doodad-dx (first (first-selected-doodad
                                        (world-doodads-star w)))))
                  (+ (doodad-y (first (first-selected-doodad
                                       (world-doodads-star w))))
                     (doodad-dy (first (first-selected-doodad
                                        (world-doodads-star w)))))
                  (square-to-scene w))]
    [(not (empty? (first-selected-doodad (world-doodads-square w))))
     (place-image (circle 3 "solid" "black")
                  (+ (doodad-x (first (first-selected-doodad
                                       (world-doodads-square w))))
                     (doodad-dx (first (first-selected-doodad
                                        (world-doodads-square w)))))
                  (+ (doodad-y (first (first-selected-doodad
                                       (world-doodads-square w))))
                     (doodad-dy (first (first-selected-doodad
                                        (world-doodads-square w)))))
                  (square-to-scene w))]
    [else (square-to-scene w)]))


;; TEST:
(begin-for-test
  (check-equal?
    (world-to-scene ex-world2) EMPTY-CANVAS
    "(world-to-scene ex-world2) returned incorrect image")
  (check-equal?
    (world-to-scene ex-world3)
    (place-image (circle 3 "solid" "black") 9 234
                 (place-image (square 71 "solid" "orange") 1 225 EMPTY-CANVAS))
    "(world-to-scene ex-world3) returned incorrect image")
  (check-equal?
    (world-to-scene ex-world)
    (place-image (circle 3 "solid" "black") 1 1
                 (place-image (radial-star 8 10 50 "solid" "gold") 1 1
                    (place-image (radial-star 8 10 50 "solid" "green") 600 1
                       (place-image (radial-star 8 10 50 "solid" "blue") 0 448
                           EMPTY-CANVAS))))
    "(world-to-scene ex-world) returned incorrect image"))


;; next-color: Color -> Color
;; GIVEN: a Color by DrRacket's image-color? predicate.
;; RETURNS: the next Color of the Doodad
;; EXAMPLE:
;; (next-color TCOLOR1) = TCOLOR2
;; (next-color TCOLOR2) = TCOLOR3
;; (next-color TCOLOR3) = TCOLOR1
;; STRATEGY: combine simpler functions

(define (next-color color)
  (cond
    [(string=? color TCOLOR1) TCOLOR2]
    [(string=? color TCOLOR2) TCOLOR3]
    [(string=? color TCOLOR3) TCOLOR1]
    [(string=? color QCOLOR1) QCOLOR2]
    [(string=? color QCOLOR2) QCOLOR3]
    [(string=? color QCOLOR3) QCOLOR4]
    [(string=? color QCOLOR4) QCOLOR5]
    [(string=? color QCOLOR5) QCOLOR1]))


;; x-lowerbound?: Doodad -> Boolean
;; GIVEN: a Doodad
;; RETURNS: true if tentative position of the doodad is below x's lower
;;          boundary.
;; EXAMPLES:
;; (x-lowerbound? star-gold-at-top-left) = true
;; (x-lowerbound? star-green-at-top-right) = false
;; STRATEGY: Use template for Doodad on d

(define (x-lowerbound? d)
  (if (< (+ (doodad-x d) (doodad-vx d)) 0) true false))


;; x-upperbound?: Doodad -> Boolean
;; GIVEN: a Doodad
;; RETURNS: true if tentative position of the doodad is above x's upper
;;          boundary.
;; EXAMPLES:
;; (x-upperbound? star-green-at-top-right) = true
;; (x-upperbound? star-gold-at-top-left) = false
;; STRATEGY: Use template for Doodad on d

(define (x-upperbound? d)
  (if (>= (+ (doodad-x d) (doodad-vx d)) CANVAS-WIDTH) true false))


;; y-lowerbound?: Doodad -> Boolean
;; GIVEN: a Doodad
;; RETURNS: true if tentative position of the doodad is below y's lower
;;          boundary.
;; EXAMPLES:
;; (y-lowerbound? star-blue-at-bottom-left) = false
;; STRATEGY: Use template for Doodad on d

(define (y-lowerbound? d)
  (if (< (+ (doodad-y d) (doodad-vy d)) 0) true false))


;; y-upperbound?: Doodad -> Boolean
;; GIVEN: a Doodad
;; RETURNS: true if tentative position of the doodad is above y's upper
;;          boundary.
;; EXAMPLES:
;; (y-upperbound? star-blue-at-bottom-left) = true
;; STRATEGY: Use template for Doodad on d

(define (y-upperbound? d)
  (if (>= (+ (doodad-y d) (doodad-vy d)) CANVAS-HEIGHT) true false))


;; new-x: Doodad -> Integer
;; GIVEN: a Doodad
;; RETURNS: the new x position of the Doodad
;; EXAMPLES:
;; (new-x RAD-STAR) = 135
;; (new-x star-gold-at-top-left) = 9
;; STRATEGY: Use template for Doodad on d

(define (new-x d)
  (cond
    [(x-lowerbound? d) (abs (+ (doodad-x d) (doodad-vx d)))]
    [(x-upperbound? d) (- (* (- CANVAS-WIDTH 1) 2)
                          (+ (doodad-x d) (doodad-vx d)))]
    [(doodad-selected? d) (doodad-x d)]
    [else (+ (doodad-x d) (doodad-vx d))]))


;; new-y: Doodad -> Integer
;; GIVEN: a Doodad
;; RETURNS: the new y position of the Doodad
;; EXAMPLES:
;; (new-y star-gold-at-top-left) = 11
;; (new-y RAD-STAR) = 132
;; STRATEGY: Use template for Doodad on d

(define (new-y d)
  (cond
    [(y-lowerbound? d) (abs (+ (doodad-y d) (doodad-vy d)))]
    [(y-upperbound? d) (- (* (- CANVAS-HEIGHT 1) 2)
                          (+ (doodad-y d) (doodad-vy d)))]
    [(doodad-selected? d) (doodad-y d)]
    [else (+ (doodad-y d) (doodad-vy d))]))


;; new-vx: Doodad -> Integer
;; GIVEN: a Doodad
;; RETURNS: the new vx of the Doodad
;; EXAMPLES:
;; (new-vx RAD-STAR) = 10
;; (new-vx star-gold-at-top-left) = 10
;; STRATEGY: Use template for Doodad on d

(define (new-vx d)
  (cond
    [(or (x-lowerbound? d) (x-upperbound? d)) (- 0 (doodad-vx d))]
    [else (doodad-vx d)]))


;; new-vy: Doodad -> Integer
;; GIVEN: a Doodad
;; RETURNS: the new vy of the Doodad
;; EXAMPLES:
;; (new-vy star-gold-at-top-left) = 12
;; (new-vy RAD-STAR) = 12
;; STRATEGY: Use template for Doodad on d

(define (new-vy d)
  (cond
    [(or (y-lowerbound? d) (y-upperbound? d)) (- 0 (doodad-vy d))]
    [else (doodad-vy d)]))


;; new-age: Doodad -> Integer
;; GIVEN: a Doodad
;; RETURNS: the new age of the Doodad
;; EXAMPLES:
;; (new-age star-gold-at-top-left) = 3
;; (new-age RAD-STAR) = 1
;; STRATEGY: Use template for Doodad on d

(define (new-age d)
  (add1 (doodad-age d)))


;; construct-new-doodad: Doodad -> Doodad
;; GIVEN: a Doodad
;; RETURNS: a construct a new Doodad from the new-x, new-y, new-vx,
;;          new-vy, next-color if there is a corebounce.
;; EXAMPLES:
;; (construct-new-doodad square-gray-at-top-left) =
;;        (make-doodad 12 8 13 9 "olivedrab" #true "square" 0 0 8)
;; (construct-new-doodad star-gold-at-top-left) =
;;        (make-doodad 9 11 10 12 "green" #true "star" 0 0 3)
;; STRATEGY: Use template for Doodad on d

(define (construct-new-doodad d)
  (if (or (x-lowerbound? d) (x-upperbound? d)
          (y-lowerbound? d) (y-upperbound? d))
      (make-doodad (new-x d) (new-y d) (new-vx d) (new-vy d)
                  (next-color (doodad-color d)) (doodad-selected? d)
                  (doodad-type d) (doodad-dx d) (doodad-dy d) (new-age d))
      (make-doodad (new-x d) (new-y d) (new-vx d) (new-vy d)
                  (doodad-color d) (doodad-selected? d)
                  (doodad-type d) (doodad-dx d) (doodad-dy d) (new-age d))))

;; construct-doodad-aged: Doodad -> Doodad
;; GIVEN: a Doodad
;; RETURNS: a construct a new Doodad from the old Doodad with only the age
;;          changed.
;; EXAMPLES:
;; (construct-doodad-aged square-gray-at-top-left) =
;;       (make-doodad 1 1 -13 -9 "gray" #true "square" 0 0 8)
;; (construct-doodad-aged star-gold-at-top-left) =
;;       (make-doodad 1 1 -10 -12 "gold" #true "star" 0 0 3)
;; STRATEGY: Use template for Doodad on d


(define (construct-doodad-aged d)
  (make-doodad (doodad-x d) (doodad-y d) (doodad-vx d) (doodad-vy d)
               (doodad-color d) (doodad-selected? d)
               (doodad-type d) (doodad-dx d) (doodad-dy d) (new-age d)))



;; construct-doodad-aged-list : LOD -> LOD
;; GIVEN: a List of Doodads
;; RETURNS: the next List of Doodads follows the one given.
;; EXAMPLES:
;; (construct-doodad-aged-list empty-list-doodad) = empty
;; (construct-doodad-aged-list square-list) =
;;        (list (make-doodad 1 225 -13 9 "orange" #true "square" 8 9 10))
;; STRATEGY: Use template for LOD on lst
;; HALTING MEASURE: length of lst
  
(define (construct-doodad-aged-list lst)
  (cond
    [(empty? lst) empty]
    [else (cons
           (construct-doodad-aged (first lst))
           (construct-doodad-aged-list (rest lst)))]))




;; next-doodad : Doodad -> Doodad
;; GIVEN: a Doodad
;; RETURNS: the next Doodad follows the one given.
;; EXAMPLES:
;; (next-doodad star-gold-at-top-left) =
;;      (make-doodad 9 11 10 12 "green" #true "star" 0 0 3)
;; (next-doodad RAD-STAR) =
;;      (make-doodad 135 132 10 12 "gold" #false "star" 0 0 1)
;; (next-doodad square-orange-at-left) =
;;      (make-doodad 12 225 13 9 "crimson" #true "square" 8 9 10)
;; STRATEGY: Use template for Doodad on d

(define (next-doodad d)
  (cond
    [(and (x-lowerbound? d) (y-lowerbound? d)) (construct-new-doodad d)]
    [(and (x-upperbound? d) (y-lowerbound? d)) (construct-new-doodad d)]
    [(and (x-upperbound? d) (y-upperbound? d)) (construct-new-doodad d)]
    [(and (x-lowerbound? d) (y-upperbound? d)) (construct-new-doodad d)]
    [(x-lowerbound? d) (construct-new-doodad d)]
    [(x-upperbound? d) (construct-new-doodad d)]
    [(y-lowerbound? d) (construct-new-doodad d)]
    [(y-upperbound? d) (construct-new-doodad d)]
    [else (construct-new-doodad d)]))


  
;; next-doodad-list: LOD -> LOD
;; GIVEN: a List of Doodads
;; RETURNS: the next List of Doodads follows the one given.
;; EXAMPLES:
;; (next-doodad-list empty-list-doodad) = empty
;; (next-doodad-list square-list) =
;;      (list (make-doodad 12 225 13 9 "crimson" #true "square" 8 9 10))
;; STRATEGY: Use template for LOD on lst
;; HALTING MEASURE: length of lst
  
(define (next-doodad-list lst)
  (cond
    [(empty? lst) empty]
    [else (cons
           (next-doodad (first lst))
           (next-doodad-list (rest lst)))]))

;; TESTS:

(begin-for-test
  (check-equal? (next-doodad-list LOD-star1)
                (list
                 (make-doodad 9 11 10 12 "green" #true "star" 0 0 3)
                 (make-doodad 590 11 -10 12 "blue" #false "star" 0 0 4)
                 (make-doodad 135 132 10 12 "gold" #false "star" 0 0 1))
    "(next-doodad-list LOD-star1) returned the incorrect list.")
  (check-equal? (next-doodad-list LOD-star2)
                (list
                 (make-doodad 300 225 10 12 "gold" #true "star" 3 8 8)
                 (make-doodad 590 11 -10 12 "blue" #false "star" 0 0 4)
                 (make-doodad 10 436 10 -12 "gold" #true "star" 6 6 6))
    "(next-doodad-list LOD-star2) returned the incorrect list.")
  (check-equal? (next-doodad-list LOD-square1)
                (list
                 (make-doodad 12 8 13 9 "olivedrab" #true "square" 0 0 8)
                 (make-doodad 587 439 -13 -9 "olivedrab" #false "square" 0 0 3)
                 (make-doodad 300 439 13 -9 "khaki" #true "square" 7 7 9)
                 (make-doodad 447 341 -13 -9 "gray" #false "square" 0 0 1))
    "(next-doodad-list LOD-square1) returned the incorrect list.")
  (check-equal? (next-doodad-list LOD-square2)
                (list
                 (make-doodad 587 234 -13 9 "gray" #false "square" 0 0 11)
                 (make-doodad 12 225 13 9 "crimson" #true "square" 8 9 10)
                 (make-doodad 300 8 13 9 "orange" #true "square" 5 7 7))
    "(next-doodad-list LOD-square2) returned the incorrect list.")
  (check-equal? (next-doodad-list empty-list-doodad)
                empty
    "(next-doodad-list empty-list-doodad) returned the incorrect list."))


;; is-pause-key-event? : KeyEvent -> Boolean
;; GIVEN: a KeyEvent
;; RETURNS: true iff the KeyEvent represents a pause instruction
;; EXAMPLE:
;; (is-pause-key-event? " ") = true
;; (is-pause-key-event? "q") = false
;; STRATEGY: Combine simpler functions

(define (is-pause-key-event? ke)
  (key=? ke " "))

;; TESTS:
(begin-for-test
  (check-equal? (is-pause-key-event? " ") true
    "(is-pause-key-event? ' ') should return true")
  (check-equal? (is-pause-key-event? "q") false
    "(is-pause-key-event? 'q') should return false"))


  
;; next-tvx : Integer -> Integer
;; GIVEN: a star Doodad's vx
;; RETURNS: the next star Doodad's vx
;; EXAMPLE:
;; (next-tvx -12) = -10
;; (next-tvx -10) = 12
;; STRATEGY: combine simpler functions

(define (next-tvx starvx)
  (cond
    [(= starvx tvx1) tvx2]
    [(= starvx tvx2) tvx3]
    [(= starvx tvx3) tvx4]
    [(= starvx tvx4) tvx1]))

;; TESTS:
(begin-for-test
  (check-equal? (next-tvx -12) -10
    "(next-tvx -12) should return -10")
  (check-equal? (next-tvx -10) 12
    "(next-tvx -10) should return 12")
  (check-equal? (next-tvx 12) 10
    "(next-tvx 12) should return 10")
  (check-equal? (next-tvx 10) -12
    "(next-tvx 10) should return -12"))




;; next-tvy : Integer -> Integer
;; GIVEN: a star Doodad's vy
;; RETURNS: the next star Doodad's vy
;; EXAMPLE:
;; (next-tvy -12) = -10
;; (next-tvy -10) = 12
;; STRATEGY: combine simpler functions

(define (next-tvy starvy)
  (cond
    [(= starvy tvy1) tvy2]
    [(= starvy tvy2) tvy3]
    [(= starvy tvy3) tvy4]
    [(= starvy tvy4) tvy1]))

;; TESTS:
(begin-for-test
  (check-equal? (next-tvy -12) -10
    "(next-tvy -12) should return -10")
  (check-equal? (next-tvy -10) 12
    "(next-tvy -10) should return 12")
  (check-equal? (next-tvy 12) 10
    "(next-tvy 12) should return 10")
  (check-equal? (next-tvy 10) -12
    "(next-tvy 10) should return -12"))


;; next-qvx : Integer -> Integer
;; GIVEN: a square Doodad's vx
;; RETURNS: the next square Doodad's vx
;; EXAMPLE:
;; (next-qvx -13) = 9
;; (next-qvx 9) = 13
;; STRATEGY: combine simpler functions

(define (next-qvx squarevx)
  (cond
    [(= squarevx qvx1) qvx2]
    [(= squarevx qvx2) qvx3]
    [(= squarevx qvx3) qvx4]
    [(= squarevx qvx4) qvx1]))

;; TESTS:
(begin-for-test
  (check-equal? (next-qvx -13) 9
    "(next-qvx -13) should return 9")
  (check-equal? (next-qvx 9) 13
    "(next-qvx 9) should return 13")
  (check-equal? (next-qvx 13) -9
    "(next-qvx 13) should return -9")
  (check-equal? (next-qvx -9) -13
    "(next-qvx -9) should return -13"))


;; next-qvy : Integer -> Integer
;; GIVEN: a square Doodad's vy
;; RETURNS: the next square Doodad's vy
;; EXAMPLE:
;; (next-qvy -13) = 9
;; (next-qvy 9) = 13
;; STRATEGY: combine simpler functions

(define (next-qvy squarevy)
  (cond
    [(= squarevy qvy1) qvy2]
    [(= squarevy qvy2) qvy3]
    [(= squarevy qvy3) qvy4]
    [(= squarevy qvy4) qvy1]))

;; TESTS:
(begin-for-test
  (check-equal? (next-qvy -13) 9
    "(next-qvy -13) should return 9")
  (check-equal? (next-qvy 9) 13
    "(next-qvy 9) should return 13")
  (check-equal? (next-qvy 13) -9
    "(next-qvy 13) should return -9")
  (check-equal? (next-qvy -9) -13
    "(next-qvy -9) should return -13"))

  
;; t-key-event-add-star : World -> World
;; GIVEN: a World
;; RETURNS: a World with one more star added to the List of star Doodads
;;          of the World
;; EXAMPLE:
;; (t-key-event-add-star unpaused-3) =
;;           (make-world
;;            (list
;;             (make-doodad 125 120 10 12 "gold" #false "star" 0 0 0)
;;             (make-doodad 300 225 10 12 "gold" #true "star" 3 8 7)
;;             (make-doodad 600 1 10 -12 "green" #false "star" 0 0 3)
;;             (make-doodad 0 448 -10 12 "blue" #true "star" 6 6 5))
;;            (list
;;             (make-doodad 600 225 13 9 "crimson" #false "square" 0 0 10)
;;             (make-doodad 1 225 -13 9 "orange" #true "square" 8 9 9)
;;             (make-doodad 300 1 13 -9 "khaki" #true "square" 5 7 6))
;;            #false 10 12 -9 13)
;; (t-key-event-add-star paused-initial-world) =
;;           (make-world
;;            (list
;;             (make-doodad 125 120 -12 10 "gold" #false "star" 0 0 0)
;;             (make-doodad 125 120 10 12 "gold" #false "star" 0 0 0))
;;            (list (make-doodad 460 350 -13 -9 "gray" #false "square" 0 0 0))
;;            #true -12 10 -13 -9)
;; STRATEGY: Use template for World on w

(define (t-key-event-add-star w)
  (make-world (cons (make-doodad STAR-X STAR-Y (next-tvx (world-tvx w))
                                 (next-tvy (world-tvy w)) STAR-COLOR
                                 false "star" 0 0 0) (world-doodads-star w))
              (world-doodads-square w)
              (world-paused? w)
              (next-tvx (world-tvx w))
              (next-tvy (world-tvy w))
              (world-qvx w)
              (world-qvy w)))


;; q-key-event-add-square : World -> World
;; GIVEN: a World
;; RETURNS: a World with one more square added to the List of square Doodads
;;          of the World
;; EXAMPLE:
;; (q-key-event-add-square unpaused-1) =
;;          (make-world
;;           (list
;;            (make-doodad 1 1 -10 -12 "gold" #true "star" 0 0 2)
;;            (make-doodad 600 1 10 -12 "green" #false "star" 0 0 3)
;;            (make-doodad 125 120 10 12 "gold" #false "star" 0 0 0))
;;           (list
;;            (make-doodad 460 350 13 9 "gray" #false "square" 0 0 0)
;;            (make-doodad 460 350 -13 -9 "gray" #false "square" 0 0 0))
;;           #false -12 10 13 9)
;; (q-key-event-add-square paused-1) =
;;          (make-world
;;           (list
;;            (make-doodad 1 1 -10 -12 "gold" #true "star" 0 0 2)
;;            (make-doodad 600 1 10 -12 "green" #false "star" 0 0 3)
;;            (make-doodad 125 120 10 12 "gold" #false "star" 0 0 0))
;;           (list
;;            (make-doodad 460 350 13 9 "gray" #false "square" 0 0 0)
;;            (make-doodad 460 350 -13 -9 "gray" #false "square" 0 0 0))
;;           #true -12 10 13 9)
;; STRATEGY: Use template for World on w

(define (q-key-event-add-square w)
  (make-world (world-doodads-star w)
              (cons (make-doodad SQUARE-X SQUARE-Y (next-qvx (world-qvx w))
                                 (next-qvy (world-qvy w)) SQUARE-COLOR
                                 false "square" 0 0 0) (world-doodads-square w))
              (world-paused? w)
              (world-tvx w)
              (world-tvy w)
              (next-qvx (world-qvx w))
              (next-qvy (world-qvy w))))


;; oldest-doodad-age : LOD -> NonNegInteger
;; GIVEN: a non empty List of Doodads
;; RETURNS: the age of the oldest Doodad or Doodads
;; EXAMPLE:
;; (oldest-doodad-age LOD-star1) = 3
;; (oldest-doodad-age LOD-star2) = 7
;; STRATEGY: Use template for LOD on lst
;; HALTING MEASURE: length of lst

(define (oldest-doodad-age lst)
  (cond
    [(empty? (rest lst)) (doodad-age (first lst))]
    [else (if (< (doodad-age (first lst)) (oldest-doodad-age (rest lst)))
              (oldest-doodad-age (rest lst))
              (doodad-age (first lst)))]))

;; TESTS:
(begin-for-test
  (check-equal? (oldest-doodad-age LOD-star1) 3
    "(oldest-doodad-age LOD-star1) should return 3"))

;; doodad-remove : LOD NonNegInteger-> LOD
;; GIVEN: a List of Doodads and a NonNegInteger
;; RETURNS: a List of Doodads with the oldest Doodad or Doodads removed
;; EXAMPLES:
;; (doodad-remove empty 4) = empty
;; (doodad-remove LOD-star1 3) =
;;       (list
;;        (make-doodad 1 1 -10 -12 "gold" #true "star" 0 0 2)
;;        (make-doodad 125 120 10 12 "gold" #false "star" 0 0 0))
;; STRATEGY: Use template for LOD on lst
;; HALTING MEASURE: length of lst

(define (doodad-remove lst n)
  (cond
    [(empty? lst) empty]
    [else (if (= n (doodad-age (first lst)))
              (doodad-remove (rest lst) n)
              (cons (first lst) (doodad-remove (rest lst) n)))]))

;; TESTS:
(begin-for-test
  (check-equal? (doodad-remove empty 4) empty
    "(doodad-remove empty 4) should return empty.")
  (check-equal? (doodad-remove LOD-star1 3)
                (list
                 (make-doodad 1 1 -10 -12 "gold" #true "star" 0 0 2)
                 (make-doodad 125 120 10 12 "gold" #false "star" 0 0 0))
    "(doodad-remove LOD-star1 3) returned incorrect list."))

;; dot-key-event-remove : World -> World
;; GIVEN: a World
;; RETURNS: a World with one the oldest square or squares and the oldest star
;;          or stars removed. 
;; EXAMPLE:
;; (dot-key-event-remove paused-initial-world) =
;;        (make-world '() '() #true 10 12 -13 -9)
;; (dot-key-event-remove paused-1) =
;;        (make-world
;;         (list
;;          (make-doodad 1 1 -10 -12 "gold" #true "star" 0 0 2)
;;          (make-doodad 125 120 10 12 "gold" #false "star" 0 0 0))
;;         '()
;;         #true -12 10 9  -13)
;; (dot-key-event-remove unpaused-2) =
;;        (make-world
;;         (list
;;          (make-doodad 1 1 -10 -12 "gold" #true "star" 0 0 2)
;;          (make-doodad 125 120 10 12 "gold" #false "star" 0 0 0))
;;         (list
;;          (make-doodad 1 1 -13 -9 "gray" #true "square" 0 0 7)
;;          (make-doodad 600 448 13 9 "gray" #false "square" 0 0 2)
;;          (make-doodad 460 350 -13 -9 "gray" #false "square" 0 0 0))
;;         #false -10 -12 13 9)
;; STRATEGY: Use template for World on w

(define (dot-key-event-remove w)
  (cond
    [(and (empty? (world-doodads-star w)) (empty? (world-doodads-square w)))
     w]
    [(empty? (world-doodads-star w))
     (make-world (world-doodads-star w)
                 (doodad-remove (world-doodads-square w)
                                (oldest-doodad-age (world-doodads-square w)))
                 (world-paused? w) (world-tvx w) (world-tvy w) (world-qvx w)
                 (world-qvy w))]
    [(empty? (world-doodads-square w))
     (make-world (doodad-remove (world-doodads-star w)
                                (oldest-doodad-age (world-doodads-star w)))
                 (world-doodads-square w)
                 (world-paused? w) (world-tvx w) (world-tvy w) (world-qvx w)
                 (world-qvy w))]
    
    [else
     (make-world (doodad-remove (world-doodads-star w)
                                (oldest-doodad-age (world-doodads-star w)))
                 (doodad-remove (world-doodads-square w)
                                (oldest-doodad-age (world-doodads-square w)))
                 (world-paused? w) (world-tvx w) (world-tvy w) (world-qvx w)
                 (world-qvy w))]))

;; TESTS:
(begin-for-test
  (check-equal? (dot-key-event-remove paused-initial-world)
                (make-world '() '() #true 10 12 -13 -9)
    "(dot-key-event-remove paused-initial-world) returned incorrect world.")
  (check-equal? (dot-key-event-remove ex-world2)
                (make-world '() '() #true 10 12 -13 -9)
     "(dot-key-event-remove ex-world2) returned incorrect world.")
  (check-equal? (dot-key-event-remove ex-world3)
                (make-world '() '() #true 10 12 -13 -9)
     "(dot-key-event-remove ex-world3) returned incorrect world.")
  (check-equal? (dot-key-event-remove ex-world)
                (make-world
                 (list
                  (make-doodad 1 1 -10 -12 "gold" #true "star" 0 0 2)
                  (make-doodad 600 1 10 -12 "green" #false "star" 0 0 3))
                 '() #true 10 12 -13 -9)
     "(dot-key-event-remove ex-world) returned incorrect world."))


;; c-key-event-change-color : LOD -> LOD
;; GIVEN: a List of Doodads
;; RETURNS: a new List of Doodads with color change iff the Doodad is selected.
;; EXAMPLE:
;; (c-key-event-change-color initial-star-list) =
;;       (list (make-doodad 125 120 10 12 "gold" #false "star" 0 0 0))
;; (c-key-event-change-color LOD-star2)
;;       (list
;;        (make-doodad 300 225 10 12 "green" #true "star" 3 8 7)
;;        (make-doodad 600 1 10 -12 "green" #false "star" 0 0 3)
;;        (make-doodad 0 448 -10 12 "gold" #true "star" 6 6 5))
;; STRATEGY: Use template for LOD on lst
;; HALTING MEASURE: length of lst
  
(define (c-key-event-change-color lst)
  (cond
    [(empty? lst) empty]
    [else (cons
           (if (doodad-selected? (first lst))
               (make-doodad (doodad-x (first lst)) (doodad-y (first lst))
                            (doodad-vx (first lst)) (doodad-vy (first lst))
                            (next-color (doodad-color (first lst)))
                            (doodad-selected? (first lst))
                            (doodad-type (first lst))
                            (doodad-dx (first lst)) (doodad-dy (first lst))
                            (doodad-age (first lst)))
               (first lst))
           (c-key-event-change-color (rest lst)))]))


;; world-with-paused-toggled : World -> World
;; GIVEN: A World.
;; RETURNS: a World just like the given one, but with paused? toggled
;; EXAMPLE:
;; (world-with-paused-toggled unpaused-initial-world) = paused-initial-world
;; (world-with-paused-toggled paused-1) = unpaused-1
;; STRATEGY: Use template for World on w
    
(define (world-with-paused-toggled w)
  (make-world
   (world-doodads-star w)
   (world-doodads-square w)
   (not (world-paused? w))
   (world-tvx w)
   (world-tvy w)
   (world-qvx w)
   (world-qvy w)))


;; world-with-doodad-color-change : World -> World
;; GIVEN: A World.
;; RETURNS: a World just like the given one, but with Doodad color change.
;; EXAMPLE:
;; (world-with-doodad-color-change paused-1) =
;;          (make-world
;;           (list
;;            (make-doodad 1 1 -10 -12 "green" #true "star" 0 0 2)
;;            (make-doodad 600 1 10 -12 "green" #false "star" 0 0 3)
;;            (make-doodad 125 120 10 12 "gold" #false "star" 0 0 0))
;;           (list (make-doodad 460 350 -13 -9 "gray" #false "square" 0 0 0))
;;           #true -12 10 9 -13)
;; (world-with-doodad-color-change unpaused-4) =
;;          (make-world
;;           (list (make-doodad 125 120 10 12 "gold" #false "star" 0 0 0))
;;           (list
;;            (make-doodad 600 225 13 9 "crimson" #false "square" 0 0 10)
;;            (make-doodad 1 225 -13 9 "crimson" #true "square" 8 9 9)
;;            (make-doodad 300 1 13 -9 "orange" #true "square" 5 7 6))
;;           #false 12 -10 -9 13)
;; (world-with-doodad-color-change unpaused-7) =
;;          (make-world
;;           (list
;;            (make-doodad 1 1 -10 -12 "green" #true "star" 0 0 2)
;;            (make-doodad 600 1 10 -12 "green" #false "star" 0 0 3)
;;            (make-doodad 125 120 10 12 "gold" #false "star" 0 0 0))
;;           (list
;;            (make-doodad 600 225 13 9 "crimson" #false "square" 0 0 10)
;;            (make-doodad 1 225 -13 9 "crimson" #true "square" 8 9 9)
;;            (make-doodad 300 1 13 -9 "orange" #true "square" 5 7 6))
;;           #false 10 12 9 -13)
;; STRATEGY: Use template for World on w
    
(define (world-with-doodad-color-change w)
  (make-world
   (c-key-event-change-color (world-doodads-star w))
   (c-key-event-change-color (world-doodads-square w))
   (world-paused? w)
   (world-tvx w)
   (world-tvy w)
   (world-qvx w)
   (world-qvy w)))


;; TESTS:
(begin-for-test
  (check-equal? (world-with-doodad-color-change paused-1)
                (make-world
                 (list
                  (make-doodad 1 1 -10 -12 "green" #true "star" 0 0 2)
                  (make-doodad 600 1 10 -12 "green" #false "star" 0 0 3)
                  (make-doodad 125 120 10 12 "gold" #false "star" 0 0 0))
                 (list (make-doodad 460 350 -13 -9 "gray" #false "square"
                                    0 0 0))
                 #true -12 10 9 -13)
    "(world-with-doodad-color-change paused-1) returns the incorrect world.")
  (check-equal? (world-with-doodad-color-change unpaused-4)
                (make-world
                 (list (make-doodad 125 120 10 12 "gold" #false "star" 0 0 0))
                 (list
                  (make-doodad 600 225 13 9 "crimson" #false "square" 0 0 10)
                  (make-doodad 1 225 -13 9 "crimson" #true "square" 8 9 9)
                  (make-doodad 300 1 13 -9 "orange" #true "square" 5 7 6))
                 #false 12 -10 -9 13)
    "(world-with-doodad-color-change unpaused-4) returns the incorrect world.")
  (check-equal? (world-with-doodad-color-change unpaused-7)
                (make-world
                 (list
                  (make-doodad 1 1 -10 -12 "green" #true "star" 0 0 2)
                  (make-doodad 600 1 10 -12 "green" #false "star" 0 0 3)
                  (make-doodad 125 120 10 12 "gold" #false "star" 0 0 0))
                 (list
                  (make-doodad 600 225 13 9 "crimson" #false "square" 0 0 10)
                  (make-doodad 1 225 -13 9 "crimson" #true "square" 8 9 9)
                  (make-doodad 300 1 13 -9 "orange" #true "square" 5 7 6))
                 #false 10 12 9 -13)
    "(world-with-doodad-color-change unpaused-7) returns the incorrect world."))

  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; animation function. start with (animation 1)

;; animation : PosReal -> World
;; GIVEN: the speed of the animation, in seconds per tick (so larger numbers
;;        run slower)
;; EFFECT: runs the animation, starting with the inital world as specified
;;         in the problem set.
;; RETURNS: the final state of the world
;; EXAMPLES:
;; (animation 1) runs the animation at normal speed
;; (animation 1/4) runs at a faster than normal speed
;; STRATEGY: combine simpler functions

(define (animation animation-speed)
  (big-bang (initial-world 0)
            (on-tick world-after-tick animation-speed)
            (on-key world-after-key-event)
            (on-mouse world-after-mouse-event)
            (on-draw world-to-scene)))


;; initial-world : Any -> World
;; GIVEN: any value (ignored)
;; RETURNS: the initial world specified for the animation
;; EXAMPLE:
;; (initial-world -174) = (make-world initial-star-list initial-square-list
;;                                    false STAR-VX STAR-VY SQUARE-VX SQUARE-VY)
;; STRATEGY: combine simpler functions

(define (initial-world anything)
  (make-world initial-star-list initial-square-list false STAR-VX STAR-VY
              SQUARE-VX SQUARE-VY))

;; TESTS:
(begin-for-test
  (check-equal? (initial-world -174)
                (make-world initial-star-list initial-square-list false
                            STAR-VX STAR-VY SQUARE-VX SQUARE-VY)
    "(initial-world -174) should return (make-world initial-star-list
          initial-square-list false STAR-VX STAR-VY SQUARE-VX SQUARE-VY)"))


;; world-after-tick : World -> World
;; GIVEN: a World that's possible for the animation
;; RETURNS: the World that should follow the given World after a tick.
;; EXAMPLES:
;; moving:
;; (world-after-tick unpaused-initial-world) = 
;;          (make-world
;;           (list (make-doodad 135 132 10 12 "gold" #false "star" 0 0 1))
;;           (list (make-doodad 447 341 -13 -9 "gray" #false "square" 0 0 1))
;;           #false 10 12 -13 -9)
;; paused:
;; (world-after-tick paused-1) = 
;;          (make-world
;;           (list
;;            (make-doodad 1 1 -10 -12 "gold" #true "star" 0 0 3)
;;            (make-doodad 600 1 10 -12 "green" #false "star" 0 0 4)
;;            (make-doodad 125 120 10 12 "gold" #false "star" 0 0 1))
;;           (list (make-doodad 460 350 -13 -9 "gray" #false "square" 0 0 1))
;;           #true -12 10 9 -13)
;; STRATEGY: Use template for World on w

(define (world-after-tick w)
  (if (world-paused? w)
      (make-world (construct-doodad-aged-list (world-doodads-star w))
                  (construct-doodad-aged-list (world-doodads-square w))
                  (world-paused? w)
                  (world-tvx w)
                  (world-tvy w)
                  (world-qvx w)
                  (world-qvy w))                        
      (make-world (next-doodad-list (world-doodads-star w))
                  (next-doodad-list (world-doodads-square w))
                  (world-paused? w)
                  (world-tvx w)
                  (world-tvy w)
                  (world-qvx w)
                  (world-qvy w))))

;; TESTS:
(begin-for-test
  (check-equal? (world-after-tick unpaused-initial-world)
                (make-world
                 (list (make-doodad 135 132 10 12 "gold" #false "star" 0 0 1))
                 (list (make-doodad 447 341 -13 -9 "gray" #false "square"
                                    0 0 1))
                 #false 10 12 -13 -9)
    "(world-after-tick unpaused-initial-world) returned incorrect World.")
  (check-equal? (world-after-tick paused-initial-world)
                (make-world (list (make-doodad 125 120 10 12 "gold" #false
                                               "star" 0 0 1))
                            (list (make-doodad 460 350 -13 -9 "gray" #false
                                               "square" 0 0 1))
                            #true 10 12 -13 -9)
    "(world-after-tick paused-initial-world) returned incorrect World.")
  (check-equal? (world-after-tick unpaused-1)
                (make-world
                 (list
                  (make-doodad 9 11 10 12 "green" #true "star" 0 0 3)
                  (make-doodad 590 11 -10 12 "blue" #false "star" 0 0 4)
                  (make-doodad 135 132 10 12 "gold" #false "star" 0 0 1))
                 (list (make-doodad 447 341 -13 -9 "gray" #false "square"
                                    0 0 1))
                 #false -12 10 9 -13)
    "(world-after-tick unpaused-1) returned incorrect World.")
  (check-equal? (world-after-tick paused-1)
                (make-world
                 (list
                  (make-doodad 1 1 -10 -12 "gold" #true "star" 0 0 3)
                  (make-doodad 600 1 10 -12 "green" #false "star" 0 0 4)
                  (make-doodad 125 120 10 12 "gold" #false "star" 0 0 1))
                 (list (make-doodad 460 350 -13 -9 "gray" #false "square"
                                    0 0 1))
                 #true -12 10 9 -13)
    "(world-after-tick paused-1) returned incorrect World.")
  (check-equal? (world-after-tick unpaused-2)
                (make-world
                 (list
                  (make-doodad 9 11 10 12 "green" #true "star" 0 0 3)
                  (make-doodad 590 11 -10 12 "blue" #false "star" 0 0 4)
                  (make-doodad 135 132 10 12 "gold" #false "star" 0 0 1))
                 (list
                  (make-doodad 12 8 13 9 "olivedrab" #true "square" 0 0 8)
                  (make-doodad 587 439 -13 -9 "olivedrab" #false "square" 0 0 3)
                  (make-doodad 300 439 13 -9 "khaki" #true "square" 7 7 9)
                  (make-doodad 447 341 -13 -9 "gray" #false "square" 0 0 1))
                 #false -10 -12 13 9)
    "(world-after-tick unpaused-2) returned incorrect World.")
  (check-equal? (world-after-tick paused-2)
                (make-world
                 (list
                  (make-doodad 1 1 -10 -12 "gold" #true "star" 0 0 3)
                  (make-doodad 600 1 10 -12 "green" #false "star" 0 0 4)
                  (make-doodad 125 120 10 12 "gold" #false "star" 0 0 1))
                 (list
                  (make-doodad 1 1 -13 -9 "gray" #true "square" 0 0 8)
                  (make-doodad 600 448 13 9 "gray" #false "square" 0 0 3)
                  (make-doodad 300 448 13 9 "olivedrab" #true "square" 7 7 9)
                  (make-doodad 460 350 -13 -9 "gray" #false "square" 0 0 1))
                 #true -10 -12 13 9)
    "(world-after-tick paused-2) returned incorrect World.")
  (check-equal? (world-after-tick unpaused-3)
                (make-world
                 (list
                  (make-doodad 300 225 10 12 "gold" #true "star" 3 8 8)
                  (make-doodad 590 11 -10 12 "blue" #false "star" 0 0 4)
                  (make-doodad 10 436 10 -12 "gold" #true "star" 6 6 6))
                 (list
                  (make-doodad 587 234 -13 9 "gray" #false "square" 0 0 11)
                  (make-doodad 12 225 13 9 "crimson" #true "square" 8 9 10)
                  (make-doodad 300 8 13 9 "orange" #true "square" 5 7 7))
                 #false 12 -10 -9 13)
    "(world-after-tick unpaused-3) returned incorrect World.")
  (check-equal? (world-after-tick unpaused-4)
                (make-world
                 (list (make-doodad 135 132 10 12 "gold" #false "star" 0 0 1))
                 (list
                  (make-doodad 587 234 -13 9 "gray" #false "square" 0 0 11)
                  (make-doodad 12 225 13 9 "crimson" #true "square" 8 9 10)
                  (make-doodad 300 8 13 9 "orange" #true "square" 5 7 7))
                 #false 12 -10 -9 13)
    "(world-after-tick unpaused-4) returned incorrect World.")
  (check-equal? (world-after-tick unpaused-5)
                (make-world
                 (list
                  (make-doodad 300 225 10 12 "gold" #true "star" 3 8 8)
                  (make-doodad 590 11 -10 12 "blue" #false "star" 0 0 4)
                  (make-doodad 10 436 10 -12 "gold" #true "star" 6 6 6))
                 (list (make-doodad 447 341 -13 -9 "gray" #false "square"
                                    0 0 1))
                 #false -12 10 -13 -9)
    "(world-after-tick unpaused-5) returned incorrect World.")
  (check-equal? (world-after-tick unpaused-6)
                (make-world
                 (list (make-doodad 135 132 10 12 "gold" #false "star" 0 0 1))
                 (list
                  (make-doodad 12 8 13 9 "olivedrab" #true "square" 0 0 8)
                  (make-doodad 587 439 -13 -9 "olivedrab" #false "square" 0 0 3)
                  (make-doodad 300 439 13 -9 "khaki" #true "square" 7 7 9)
                  (make-doodad 447 341 -13 -9 "gray" #false "square" 0 0 1))
                 #false -10 -12 -13 -9)
    "(world-after-tick unpaused-6) returned incorrect World.")
  (check-equal? (world-after-tick unpaused-7)
                (make-world
                 (list
                  (make-doodad 9 11 10 12 "green" #true "star" 0 0 3)
                  (make-doodad 590 11 -10 12 "blue" #false "star" 0 0 4)
                  (make-doodad 135 132 10 12 "gold" #false "star" 0 0 1))
                 (list
                  (make-doodad 587 234 -13 9 "gray" #false "square" 0 0 11)
                  (make-doodad 12 225 13 9 "crimson" #true "square" 8 9 10)
                  (make-doodad 300 8 13 9 "orange" #true "square" 5 7 7))
                 #false 10 12 9 -13)
    "(world-after-tick unpaused-7) returned incorrect World."))


;; world-after-key-event : World KeyEvent -> World
;; GIVEN: a World w and a KeyEvent kev
;; RETURNS: the World that should follow the given World
;; after the given KeyEvent.
;; on space, toggle paused?-- ignore all others
;; EXAMPLES:
;; (world-after-key-event unpaused-1 " ") = paused-1
;; (world-after-key-event paused-1 "a") = paused-1
;; (world-after-key-event paused-initial-world " ") = unpaused-initial-world
;; STRATEGY: Cases on whether the kev is a pause event

(define (world-after-key-event w kev)
  (cond
    [(is-pause-key-event? kev) (world-with-paused-toggled w)]
    [(key=? kev "c") (world-with-doodad-color-change w)]
    [(key=? kev "t") (t-key-event-add-star w)]
    [(key=? kev "q") (q-key-event-add-square w)]
    [(key=? kev ".") (dot-key-event-remove w)]
    [else w]))



;; TESTS:
(begin-for-test
  (check-equal? (world-after-key-event unpaused-1 " ") paused-1
    "(world-after-key-event unpaused-1 ' ') returned incorrect World.")
  (check-equal? (world-after-key-event paused-1 "a") paused-1
    "(world-after-key-event paused-1 'a') returned incorrect World.")
  (check-equal? (world-after-key-event paused-initial-world " ")
                unpaused-initial-world
    "(world-after-key-event paused-initial-world ' ')
    returned incorrect World.")
  (check-equal? (world-after-key-event paused-initial-world "c")
                paused-initial-world
    "(world-after-key-event paused-initial-world 'c')
    returned incorrect World.")
  (check-equal? (world-after-key-event paused-initial-world "t")
                (make-world
                 (list
                  (make-doodad 125 120 -12 10 "gold" #false "star" 0 0 0)
                  (make-doodad 125 120 10 12 "gold" #false "star" 0 0 0))
                 (list (make-doodad 460 350 -13 -9 "gray" #false "square"
                                    0 0 0))
                 #true -12 10 -13 -9)
    "(world-after-key-event paused-initial-world 't')
    returned incorrect World.")
  (check-equal? (world-after-key-event paused-initial-world "q")
                (make-world
                 (list (make-doodad 125 120 10 12 "gold" #false "star" 0 0 0))
                 (list
                  (make-doodad 460 350 9 -13 "gray" #false "square" 0 0 0)
                  (make-doodad 460 350 -13 -9 "gray" #false "square" 0 0 0))
                 #true 10 12 9 -13)
    "(world-after-key-event paused-initial-world 'q')
    returned incorrect World.")
  (check-equal? (world-after-key-event paused-initial-world ".")
                (make-world '() '() #true 10 12 -13 -9)
    "(world-after-key-event paused-initial-world '.')
    returned incorrect World."))



;; doodad-after-mouse-event : Doodad Integer Integer MouseEvent -> Doodad
;; GIVEN: A Doodad, the x and y coordinates of a mouse event, and
;;        the MouseEvent
;; RETURNS: the Doodad as it should be after the given mouse event.
;; EXAMPLES:
;; (doodad-after-mouse-event star-green-at-top-right 590 10 "button-down") =
;;     (make-doodad 600 1 10 -12 "green" #true "star" -10 9 3)
;; (doodad-after-mouse-event star-gold-at-top-left 10 10 "drag") =
;;     (make-doodad 10 10 -10 -12 "gold" #true "star" 0 0 2)
;; (doodad-after-mouse-event star-blue-at-bottom-left 10 438 "button-up") =
;;     (make-doodad 0 448 -10 12 "blue" #false "star" 0 0 5)
;; STRATEGY: Cases on MouseEvent

(define (doodad-after-mouse-event d mx my mev)
  (cond
    [(mouse=? mev "button-down") (doodad-after-button-down d mx my)]
    [(mouse=? mev "drag") (doodad-after-drag d mx my)]
    [(mouse=? mev "button-up") (doodad-after-button-up d mx my)]
    [else d]))

;; TESTS:

(begin-for-test
  (check-equal? (doodad-after-mouse-event square-crimson-at-right 590 215
                                          "button-down")
                (make-doodad 600 225 13 9 "crimson" #true "square" -10 -10 10)
    "(doodad-after-mouse-event square-crimson-at-right 590 215 'button-down')
     returned incorrect Doodad.")
  (check-equal? (doodad-after-mouse-event star-gold-at-top-left 10 10 "drag")
                (make-doodad 10 10 -10 -12 "gold" #true "star" 0 0 2)
    "(doodad-after-mouse-event star-gold-at-top-left 10 10 'drag') returned
     incorrect Doodad.")
  (check-equal? (doodad-after-mouse-event star-blue-at-bottom-left 10 438
                                          "button-up")
                (make-doodad 0 448 -10 12 "blue" #false "star" 0 0 5)
    "(doodad-after-mouse-event star-blue-at-bottom-left 10 438 'button-up')
     returned incorrect Doodad.")
  (check-equal? (doodad-after-mouse-event star-gold-at-top-left 10 10 "leave")
                star-gold-at-top-left
    "(doodad-after-mouse-event star-gold-at-top-left 10 10 'leave')
     returned incorrect Doodad.")
  (check-equal? (doodad-after-mouse-event star-green-at-top-right 590 10
                                          "button-down")
                (make-doodad 600 1 10 -12 "green" #true "star" -10 9 3)
    "(doodad-after-mouse-event star-green-at-top-right 590 10 'button-down')
     returned incorrect Doodad.")
  (check-equal? (doodad-after-mouse-event star-green-at-top-right 590 10
                                          "button-up")
                (make-doodad 600 1 10 -12 "green" #false "star" 0 0 3)
    "(doodad-after-mouse-event star-green-at-top-right 590 10 'button-up')
     returned incorrect Doodad.")
  (check-equal? (doodad-after-mouse-event square-khaki-at-top 290 10
                                          "button-down")
                (make-doodad 300 1 13 -9 "khaki" #true "square" -10 9 6)
    "(doodad-after-mouse-event square-khaki-at-top 290 10 'button-down')
     returned incorrect Doodad.")
  (check-equal? (doodad-after-mouse-event square-orange-at-left 10 215
                                          "button-down")
                (make-doodad 1 225 -13 9 "orange" #true "square" 9 -10 9)
    "(doodad-after-mouse-event square-orange-at-left 10 215 'button-down')
     returned incorrect Doodad."))


;; world-after-mouse-event : World Integer Integer MouseEvent -> World
;; GIVEN: A World, the x and y coordinates of a mouse event, and
;;        the MouseEvent
;; RETURNS: the World as it should be after the given mouse event.
;; EXAMPLES:
;; (world-after-mouse-event unpaused-initial-world 120 110 "button-down") =
;;         (make-world
;;          (list (make-doodad 125 120 10 12 "gold" #true "star" -5 -10 0))
;;          (list (make-doodad 460 350 -13 -9 "gray" #false "square" 0 0 0))
;;          #false 10 12 -13 -9)
;; (world-after-mouse-event paused-1 10 10 "drag") =
;;         (make-world
;;          (list
;;           (make-doodad 10 10 -10 -12 "gold" #true "star" 0 0 2)
;;           (make-doodad 600 1 10 -12 "green" #false "star" 0 0 3)
;;           (make-doodad 125 120 10 12 "gold" #false "star" 0 0 0))
;;          (list (make-doodad 460 350 -13 -9 "gray" #false "square" 0 0 0))
;;          #true -12 10 9 -13)
;; (world-after-mouse-event unpaused-3 10 438 "button-up") =
;;         (make-world
;;          (list
;;           (make-doodad 300 225 10 12 "gold" #false "star" 0 0 7)
;;           (make-doodad 600 1 10 -12 "green" #false "star" 0 0 3)
;;           (make-doodad 0 448 -10 12 "blue" #false "star" 0 0 5))
;;          (list
;;           (make-doodad 600 225 13 9 "crimson" #false "square" 0 0 10)
;;           (make-doodad 1 225 -13 9 "orange" #false "square" 0 0 9)
;;           (make-doodad 300 1 13 -9 "khaki" #false "square" 0 0 6))
;;          #false 12 -10 -9 13)
;; STRATEGY: Cases on MouseEvent

(define (world-after-mouse-event w mx my mev)
  (cond
    [(mouse=? mev "button-down") (world-after-button-down w mx my)]
    [(mouse=? mev "drag") (world-after-drag w mx my)]
    [(mouse=? mev "button-up") (world-after-button-up w mx my)]
    [else w]))

;; TESTS:

(begin-for-test
  (check-equal? (world-after-mouse-event unpaused-initial-world
                                         120 110 "button-down")
                (make-world
                 (list (make-doodad 125 120 10 12 "gold" #true "star" -5 -10 0))
                 (list (make-doodad 460 350 -13 -9 "gray" #false "square"
                                    0 0 0))
                 #false 10 12 -13 -9)
    "(world-after-mouse-event unpaused-initial-world 120 110 'button-down')
      returned incorrect World.")
  (check-equal? (world-after-mouse-event paused-1 10 10 "drag")
                (make-world
                 (list
                  (make-doodad 10 10 -10 -12 "gold" #true "star" 0 0 2)
                  (make-doodad 600 1 10 -12 "green" #false "star" 0 0 3)
                  (make-doodad 125 120 10 12 "gold" #false "star" 0 0 0))
                 (list (make-doodad 460 350 -13 -9 "gray" #false "square"
                                    0 0 0))
                 #true -12 10 9 -13)
    "(world-after-mouse-event paused-1 10 10 'drag') returned incorrect World.")
  (check-equal? (world-after-mouse-event unpaused-3 10 438 "button-up")
                (make-world
                 (list
                  (make-doodad 300 225 10 12 "gold" #false "star" 0 0 7)
                  (make-doodad 600 1 10 -12 "green" #false "star" 0 0 3)
                  (make-doodad 0 448 -10 12 "blue" #false "star" 0 0 5))
                 (list
                  (make-doodad 600 225 13 9 "crimson" #false "square" 0 0 10)
                  (make-doodad 1 225 -13 9 "orange" #false "square" 0 0 9)
                  (make-doodad 300 1 13 -9 "khaki" #false "square" 0 0 6))
                 #false 12 -10 -9 13)
    "(world-after-mouse-event unpaused-3 10 438 'button-up')
    returned incorrect World.")
  (check-equal? (world-after-mouse-event paused-2 10 1 "leave")
                paused-2
    "(world-after-mouse-event paused-2 10 1 'leave')
    returned incorrect World."))


;;  Run animation with 10x the speed:
;; (animation 0.1)
                
