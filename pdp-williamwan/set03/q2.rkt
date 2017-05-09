;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Goal: Build a simple animation with two doodads moving around in a
;; rectangular enclosure, both doodads are selectable and draggable.

(require rackunit)
(require "extras.rkt")
(require 2htdp/universe)
(require 2htdp/image)
(check-location "03" "q2.rkt")

(provide
  animation
  initial-world
  world-after-tick
  world-paused?
  world-after-key-event
  world-doodad-star
  world-doodad-square
  doodad-x
  doodad-y
  doodad-vx
  doodad-vy
  doodad-color
  doodad-selected?
  world-after-mouse-event
  doodad-after-mouse-event)

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
          

(define-struct doodad [x y vx vy color selected? dx dy])
;; A Doodad is a structure:
;;  (make-doodad Integer Integer Integer Integer String Boolean Integer Integer)
;; INTERPRETATION:
;; x is the x-position of the Doodad
;; y is the y-position of the Doodad
;; vx is the x direction velocity of the Doodad
;; vy is the y direction velocity of the Doodad
;; color is the color of the Doodad
;; selected? describes whether or not the Doodad is selected
;; dx is mouse's x position - x
;; dy is mouse's y position - y

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
       (doodad-dx)
       (doodad-dy)))

;; Examples of Doodads, for testing
(define star-gold-at-top-left (make-doodad 1 1 -10 -12 "gold" true 0 0))
(define star-green-at-top-right (make-doodad 600 1 10 -12 "green" false 0 0))
(define star-blue-at-bottom-left (make-doodad 0 448 -10 12 "blue" true 6 6))
(define square-gray-at-top-left (make-doodad 1 1 -13 -9 "gray" true 0 0))
(define square-gray-at-bottom-right (make-doodad 600 448 13 9 "gray" false 0 0))
(define square-olivedrab-at-bottom (make-doodad 300 448 13 9 "olivedrab"
                                                true 7 7))
(define square-khaki-at-top (make-doodad 300 1 13 -9 "khaki" true 5 7))
(define square-orange-at-left (make-doodad 1 225 -13 9 "orange" true 8 9))
(define square-crimson-at-right (make-doodad 600 225 13 9 "crimson" false 0 0))
(define star-gold-at-center (make-doodad 300 225 10 12 "gold" true 3 8))
;; initial Doodad of the RAD-STAR
(define RAD-STAR (make-doodad STAR-X STAR-Y STAR-VX STAR-VY
                              STAR-COLOR false 0 0))
;; initial Doodad of the SQUARE
(define SQUARE (make-doodad SQUARE-X SQUARE-Y SQUARE-VX SQUARE-VY
                            SQUARE-COLOR false 0 0))


(define-struct world [doodad-star doodad-square paused?])
;; A World is a structure:
;;  (make-world Doodad Doodad Boolean)
;; INTERPRETATION:
;; doodad-star is the radial-star Doodad
;; doodad-square is the square Doodad
;; paused? describes whether or not the Doodad is paused.

;; TEMPLATE:
;; world-fn : World -> ??
#;
(define (world-fn w)
  (... (world-doodad-star w)
       (world-doodad-square w)
       (world-paused? w)))

;; Examples of worlds, for testing
(define unpaused-initial-world (make-world RAD-STAR SQUARE false))
(define paused-initial-world (make-world RAD-STAR SQUARE true))
(define unpaused-1 (make-world star-gold-at-top-left SQUARE false))
(define paused-1 (make-world star-gold-at-top-left SQUARE true))
(define unpaused-2 (make-world star-green-at-top-right
                               square-gray-at-bottom-right
                               false))
(define paused-2 (make-world star-green-at-top-right
                               square-gray-at-bottom-right
                               true))
(define unpaused-3 (make-world star-blue-at-bottom-left
                               square-olivedrab-at-bottom
                               false))
(define unpaused-4 (make-world RAD-STAR square-khaki-at-top false))
(define unpaused-5 (make-world RAD-STAR square-orange-at-left false))
(define unpaused-6 (make-world RAD-STAR square-crimson-at-right false))
(define unpaused-7 (make-world star-gold-at-top-left
                               square-gray-at-top-left false))

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


;; doodad-type : Doodad -> String
;; GIVEN: a Doodad
;; RETURN: the type of Doodad, either a "square" or a "star"
;; EXAMPLES:
;; (doodad-type star-gold-at-top-left) = "star"
;; (doodad-type square-crimson-at-right) = "square"
;; STRATEGY: Use template for Doodad on d

(define (doodad-type d)
  (cond
    [(string=? (doodad-color d) "gold") "star"]
    [(string=? (doodad-color d) "green") "star"]
    [(string=? (doodad-color d) "blue") "star"]
    [(string=? (doodad-color d) "gray") "square"]
    [(string=? (doodad-color d) "olivedrab") "square"]
    [(string=? (doodad-color d) "khaki") "square"]
    [(string=? (doodad-color d) "orange") "square"]
    [(string=? (doodad-color d) "crimson") "square"]))
  

;; doodad-after-button-down : Doodad Integer Integer -> Doodad
;; GIVEN: a Doodad and the location of the button-down
;; RETURNS: the Doodad following a button-down at the given location.
;; if the button-down is inside the Doodad, returns a Doodad just like the
;; given one, except that it is selected.
;; EXAMPLES:
;; (doodad-after-button-down SQUARE 440 330) =
;;    (make-doodad 460 350 0 0 "gray" #true -20 -20)
;; (doodad-after-button-down RAD-STAR 120 110) =
;;    (make-doodad 125 120 0 0 "gold" #true -5 -10)
;; (doodad-after-button-down RAD-STAR 20 30) =
;;    (make-doodad 125 120 10 12 "gold" #false 0 0)
;; STRATEGY: Use template for Doodad on d
  
(define (doodad-after-button-down d mx my)
  (cond
    [(and (string=? (doodad-type d) "square") (in-square? d mx my))
     (make-doodad (doodad-x d) (doodad-y d) 0 0
                  (doodad-color d) true (- mx (doodad-x d))
                  (- my (doodad-y d)))]
    [(and (string=? (doodad-type d) "star") (in-star? d mx my))
     (make-doodad (doodad-x d) (doodad-y d) 0 0
                  (doodad-color d) true (- mx (doodad-x d))
                  (- my (doodad-y d)))]
    [else d]))


;; doodad-after-drag : Doodad Integer Integer -> Doodad
;; GIVEN: a Doodad and the location of the drag event
;; RETURNS: the Doodad following a drag at the given location.
;; if the Doodad is selected, then return a Doodad just like the given
;; one, with the new location, the position of the mouse within the
;; Doodad does not change relative to the Doodad's center.
;; EXAMPLES:
;; (doodad-after-drag star-blue-at-bottom-left 10 438) = 
;;     (make-doodad 4 432 -10 12 "blue" #true 6 6)
;; (doodad-after-drag square-gray-at-bottom-right 590 438) =
;;     (make-doodad 600 448 13 9 "gray" #false 0 0)
;; STRATEGY: Use template for Doodad on d

(define (doodad-after-drag d mx my)
  (if (doodad-selected? d)
      (make-doodad (- mx (doodad-dx d)) (- my (doodad-dy d)) (doodad-vx d)
                   (doodad-vy d) (doodad-color d) true (doodad-dx d)
                   (doodad-dy d))
      d))
  

;; doodad-after-button-up : Doodad Integer Integer -> Doodad
;; GIVEN: a Doodad and the location of the button up
;; RETURNS: the Doodad following a button-up at the given location.
;; if the Doodad is selected, return a Doodad just like the given one,
;; except that it is no longer selected.
;; EXAMPLES:
;; (doodad-after-button-up star-green-at-top-right 590 10) =
;;      (make-doodad 600 1 10 -12 "green" #false 0 0)
;; (doodad-after-button-up square-khaki-at-top 302 10) =
;;      (make-doodad 300 1 13 -9 "khaki" #false 0 0)
;; (doodad-after-button-up square-gray-at-bottom-right 10 10) =
;;      (make-doodad 600 448 13 9 "gray" #false 0 0)
;; STRATEGY: use template for Doodad on d

(define (doodad-after-button-up d mx my)
  (if (doodad-selected? d)
      (cond
        [(string=? (doodad-type d) "square")
         (make-doodad (doodad-x d) (doodad-y d) SQUARE-VX
                   SQUARE-VY (doodad-color d) false 0 0)]
        [(string=? (doodad-type d) "star")
         (make-doodad (doodad-x d) (doodad-y d) STAR-VX
                   STAR-VY (doodad-color d) false 0 0)])
      d))


;; world-after-button-down : World Integer Integer -> World
;; GIVEN: a World and the location of the button-down
;; RETURNS: the World following a button-down at the given location.
;; if the button-down is inside the Doodad, returns a World just like the
;; given one, with the new Doodads.
;; EXAMPLES:
;; (world-after-button-down unpaused-initial-world 2 2) =
;;      (make-world (make-doodad 125 120 10 12 "gold" #false 0 0)
;;                  (make-doodad 460 350 13 -9 "gray" #false 0 0) #false)
;; (world-after-button-down unpaused-1 10 10) =
;;      (make-world (make-doodad 1 1 0 0 "gold" #true 9 9)
;;                  (make-doodad 460 350 13 -9 "gray" #false 0 0) #false)
;; STRATEGY: Use template for World on w
  
(define (world-after-button-down w mx my)
  (make-world (doodad-after-button-down (world-doodad-star w) mx my)
              (doodad-after-button-down (world-doodad-square w) mx my)
              (world-paused? w)))


;; world-after-drag : World Integer Integer -> World
;; GIVEN: a World and the location of the drag event
;; RETURNS: the World following a drag at the given location.
;; EXAMPLES:
;; (world-after-drag unpaused-3 10 438) =
;;     (make-world (make-doodad 4 432 -10 12 "blue" #true 6 6)
;;     (make-doodad 3 431 13 9 "olivedrab" #true 7 7) #false)
;; (world-after-drag paused-2 590 438) =
;;     (make-world (make-doodad 600 1 10 -12 "green" #false 0 0)
;;     (make-doodad 600 448 13 9 "gray" #false 0 0) #true)
;; STRATEGY: Use template for World on w

(define (world-after-drag w mx my)
  (make-world (doodad-after-drag (world-doodad-star w) mx my)
              (doodad-after-drag (world-doodad-square w) mx my)
              (world-paused? w)))
  

;; world-after-button-up : World Integer Integer -> World
;; GIVEN: a World and the location of the button up
;; RETURNS: the World following a button-up at the given location.
;; EXAMPLE:
;; (world-after-button-up unpaused-2 590 10) =
;;     (make-world (make-doodad 600 1 10 -12 "green" #false 0 0)
;;     (make-doodad 600 448 13 9 "gray" #false 0 0) #false)
;; (world-after-button-up unpaused-4 302 10) =
;;     (make-world (make-doodad 125 120 10 12 "gold" #false 0 0)
;;     (make-doodad 300 1 13 -9 "khaki" #false 0 0) #false)
;; (world-after-button-up paused-2 10 10) =
;;     (make-world (make-doodad 600 1 10 -12 "green" #false 0 0)
;;     (make-doodad 600 448 13 9 "gray" #false 0 0) #true)
;; STRATEGY: use template for World on w

(define (world-after-button-up w mx my)
  (make-world (doodad-after-button-up (world-doodad-star w) mx my)
              (doodad-after-button-up (world-doodad-square w) mx my)
              (world-paused? w)))



;; star-to-scene : World -> Scene
;; GIVEN: a World 
;; RETURNS: a Scene that portrays the given World.
;; EXAMPLE:
;; (star-to-scene unpaused-initial-world)
;;  = (place-image (radial-star 8 10 50 "solid" "gold") 125 120 EMPTY-CANVAS)
;; (star-to-scene paused-initial-world)
;;  = (place-image (radial-star 8 10 50 "solid" "gold") 125 120 EMPTY-CANVAS)
;; (star-to-scene unpaused-1)
;;  = (place-image (radial-star 8 10 50 "solid" "gold") 1 1 EMPTY-CANVAS)
;; STRATEGY: Use template for World on w

(define (star-to-scene w)
  (place-image (radial-star 8 10 50 "solid"
                            (doodad-color (world-doodad-star w)))
               (doodad-x (world-doodad-star w))
               (doodad-y (world-doodad-star w))
               EMPTY-CANVAS))


;; TESTS:
(begin-for-test
  (check-equal?
    (star-to-scene unpaused-initial-world)
    (place-image (radial-star 8 10 50 "solid" "gold") 125 120 EMPTY-CANVAS)
    "(star-to-scene unpaused-initial-world) returned incorrect image")

  (check-equal?
    (star-to-scene paused-initial-world)
    (place-image (radial-star 8 10 50 "solid" "gold") 125 120 EMPTY-CANVAS)
    "(star-to-scene paused-initial-world) returned incorrect image")

  (check-equal?
    (star-to-scene unpaused-1)
    (place-image (radial-star 8 10 50 "solid" "gold") 1 1 EMPTY-CANVAS)
    "(star-to-scene unpaused-1) returned incorrect image"))


;; square-to-scene : World -> Scene
;; GIVEN: a World 
;; RETURNS: a Scene that portrays the given world.
;; EXAMPLE:
;; (define unpaused-initial-star (place-image
;;                                (radial-star 8 10 50 "solid" "gold")
;;                                125 120 EMPTY-CANVAS))
;; (square-to-scene unpaused-initial-world)
;;  = (place-image (square 71 "solid" "gray") 460 350 unpaused-initial-star)
;; STRATEGY: Use template for World on w

(define (square-to-scene w)
  (place-image (square 71 "solid" (doodad-color (world-doodad-square w)))
               (doodad-x (world-doodad-square w))
               (doodad-y (world-doodad-square w))
               (star-to-scene w)))

;; TEST:
(define unpaused-initial-star (place-image
                              (radial-star 8 10 50 "solid" "gold")
                               125 120 EMPTY-CANVAS))
(define paused-1-star (place-image (radial-star 8 10 50 "solid" "gold")
                                    1 1 EMPTY-CANVAS))
                                      
(begin-for-test
  (check-equal?
    (square-to-scene unpaused-initial-world)
    (place-image (square 71 "solid" "gray") 460 350 unpaused-initial-star)
    "(world-to-scene unpaused-initial-world) returned incorrect image"))

;; world-to-scene : World -> Scene
;; GIVEN: a World 
;; RETURNS: a Scene that portrays the given world.
;; EXAMPLE:
;; (define unpaused-initial-star-square (place-image
;;                                      (radial-star 8 10 50 "solid" "gold")
;;                                       125 120 EMPTY-CANVAS))
;; (world-to-scene unpaused-initial-world)
;;  = (place-image (square 71 "solid" "gray") 460 350 unpaused-initial-star)
;; STRATEGY: Use template for World on w

(define (world-to-scene w)
  (cond
    [(and (doodad-selected? (world-doodad-star w))
          (doodad-selected? (world-doodad-square w)))
      (place-image (circle 3 "solid" "black")
               (+ (doodad-x (world-doodad-square w))
                  (doodad-dx (world-doodad-square w)))
               (+ (doodad-y (world-doodad-square w))
                  (doodad-dy (world-doodad-square w)))
               (square-to-scene w))]
    [(doodad-selected? (world-doodad-star w))
     (place-image (circle 3 "solid" "black")
               (+ (doodad-x (world-doodad-star w))
                  (doodad-dx (world-doodad-star w)))
               (+ (doodad-y (world-doodad-star w))
                  (doodad-dy (world-doodad-star w)))
               (square-to-scene w))]
    [(doodad-selected? (world-doodad-square w))
     (place-image (circle 3 "solid" "black")
               (+ (doodad-x (world-doodad-square w))
                  (doodad-dx (world-doodad-square w)))
               (+ (doodad-y (world-doodad-square w))
                  (doodad-dy (world-doodad-square w)))
               (square-to-scene w))]
    [else (square-to-scene w)]))


;; TEST:
(define unpaused-initial-star-square (place-image
                                     (square 71 "solid" "gray") 460 350
                                      unpaused-initial-star))
(define paused-1-star-square (place-image
                             (square 71 "solid" "gray") 460 350
                              paused-1-star))
(define unpaused-7-star-square (place-image
                               (square 71 "solid" "gray") 1 1
                                paused-1-star))
(define unpaused-4-star-square (place-image
                                (square 71 "solid" "khaki") 300 1
                                unpaused-initial-star))

(begin-for-test
  (check-equal?
    (world-to-scene unpaused-initial-world) unpaused-initial-star-square
    "(world-to-scene unpaused-initial-world) returned incorrect image")
  (check-equal?
    (world-to-scene paused-1) (place-image (circle 3 "solid" "black")
                                           1 1 paused-1-star-square)
    "(world-to-scene paused-1) returned incorrect image")
  (check-equal?
    (world-to-scene unpaused-7) (place-image (circle 3 "solid" "black")
                                             1 1 unpaused-7-star-square)
    "(world-to-scene unpaused-7) returned incorrect image")
  (check-equal?
    (world-to-scene unpaused-4) (place-image (circle 3 "solid" "black")
                                             305 8 unpaused-4-star-square)
    "(world-to-scene unpaused-4) returned incorrect image"))


;; next-color: Color -> Color
;; GIVEN: a Color by DrRacket's image-color? predicate.
;; RETURNS: the next Color of the Doodad
;; EXAMPLE:
;; (next-color "gold") = "green"
;; (next-color "green") = "blue"
;; (next-color "blue") = "gold"
;; STRATEGY: combine simpler functions

(define (next-color color)
  (cond
    [(string=? color "gold") "green"]
    [(string=? color "green") "blue"]
    [(string=? color "blue") "gold"]
    [(string=? color "gray") "olivedrab"]
    [(string=? color "olivedrab") "khaki"]
    [(string=? color "khaki") "orange"]
    [(string=? color "orange") "crimson"]
    [(string=? color "crimson") "gray"]))


;; next-doodad: Doodad -> Doodad
;; GIVEN: a Doodad
;; RETURNS: the next Doodad follows the one given.
;; EXAMPLES:
;; (next-doodad star-gold-at-top-left) = (make-doodad 9 11 10 12
;;                                        "green" #true 0 0)
;; (next-doodad RAD-STAR) = (make-doodad 135 132 10 12 "gold" #false 0 0)
;; (next-doodad square-orange-at-left) = (make-doodad 12 234 13 9
;;                                        "crimson" #true 8 9)
;; STRATEGY: Use template for Doodad on d

(define (next-doodad d)
  (cond
    [(and (< (+ (doodad-x d) (doodad-vx d)) 0)
          (< (+ (doodad-y d) (doodad-vy d)) 0))
     (make-doodad (abs (+ (doodad-x d) (doodad-vx d)))
                  (abs (+ (doodad-y d) (doodad-vy d)))
                  (- 0 (doodad-vx d))
                  (- 0 (doodad-vy d))
                  (next-color (doodad-color d))
                  (doodad-selected? d)
                  (doodad-dx d)
                  (doodad-dy d))]
    [(and (>= (+ (doodad-x d) (doodad-vx d)) 601)
          (< (+ (doodad-y d) (doodad-vy d)) 0))
     (make-doodad (- 1200 (+ (doodad-x d) (doodad-vx d)))
                  (abs (+ (doodad-y d) (doodad-vy d)))
                  (- 0 (doodad-vx d))
                  (- 0 (doodad-vy d))
                  (next-color (doodad-color d))
                  (doodad-selected? d)
                  (doodad-dx d)
                  (doodad-dy d))]
    [(and (>= (+ (doodad-x d) (doodad-vx d)) 601)
          (>= (+ (doodad-y d) (doodad-vy d)) 449))
     (make-doodad (- 1200 (+ (doodad-x d) (doodad-vx d)))
                  (- 896 (+ (doodad-y d) (doodad-vy d)))
                  (- 0 (doodad-vx d))
                  (- 0 (doodad-vy d))
                  (next-color (doodad-color d))
                  (doodad-selected? d)
                  (doodad-dx d)
                  (doodad-dy d))]
    [(and (< (+ (doodad-x d) (doodad-vx d)) 0)
          (>= (+ (doodad-y d) (doodad-vy d)) 449))
     (make-doodad (abs (+ (doodad-x d) (doodad-vx d)))
                  (- 896 (+ (doodad-y d) (doodad-vy d)))
                  (- 0 (doodad-vx d))
                  (- 0 (doodad-vy d))
                  (next-color (doodad-color d))
                  (doodad-selected? d)
                  (doodad-dx d)
                  (doodad-dy d))]
    [(and (< (+ (doodad-x d) (doodad-vx d)) 0)
          (and (< (+ (doodad-y d) (doodad-vy d)) 449)
          (>= (+ (doodad-y d) (doodad-vy d)) 0)))
     (make-doodad (abs (+ (doodad-x d) (doodad-vx d)))
                  (+ (doodad-y d) (doodad-vy d))
                  (- 0 (doodad-vx d))
                  (doodad-vy d)
                  (next-color (doodad-color d))
                  (doodad-selected? d)
                  (doodad-dx d)
                  (doodad-dy d))]
    [(and (>= (+ (doodad-x d) (doodad-vx d)) 601)
          (and (< (+ (doodad-y d) (doodad-vy d)) 449)
          (>= (+ (doodad-y d) (doodad-vy d)) 0)))
     (make-doodad (- 1200 (+ (doodad-x d) (doodad-vx d)))
                  (+ (doodad-y d) (doodad-vy d))
                  (- 0 (doodad-vx d))
                  (doodad-vy d)
                  (next-color (doodad-color d))
                  (doodad-selected? d)
                  (doodad-dx d)
                  (doodad-dy d))]
    [(and (< (+ (doodad-y d) (doodad-vy d)) 0)
          (and (< (+ (doodad-x d) (doodad-vx d)) 601)
          (>= (+ (doodad-x d) (doodad-vx d)) 0)))
     (make-doodad (+ (doodad-x d) (doodad-vx d))
                  (abs (+ (doodad-y d) (doodad-vy d)))
                  (doodad-vx d)
                  (- 0 (doodad-vy d))
                  (next-color (doodad-color d))
                  (doodad-selected? d)
                  (doodad-dx d)
                  (doodad-dy d))]
    [(and (>= (+ (doodad-y d) (doodad-vy d)) 449)
          (and (< (+ (doodad-x d) (doodad-vx d)) 601)
          (>= (+ (doodad-x d) (doodad-vx d)) 0)))
     (make-doodad (+ (doodad-x d) (doodad-vx d))
                  (- 896 (+ (doodad-y d) (doodad-vy d)))
                  (doodad-vx d)
                  (- 0 (doodad-vy d))
                  (next-color (doodad-color d))
                  (doodad-selected? d)
                  (doodad-dx d)
                  (doodad-dy d))]
    [else
     (make-doodad (+ (doodad-x d) (doodad-vx d))
                  (+ (doodad-y d) (doodad-vy d))
                  (doodad-vx d)
                  (doodad-vy d)
                  (doodad-color d)
                  (doodad-selected? d)
                  (doodad-dx d)
                  (doodad-dy d))]))

;; TESTS:
(begin-for-test
  (check-equal? (next-doodad star-gold-at-top-left)
                (make-doodad 9 11 10 12 "green" #true 0 0)
    "(next-doodad star-gold-at-top-left) should return
     (make-doodad 9 11 10 12 'green' #true 0 0)")
  (check-equal? (next-doodad star-green-at-top-right)
                (make-doodad 590 11 -10 12 "blue" #false 0 0)
    "(next-doodad star-green-at-top-right) should return
     (make-doodad 590 11 -10 12 'blue' #false 0 0)")
  (check-equal? (next-doodad star-blue-at-bottom-left)
                (make-doodad 10 436 10 -12 "gold" #true 6 6)
    "(next-doodad star-blue-at-bottom-left) should return
     (make-doodad 10 436 10 -12 'gold' #true 6 6)")
  (check-equal? (next-doodad square-gray-at-bottom-right)
                (make-doodad 587 439 -13 -9 "olivedrab" #false 0 0)
    "(next-doodad square-gray-at-bottom-right) should return
     (make-doodad 587 439 -13 -9 'olivedrab' #false 0 0)")
  (check-equal? (next-doodad square-olivedrab-at-bottom)
                (make-doodad 313 439 13 -9 "khaki" #true 7 7)
    "(next-doodad square-olivedrab-at-bottom) should return
     (make-doodad 313 439 13 -9 'khaki' #true 7 7)")
  (check-equal? (next-doodad square-khaki-at-top)
                (make-doodad 313 8 13 9 "orange" #true 5 7)
    "(next-doodad square-khaki-at-top) should return
     (make-doodad 313 8 13 9 'orange' #true 5 7)")
  (check-equal? (next-doodad square-orange-at-left)
                (make-doodad 12 234 13 9 "crimson" #true 8 9)
    "(next-doodad square-orange-at-left) should return
     (make-doodad 12 234 13 9 'crimson' #true 8 9)")
  (check-equal? (next-doodad square-crimson-at-right)
                (make-doodad 587 234 -13 9 "gray" #false 0 0)
    "(next-doodad square-crimson-at-right) should return
     (make-doodad 587 234 -13 9 'gray' #false 0 0)")
  (check-equal? (next-doodad star-gold-at-center)
                (make-doodad 310 237 10 12 "gold" #true 3 8)
    "(next-doodad star-gold-at-center) should return
     (make-doodad 310 237 10 12 'gold' #true 3 8)"))


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

;; c-key-event-change-color : Doodad -> Doodad
;; GIVEN: a Doodad
;; RETURNS: a new Doodad with color change iff the Doodad is selected.
;; EXAMPLE:
;; (c-key-event-change-color star-gold-at-top-left) =
;;       (make-doodad 1 1 -10 -12 "green" #true 0 0)
;; (c-key-event-change-color star-green-at-top-right)
;;       (make-doodad 600 1 10 -12 "green" #false 0 0)
;; STRATEGY: Use Doodad template on d

(define (c-key-event-change-color d)
  (if (doodad-selected? d)
      (make-doodad (doodad-x d) (doodad-y d) (doodad-vx d) (doodad-vy d)
                   (next-color (doodad-color d)) (doodad-selected? d)
                   (doodad-dx d) (doodad-dy d))
      d))


;; world-with-paused-toggled : World -> World
;; GIVEN: A World.
;; RETURNS: a World just like the given one, but with paused? toggled
;; EXAMPLE:
;; (world-with-paused-toggled unpaused-initial-world) = paused-initial-world
;; (world-with-paused-toggled paused-1) = unpaused-1
;; STRATEGY: Use template for World on w
    
(define (world-with-paused-toggled w)
  (make-world
   (world-doodad-star w)
   (world-doodad-square w)
   (not (world-paused? w))))


;; world-with-doodad-color-change : World -> World
;; GIVEN: A World.
;; RETURNS: a World just like the given one, but with Doodad color change.
;; EXAMPLE:
;; (world-with-doodad-color-change paused-1) =
;;     (make-world (make-doodad 1 1 -10 -12 "green" #true 0 0)
;;     (make-doodad 460 350 13 -9 "gray" #false 0 0) #true)
;; (world-with-doodad-color-change unpaused-4) =
;;     (make-world (make-doodad 125 120 10 12 "gold" #false 0 0)
;;     (make-doodad 300 1 13 -9 "orange" #true 5 7) #false)
;; (world-with-doodad-color-change unpaused-7) =
;;     (make-world (make-doodad 1 1 -10 -12 "green" #true 0 0)
;;     (make-doodad 1 1 -13 -9 "olivedrab" #true 0 0) #false)
;; STRATEGY: Use template for World on w
    
(define (world-with-doodad-color-change w)
  (make-world
   (c-key-event-change-color (world-doodad-star w))
   (c-key-event-change-color (world-doodad-square w))
   (world-paused? w)))

;; TESTS: 
(begin-for-test
  (check-equal? (world-with-doodad-color-change paused-1)
                (make-world (make-doodad 1 1 -10 -12 "green" #true 0 0)
                            (make-doodad 460 350 -13 -9 "gray" #false 0 0)
                            #true)
    "(world-with-doodad-color-change paused-1) returns the incorrect world.")
  (check-equal? (world-with-doodad-color-change unpaused-4)
                (make-world (make-doodad 125 120 10 12 "gold" #false 0 0)
                            (make-doodad 300 1 13 -9 "orange" #true 5 7) #false)
    "(world-with-doodad-color-change unpaused-4) returns the incorrect world.")
  (check-equal? (world-with-doodad-color-change unpaused-7)
                (make-world (make-doodad 1 1 -10 -12 "green" #true 0 0)
                            (make-doodad 1 1 -13 -9 "olivedrab" #true 0 0)
                            #false)
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
;; (initial-world -174) = (make-world RAD-STAR SQUARE false)
;; STRATEGY: combine simpler functions

(define (initial-world anything)
  (make-world RAD-STAR SQUARE false))

;; TESTS:
(begin-for-test
  (check-equal? (initial-world -174) (make-world RAD-STAR SQUARE false)
    "(is-pause-key-event? ' ') should return true"))


;; world-after-tick : World -> World
;; GIVEN: a World that's possible for the animation
;; RETURNS: the World that should follow the given World after a tick.
;; EXAMPLES: 
;; moving:
;; (world-after-tick unpaused-initial-world)
;;  = (make-world
;;     (make-doodad 135 132 10 12 "gold" #false 0 0)
;;     (make-doodad 473 341 13 -9 "gray" #false 0 0)
;;     #false)
;; paused:
;; (world-after-tick paused-1)
;;  = (make-world
;;     (make-doodad 1 1 -10 -12 "gold" #true 0 0)
;;     (make-doodad 460 350 13 -9 "gray" #false 0 0)
;;     #true)

;; STRATEGY: Use template for World on w

(define (world-after-tick w)
  (if (world-paused? w)
      w
      (make-world (next-doodad (world-doodad-star w))
                  (next-doodad (world-doodad-square w))
                  (world-paused? w))))

;; TESTS:
(begin-for-test
  (check-equal? (world-after-tick unpaused-initial-world)
                (make-world (make-doodad 135 132 10 12 "gold" #false 0 0)
                            (make-doodad 447 341 -13 -9 "gray" #false 0 0)
                            #false)
    "(world-after-tick unpaused-initial-world) returned incorrect World.")
  (check-equal? (world-after-tick paused-initial-world)
                (make-world (make-doodad 125 120 10 12 "gold" #false 0 0)
                            (make-doodad 460 350 -13 -9 "gray" #false 0 0)
                            #true)
    "(world-after-tick paused-initial-world) returned incorrect World.")
  (check-equal? (world-after-tick unpaused-1)
                (make-world (make-doodad 9 11 10 12 "green" #true 0 0)
                            (make-doodad 447 341 -13 -9 "gray" #false 0 0)
                            #false)
    "(world-after-tick unpaused-1) returned incorrect World.")
  (check-equal? (world-after-tick paused-1)
                (make-world (make-doodad 1 1 -10 -12 "gold" #true 0 0)
                            (make-doodad 460 350 -13 -9 "gray" #false 0 0)
                            #true)
    "(world-after-tick paused-1) returned incorrect World.")
  (check-equal? (world-after-tick unpaused-2)
                (make-world (make-doodad 590 11 -10 12 "blue" #false 0 0)
                            (make-doodad 587 439 -13 -9 "olivedrab" #false 0 0)
                            #false)
    "(world-after-tick unpaused-2) returned incorrect World.")
  (check-equal? (world-after-tick paused-2)
                (make-world (make-doodad 600 1 10 -12 "green" #false 0 0)
                            (make-doodad 600 448 13 9 "gray" #false 0 0)
                            #true)
    "(world-after-tick paused-2) returned incorrect World.")
  (check-equal? (world-after-tick unpaused-3)
                (make-world (make-doodad 10 436 10 -12 "gold" #true 6 6)
                            (make-doodad 313 439 13 -9 "khaki" #true 7 7)
                            #false)
    "(world-after-tick unpaused-3) returned incorrect World.")
  (check-equal? (world-after-tick unpaused-4)
                (make-world (make-doodad 135 132 10 12 "gold" #false 0 0)
                            (make-doodad 313 8 13 9 "orange" #true 5 7)
                            #false)
    "(world-after-tick unpaused-4) returned incorrect World.")
  (check-equal? (world-after-tick unpaused-5)
                (make-world (make-doodad 135 132 10 12 "gold" #false 0 0)
                            (make-doodad 12 234 13 9 "crimson" #true 8 9)
                            #false)
    "(world-after-tick unpaused-5) returned incorrect World.")
  (check-equal? (world-after-tick unpaused-6)
                (make-world (make-doodad 135 132 10 12 "gold" #false 0 0)
                            (make-doodad 587 234 -13 9 "gray" #false 0 0)
                            #false)
    "(world-after-tick unpaused-6) returned incorrect World.")
  (check-equal? (world-after-tick unpaused-7)
                (make-world (make-doodad 9 11 10 12 "green" #true 0 0)
                            (make-doodad 12 8 13 9 "olivedrab" #true 0 0)
                            #false)
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
    "(world-after-key-event paused-initial-world ' ')
    returned incorrect World."))



;; doodad-after-mouse-event : Doodad Integer Integer MouseEvent -> Doodad
;; GIVEN: A Doodad, the x and y coordinates of a mouse event, and
;;        the MouseEvent
;; RETURNS: the Doodad as it should be after the given mouse event.
;; EXAMPLES:
;; (doodad-after-mouse-event star-green-at-top-right 590 10 "button-down") =
;;     (make-doodad 600 1 0 0 "green" #true -10 9)
;; (doodad-after-mouse-event star-gold-at-top-left 10 10 "drag") =
;;     (make-doodad 10 10 -10 -12 "gold" #true 0 0)
;; (doodad-after-mouse-event star-blue-at-bottom-left 10 438 "button-up") =
;;     (make-doodad 0 448 10 12 "blue" #false 0 0)
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
                (make-doodad 600 225 0 0 "crimson" #true -10 -10)
    "(doodad-after-mouse-event square-crimson-at-right 590 215 'button-down')
     returned incorrect Doodad.")
  (check-equal? (doodad-after-mouse-event star-gold-at-top-left 10 10 "drag")
                (make-doodad 10 10 -10 -12 "gold" #true 0 0)
    "(doodad-after-mouse-event star-gold-at-top-left 10 10 'drag') returned
     incorrect Doodad.")
  (check-equal? (doodad-after-mouse-event star-blue-at-bottom-left 10 438
                                          "button-up")
                (make-doodad 0 448 10 12 "blue" #false 0 0)
    "(doodad-after-mouse-event star-blue-at-bottom-left 10 438 'button-up')
     returned incorrect Doodad.")
  (check-equal? (doodad-after-mouse-event star-gold-at-top-left 10 10 "leave")
                star-gold-at-top-left
    "(doodad-after-mouse-event star-gold-at-top-left 10 10 'leave')
     returned incorrect Doodad.")
  (check-equal? (doodad-after-mouse-event star-green-at-top-right 590 10
                                          "button-down")
                (make-doodad 600 1 0 0 "green" #true -10 9)
    "(doodad-after-mouse-event star-green-at-top-right 590 10 'button-down')
     returned incorrect Doodad.")
  (check-equal? (doodad-after-mouse-event star-green-at-top-right 590 10
                                          "button-up")
                (make-doodad 600 1 10 -12 "green" #false 0 0)
    "(doodad-after-mouse-event star-green-at-top-right 590 10 'button-up')
     returned incorrect Doodad.")
  (check-equal? (doodad-after-mouse-event square-khaki-at-top 290 10
                                          "button-down")
                (make-doodad 300 1 0 0 "khaki" #true -10 9)
    "(doodad-after-mouse-event square-khaki-at-top 290 10 'button-down')
     returned incorrect Doodad.")
  (check-equal? (doodad-after-mouse-event square-orange-at-left 10 215
                                          "button-down")
                (make-doodad 1 225 0 0 "orange" #true 9 -10)
    "(doodad-after-mouse-event square-orange-at-left 10 215 'button-down')
     returned incorrect Doodad."))


;; world-after-mouse-event : World Integer Integer MouseEvent -> World
;; GIVEN: A World, the x and y coordinates of a mouse event, and
;;        the MouseEvent
;; RETURNS: the World as it should be after the given mouse event.
;; EXAMPLES:
;; (world-after-mouse-event unpaused-initial-world 120 110 "button-down") =
;;     (make-world (make-doodad 125 120 0 0 "gold" #true -5 -10)
;;                 (make-doodad 460 350 13 -9 "gray" #false 0 0)
;;                 #false)
;; (world-after-mouse-event paused-1 10 10 "drag") =
;;     (make-world (make-doodad 10 10 -10 -12 "gold" #true 0 0)
;;                 (make-doodad 460 350 13 -9 "gray" #false 0 0)
;;                 #true)
;; (world-after-mouse-event unpaused-3 10 438 "button-up") =
;;     (make-world (make-doodad 0 448 10 12 "blue" #false 0 0)
;;                 (make-doodad 300 448 13 -9 "olivedrab" #false 0 0)
;;                 #false)
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
                (make-world (make-doodad 125 120 0 0 "gold" #true -5 -10)
                            (make-doodad 460 350 -13 -9 "gray" #false 0 0)
                            #false)
    "(world-after-mouse-event unpaused-initial-world 120 110 'button-down')
      returned incorrect World.")
  (check-equal? (world-after-mouse-event paused-1 10 10 "drag")
                (make-world (make-doodad 10 10 -10 -12 "gold" #true 0 0)
                            (make-doodad 460 350 -13 -9 "gray" #false 0 0)
                            #true)
    "(world-after-mouse-event paused-1 10 10 'drag') returned incorrect World.")
  (check-equal? (world-after-mouse-event unpaused-3 10 438 "button-up")
                (make-world (make-doodad 0 448 10 12 "blue" #false 0 0)
                            (make-doodad 300 448 -13 -9 "olivedrab" #false 0 0)
                            #false)
    "(world-after-mouse-event unpaused-3 10 438 'button-up')
    returned incorrect World.")
  (check-equal? (world-after-mouse-event paused-2 10 1 "leave")
                paused-2
    "(world-after-mouse-event paused-2 10 1 'leave')
    returned incorrect World."))




;;  Run animation with 10x the speed:
;; (animation 0.1)
                