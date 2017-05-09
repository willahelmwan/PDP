;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Goal: Use the ADTs in the provided flight.rkt to define and provide functions
;;       can-get-there? , fastest-itinerary , and travel-time. can-get-there?
;;       checks to see if the flight can get from one airport to another
;;       airport. fastest-itinerary checks to see which flight route is the
;;       fastest to get from one airport to another airport. travel-time gives
;;       the fastest time go from one airport to another airport. No there are
;;       no non-trivial round trips. 

(require rackunit)
(require "extras.rkt")
(require "flight.rkt")
(check-location "07" "q2.rkt")

(provide
 can-get-there?
 fastest-itinerary
 travel-time)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; CONSTANT DEFINITIONS:

;; Minutes per hour
(define MINPERHR 60)
;; 24 hours converted into minutes
(define MIN24 1440)

;; Examples for testing
(define f1
  (make-flight "Delta 0121" "LGA" "MSP" (make-UTC 11 0) (make-UTC 14 9)))
(define f2
  (make-flight "Delta 0122" "MSP" "LHR" (make-UTC 14 0) (make-UTC 15 9)))
(define f3
  (make-flight "Delta 0123" "LHR" "BOS" (make-UTC 17 10) (make-UTC 22 15)))
(define f4
  (make-flight "Delta 0124" "MSP" "BOS" (make-UTC 10 0) (make-UTC 18 15)))
(define f5
  (make-flight "Delta 0125" "LGA" "DXB" (make-UTC 11 0) (make-UTC 14 9)))
(define f6
  (make-flight "Delta 0126" "DXB" "BOS" (make-UTC 16 01) (make-UTC 10 00)))
(define f7
  (make-flight "Delta 0127" "DXB" "LHR" (make-UTC 14 9) (make-UTC 14 10)))
(define f8
  (make-flight "Delta 0128" "LGA" "DTW" (make-UTC 10 0) (make-UTC 11 10)))
(define f9
  (make-flight "Delta 0129" "DTW" "LHR" (make-UTC 11 10) (make-UTC 14 9)))
(define f10
  (make-flight "Delta 0130" "DTW" "DEL" (make-UTC 15 0) (make-UTC 23 9)))
(define f11
  (make-flight "Delta 0131" "PDX" "DTW" (make-UTC 09 0) (make-UTC 12 0)))
(define f12
  (make-flight "Delta 0132" "PDX" "LAX" (make-UTC 08 0) (make-UTC 09 9)))
(define f13
  (make-flight "Delta 0133" "PDX" "DXB" (make-UTC 22 0) (make-UTC 12 0)))
(define f14
  (make-flight "Delta 0134" "LAX" "DTW" (make-UTC 10 0) (make-UTC 11 25)))
(define f15
  (make-flight "Delta 0135" "LAX" "DXB" (make-UTC 11 0) (make-UTC 20 00)))
(define f16
  (make-flight "Delta 0136" "LAX" "DEL" (make-UTC 16 0) (make-UTC 14 9)))
(define f17
  (make-flight "Delta 0137" "BOS" "DEL" (make-UTC 20 0) (make-UTC 19 59)))
(define f18
  (make-flight "Delta 0138" "BOS" "LGA" (make-UTC 20 0) (make-UTC 19 59)))
(define f19
  (make-flight "Delta 0139" "MSP" "LGA" (make-UTC 20 0) (make-UTC 19 59)))
(define f20
  (make-flight "Delta 0140" "LHR" "LGA" (make-UTC 20 0) (make-UTC 19 59)))

(define testLOF (list f1 f2 f3 f4 f5 f6 f7 f8 f9
                      f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20))

(define panAmFlights '())

(define df1 (make-flight "Delta 0121" "LGA" "MSP" (make-UTC 11 00)
                         (make-UTC 14 09)))
(define df2 (make-flight "Delta 1609" "MSP" "DEN" (make-UTC 20 35)
                         (make-UTC 22 52)))
(define df3 (make-flight "Delta 5703" "DEN" "LAX" (make-UTC 14 04)
                         (make-UTC 17 15)))
(define df4 (make-flight "Delta 2077" "LAX" "PDX" (make-UTC 17 35)
                         (make-UTC 20 09)))
(define df5 (make-flight "Delta 2163" "MSP" "PDX" (make-UTC 15 00)
                         (make-UTC 19 02)))
 
(define deltaFlights
  (list df1 df2 df3 df4 df5))

;; END CONSTANT DEFINITION

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; DATA DEFINITIONS:

;; A ListOfFlight (LOF) is one of
;; -- empty
;; -- (cons Flight LOF)
;; INTERPRETATION:
;; empty is a sequence of Flight with no elements
;; (cons f lof) represents a sequence of Flights whose first element is f and
;;              whose other elements are represented by lof.

;; TEMPLATE:
;; lof-fn : LOF -> ??
;; HALTING MEASURE: length of lof
#;
(define (lof-fn lof)
  (cond
    [(empty? lof) ...]
    [else (...
           (flight-fn (first lof))
           (lof-fn (rest lof)))]))


;; A ListOfListOfFlight (LLOF) is one of
;; -- empty
;; -- (cons LOF LLOF)
;; INTERPRETATION:
;; empty is a sequence of LOF with no elements
;; (cons lof llof) represents a sequence of LLOF whose first element is lof and
;;                 whose other elements are represented by llof.

;; TEMPLATE:
;; llof-fn : LLOF -> ??
;; HALTING MEASURE: length of llof
#;
(define (llof-fn llof)
  (cond
    [(empty? llof) ...]
    [else (...
           (lof-fn (first llof))
           (llof-fn (rest llof)))]))


(define-struct itinerary (flight flights))
;; A Itinerary is a
;; (make-itinerary Flight Itineraries)
;; INTERPRETATION:
;; flight is a Flight node
;; flights is all the children of the Flight node

;; A Itineraries is one of
;; -- empty
;; -- (cons Itinerary Itineraries)

;; itinerary-fn : Itinerary -> ??
#;
(define (itinerary-fn i)
  (... (itinerary-flight i)
       (itineraries-fn (itinerary-flights i))))

;; itineraries-fn : Itineraries -> ??
#;
(define (itineraries-fn is)
  (cond
    [(empty? is) ...]
    [else (... (itinerary-fn (first is))
               (itineraries-fn (rest is)))]))

;; END DATA DEFINITION


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; HELPER FUNCTIONS:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; flight-children : Flight ListOfFlight -> ListOfFlight
;; GIVEN: a Flight f and a ListOfFlight lof
;; RETURNS: a list of Flights whose departure airports are the same as the
;;          arrival airport of the given Flight f.
;; EXAMPLE:
;; (flight-children f1 (list f1 f2 f3 f4)) = (list f2 f4)

;; STRATEGY: Use HOF filter on lof

(define (flight-children f lof)
  (filter
   ;; Flight -> Boolean
   ;; RETURNS: true iff the departure airport of the Flight is the same as the
   ;;          arrival airport of f.
   (lambda (f1) (string=? (departs f1) (arrives f)))
   lof))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; flight-itinerary : Flight LOF LOF -> Itinerary
;; GIVEN: a Flight f, a LOF lof, and a LOF lofpro
;; RETURNS: an Itinerary with the node at Flight f and all of the Flight's
;;          children in lof and not in lofpro
;; EXAMPLE:
;; (flight-itinerary f1 (list f1 f2) empty) =
;; (make-itinerary f1
;;                 (list(make-itinerary f2 '())))

;; STRATEGY: Combine simpler functions and use mutually recursive functions

;; flight-itineraries : LOF LOF LOF -> Itineraries
;; GIVEN: a LOF lof1, a LOF lof2, and a LOF lofpro
;; RETURNS: a list of Itinerary made from each Flight of lof2. 
;; EXAMPLE:
;; (flight-itineraries (list f1 f2) (list f1) empty) =
;; (list
;;  (make-itinerary f1
;;                  (list (make-itinerary f2 '())))

;; STRATEGY: Use template for LOF on lof2
;; HALTING MEASURE: length of lof2

(define (flight-itinerary f lof lofpro)
  (make-itinerary f (flight-itineraries lof (flight-children f lof) lofpro)))

(define (flight-itineraries lof1 lof2 lofpro)
  (cond
    [(empty? lof2) empty]
    [(member? (first lof2) lofpro) (flight-itineraries lof1 (rest lof2) lofpro)]
    [else (cons(flight-itinerary (first lof2)
                                 lof1
                                 (cons (first lof2) lofpro))
               (flight-itineraries lof1
                                   (rest lof2)
                                   (cons (first lof2) lofpro)))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; dest-match? : String Flight -> Boolean
;; GIVEN: a destination airport and a Flight
;; RETURNS: true iff the destination airport is the same as the arrival airport
;;          of the Flight
;; EXAMPLE: (dest-match? "MSP" f1) = #true

;; STRATEGY: combine simpler functions

(define (dest-match? des f)
  (string=? des (arrives f)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; in-itinerary? : Itinerary String -> Boolean
;; GIVEN: an Itinerary and a destination
;; RETURNS: true iff the destination is in the given Itinerary
;; EXAMPLE:
;; (in-itinerary? (make-itinerary f1
;;                                (list(make-itinerary f2 '())))
;;                "DEL") = #false

;; STRATEGY: Use template of Itineray on i

;; in-itineraries? : Itineraries String -> Boolean
;; GIVEN: an Itineraries and a destination
;; RETURNS: true iff the destination is in the given Itineraries
;; EXAMPLE:
;; (in-itineraries? (list
;;                   (make-itinerary f1 (list f2))) "MSP") = #true

;; STRATEGY: Use HOF ormap on is
;; HALTING MEASURE: length of is

(define (in-itinerary? i des)
  (cond
    [(dest-match? des (itinerary-flight i)) true]
    [else 
     (in-itineraries? (itinerary-flights i) des)]))


(define (in-itineraries? is des)
  (ormap
   ;; Itinerary -> Boolean
   ;; RETURNS: true iff the destination is in the given Itinerary
   (lambda (i1) (in-itinerary? i1 des))
   is))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; departure-flights : String LOF -> LOF
;; GIVEN: a name of departure airport and a ListOfFlights
;; RETURN: LOF departs from the same airport
;; EXAMPLE:
;; (departure-flights "LGA" (list f1 f2 f3 f4 f5 f6 f7 f8)) =
;; (list f1 f5 f8)

;; STRATEGY: use HOF filter on lof

(define (departure-flights source lof)
  (filter
   ;; Flight -> Boolean
   ;; RETURNS: true iff departuring airport of the Flight is same as the source
   (lambda (f1) (string=? (departs f1) source))
   lof))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; UTC-to-minutes : UTC -> NonNegInt
;; GIVEN: a represetation of a time in UTC.
;; RETURNS: the number of minutes that UTC represents
;; EXAMPLE:
;; (UTC-to-minutes (make-UTC 14 00)) = 840

;; STRATEGY: Combine simpler functions

(define (UTC-to-minutes u)
  (+ (* (UTC-hour u) MINPERHR) (UTC-minute u)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; minute-duration : NonNegInt NonNegInt -> NonNegInt
;; GIVEN: a time t1 represented in minutes and a time t2 represented in minutes
;; RETURNS: the number of minutes from t1 to t2.
;; EXAMPLE:
;; (minute-duration 60 1380) = 1320
;; (minute-duration 1380 60) = 120

;; STRATEGY: Combine simpler functions

(define (minute-duration t1 t2)
  (if (< t1 t2)
      (- t2 t1)
      (+ (- MIN24 t1) t2)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; flight-duration : Flight -> NonNegInt
;; GIVEN: a Flight
;; RETURN: the flight duration in minutes.
;; EXAMPLE:
;; (flight-duration f1) = 189

;; STRATEGY: Combine simpler functions

(define (flight-duration f)
  (minute-duration (UTC-to-minutes (departs-at f))
                   (UTC-to-minutes (arrives-at f))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; layover-duration : Flight Flight -> NonNegInt
;; GIVEN: a Flight f1 and a Flight f2
;; RETURN: the layover time between f1 and f2 in minutes.
;; EXAMPLE:
;; (layover-duration f1 f2) = 1431

;; STRATEGY: Combine simpler functions

(define (layover-duration f1 f2)
  (minute-duration (UTC-to-minutes (arrives-at f1))
                   (UTC-to-minutes (departs-at f2))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; lof-can-reach-des : LOF LOF String -> LOF
;; GIVEN: a ListOfFlight lof1, a ListOfFlight lof2 and a destination des
;; RETURNS: a ListOfFlight that contains the flights in lof1 that can reach
;;          the destination using lof2.
;; EXAMPLE:
;; (lof-can-reach-des (list f1 f2 f3 f4 f5 f6 f7) (list f1 f2) "DXB") =
;; (list f5)

;; STRATEGY: Use HOF filter on lof1

(define (lof-can-reach-des lof1 lof2 des)
  (filter
   ;; Flight -> Boolean
   ;; RETURNS: true iff arriving airport of the Flight can reach the destination
   (lambda (f) (can-get-there? (arrives f) des lof2))
   lof1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; build-sub-flight-list : LOF LOF -> LLOF
;; GIVEN: a ListOfFlight lof1 and a ListOfFlight lof2
;; RETURNS: A List of List of Flight with the Flight in lof2 prepended to lof1.
;; EXAMPLE:
;; (build-sub-flight-list (list f1 f2) (list f3 f4)) =
;; (list
;;  (list f3 f1 f2)
;;  (list f4 f1 f2))

;; STRATEGY: Use HOF map on lof2

(define (build-sub-flight-list lof1 lof2)
  (if (empty? lof2)
      (cons lof1 empty)
      (map
       ;; Flight -> LOF
       ;; RETURNS: a LOF with the Flight prepended to lof1
       (lambda (f) (cons f lof1))
       lof2)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; no-children? : LLOF LOF -> Boolean
;; GIVEN: a ListOfListOfFlight llof and a ListOfFlight lof
;; RETURNS: true iff none of the first Flight of each ListOfFlight of llof
;;          has children from lof.
;; EXAMPLE:
;; (no-children? (list(list f1 f2 f3)) (list f14 f15)) = #true
;; (no-children? (list(list f1 f2 f3)) (list f4 f5)) = #false

;; STRATEGY: Use HOF andmap on llof

(define (no-children? llof lof)
  (andmap
   ;; LOF -> Boolean
   ;; RETURNS: true iff the first Flight of the ListOfFlight has no children in
   ;;          lof
   (lambda (lof1) (empty? (flight-children (first lof1) lof)))
   llof))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; remove-flight : Flight LOF -> LOF
;; GIVEN: Flight f and a ListOfFlight lof
;; RETURNS: a ListOfFlight with f removed from lof.
;; EXAMPLE:
;; (remove-flight f1 (list f1 f2 f3)) = (list f2 f3)

;; STRATEGY: Use HOF filter on lof

(define (remove-flight f lof)
  (filter
   ;; Flight -> Boolean 
   ;; RETURNS: true iff the Flight is not the same as f
   (lambda (f1) (not (equal? f f1)))
   lof))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; all-possible-routes : LLOF LOF -> LLOF
;; GIVEN: a ListOfListOfFlight that contains the ListOfFlight 
;;        which has exactly one Flight, and a ListOfFlight lof.
;; RETURNS: A ListOfListOfFlights that represents all possible routes from
;;          the departure airport of the Flights in the ListOfListOfFlight to
;;          to all destinations which has no departure Flights in lof.
;; EXAMPLE:
;; (all-possible-routes (list(list f1)) (list f1 f2 f3 f4)) =
;; (list
;;  (list f3 f2 f1)
;;  (list f4 f1))

;; STRATEGY: Use template of LLOF on llof
;; HALTING MEASURE: the number of children of the first Flight of
;;                  all of the ListOfFlight of the ListOfListOfFlight.

(define (all-possible-routes llof lof)
  (cond
    [(no-children? llof lof) llof]
    [else (append
           (all-possible-routes
            (build-sub-flight-list (first llof)
                                   (flight-children (first (first llof)) lof))
            (remove-flight (first (first llof)) lof))
           (all-possible-routes (rest llof) lof))]))
     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; total-flight-time : LOF -> NonNegInt
;; GIVEN: a List of connecting Flights
;; RETURNS: the total flight time of these Flights in minutes
;; EXAMPLE:
;; (total-flight-time (list f1 f2 f3)) = 563

;; STRATEGY: Use HOF map on lof and followed by HOF foldr. 

(define (total-flight-time lof)
  (foldr + 0 (map flight-duration lof)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; total-layover-time : LOF -> NonNegInt
;; GIVEN: a List of connecting Flights
;; WHERE: the LOF is not empty
;; RETURNS: the total layover time of these Flights in minutes
;; EXAMPLE:
;; (total-layover-time (list f2 f3)) = 121

;; STRATEGY: Use template of LOF on lof
;; HALTING MEASURE: length of lof

(define (total-layover-time lof)
  (cond
    [(empty? (rest lof)) 0]
    [else (+ (layover-duration (first lof) (first (rest lof)))
             (total-layover-time (rest lof)))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; total-travel-time: LOF -> NonNegInt
;; GIVEN: a List of connecting Flights
;; WHERE: the LOF is not empty
;; RETURNS: the total travel time of these Flights in minutes
;; EXAMPLE:
;; (total-travel-time (list f1 f2 f3)) = 2115

;; STRATEGY: Combine simpler functions

(define (total-travel-time lof)
  (+ (total-flight-time lof) (total-layover-time lof)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; list-of-departure-flight : LOF String -> LOF
;; GIVEN: a ListOfFlight, name of source airport src.
;; RETURNS: a list of Flight which departs from source airport src
;; EXAMPLE:
;; (list-of-departure-flight (list f1 f2 f3 f8) "LGA") = (list f1 f8)

;; STRATEGY: Use HOF filter on lof

(define (list-of-departure-flight lof src)
  (filter
   ;; Flight -> Boolean
   ;; RETURNS: true iff the Flight's depature airport is the same as the
   ;;          src airport.
   (lambda (f) (string=? src (departs f)))
   lof))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; lof-to-llof : LOF -> LLOF
;; GIVEN: a ListOfFlight
;; RETURNS: a ListOfListOfFlight with the same length of the given ListOfFlight
;;          with each Flight in the given ListOfFlight converted into a LOF.
;; EXAMPLE:
;; (lof-to-llof (list f1 f2 f3)) =
;; (list
;;  (list f1)
;;  (list f2)
;;  (list f3))

;; STRATEGY: Use HOF map on lof

(define (lof-to-llof lof)
  (map
   ;; Flight -> LOF
   ;; RETURNS: a ListOfFlight that only contains the given Flight.
   (lambda (f) (cons f empty))
   lof))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; faster : LOF LOF -> LOF
;; GIVEN: two ListOfFlights
;; RETURNS: the ListOfFlights with the faster total-travel-time
;; EXAMPLE:
;; (faster (list f1 f2) (list f5 f6)) = (list f5 f6)

;; STRATEGY: Combine simpler function

(define (faster lof1 lof2)
  (if (< (total-travel-time lof1) (total-travel-time lof2))
      lof1
      lof2))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; fastest : LLOF -> LOF
;; GIVEN: a ListOfListOfFlight
;; WHERE: the LLOF is not empty
;; RETURNS: fastest ListOfFlight
;; EXAMPLE:
;; (fastest (list(list f1 f2)(list f1 f4))) = (list f1 f2)

;; STRATEGY: Use template of LLOF on llof
;; HALTING MEASURE: length of llof

(define (fastest llof)
  (cond
    [(empty? (rest llof)) (first llof)]
    [else (faster (first llof) (fastest (rest llof)))]))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; lof-departure : String String LOF -> LOF
;; GIVEN: Departing airport ap1, destination airport ap2, and a ListOfFlight
;; RETURNS: ListOfFlight that departs from ap1 and also can reach ap2
;;          using the given ListOfFlight.
;; EXAMPLE:
;; (lof-departure "MSP" "PDX" deltaFlights) = (list df2 df5)

;; STRATEGY: Combine simpler functions

(define (lof-departure ap1 ap2 lof)
  (list-of-departure-flight (lof-can-reach-des lof lof ap2) ap1))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; llof-departure : String String LOF -> LLOF
;; GIVEN: Departing airport ap1, destination airport ap2, and a ListOfFlight
;; RETURNS: ListOfListOfFlight that departs from ap1 and also can reach ap2
;;          using the given ListOfFlight.
;; EXAMPLE:
;; (llof-departure "MSP" "PDX" deltaFlights) = (list (list df2) (list df5))

;; STRATEGY: Combine simpler functions

(define (llof-departure ap1 ap2 lof)
  (lof-to-llof (lof-departure ap1 ap2 lof)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; short-route : String LOF -> LOF
;; GIVEN: destination airport ap2 and a ListOfFlight
;; WHERE: lof is a non-empty LOF
;; RETURNS: ListOfFlight that represent a route from a departure airport
;;          to ap2 without going to ap2 more than once.
;; EXAMPLE:
;; (short-route "BOS" (list f1 f2 f3 f18 f5 f6)) = (list f1 f2 f3)

;; STRATEGY: Use template of LOF on lof
;; HALTING MEASURE: length of lof

(define (short-route ap2 lof)
  (cond
    [(empty? (rest lof)) (cons (first lof) empty)]
    [(string=? ap2 (arrives (first lof)))
     (cons (first lof) empty)]
    [else (append (cons (first lof) empty)
                  (short-route ap2 (rest lof)))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; short-all-possible-route : String LLOF -> LLOF
;; GIVEN: destination airport ap2 and a ListOfListOfFlight
;; RETURNS: ListOfListOfFlight that has all possible routes (LOFs) from
;;          departing airport to ap2 without going to ap2 more than once.
;; EXAMPLE:
;; (short-all-possible-route "BOS" (list (list f1 f2 f3 f18 f5 f6)
;;                                       (list f1 f19 f8 f9 f20 f5 f7 f3 f18)))
;; = (list (list f1 f2 f3) (list f1 f19 f8 f9 f20 f5 f7 f3))

;; STRATEGY: Use HOF map on llof

(define (short-all-possible-route ap2 llof)
  (map
   ;; LOF -> LOF
   ;; RETURN: ListOfFlight that represent a route from a departure airport
   ;;          to ap2 without going back to any of the previously traveled
   ;;          airports.
   (lambda (lof) (short-route ap2 (reverse lof)))
   llof))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; can-reach-all-possible-route : String String LOF -> LLOF
;; GIVEN: Departing airport ap1, destination airport ap2, and a ListOfFlight
;; RETURNS: ListOfListOfFlight that has all possible routes (LOFs) from ap1
;;          to ap2.
;; EXAMPLE:
;; (can-reach-all-possible-route "MSP" "PDX" deltaFlights)
;;     = (list (list df4 df3 df2) (list df5))

;; STRATEGY: Combine simpler functions

(define (can-reach-all-possible-route ap1 ap2 lof)
  (short-all-possible-route
   ap2
   (all-possible-routes (llof-departure ap1 ap2 lof)
                        (lof-can-reach-des lof lof ap2))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; fastest-can-reach-route : String String LOF -> LOF
;; GIVEN: Departing airport ap1, destination airport ap2, and a ListOfFlight
;; RETURNS: ListOfFlight that is the fastest route from ap1 to ap2 with the
;;          Flights in reverse order.
;; EXAMPLE:
;; (fastest-can-reach-route "MSP" "PDX" deltaFlights) = (list df5)

;; STRATEGY: Combine simpler functions

(define (fastest-can-reach-route ap1 ap2 lof)
  (fastest (can-reach-all-possible-route ap1 ap2 lof)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FUNCTIONS:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; can-get-there? : String String ListOfFlight -> Boolean
;; GIVEN: the names of two airports, ap1 and ap2 (respectively), and a
;;        ListOfFlight that describes all of the flight a traveler is willing
;;        to consider taking.
;; RETURNS: true iff it is possible to fly from the first airport (ap1) to the
;;          second airport (ap2) using only the given flights.
;; EXAMPLES:
;; (can-get-there? "06N" "JFK" panAmFlights) = false
;; (can-get-there? "JFK" "JFK" panAmFlights) = true
;; (can-get-there? "06N" "LAX" deltaFlights) = false
;; (can-get-there? "LAX" "0fN" deltaFlights) = false
;; (can-get-there? "LGA" "PDX" deltaFlights) = true
;; STRATEGY: combine simpler functions

(define (can-get-there? ap1 ap2 lof)
  (cond
    [(string=? ap1 ap2) true]
    [else
     (in-itineraries? (flight-itineraries lof (departure-flights ap1 lof) empty)
                      ap2)]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; fastest-itinerary : String String ListOfFlight -> ListOfFlight
;; GIVEN: the names of two airports, ap1 and ap2 (respectively),
;;        and a ListOfFlight that describes all of the flights a
;;        traveller is willing to consider taking
;; WHERE: it is possible to fly from the first airport (ap1) to
;;        the second airport (ap2) using only the given flights
;; RETURNS: a list of flights that tells how to fly from the
;;          first airport (ap1) to the second airport (ap2) in the
;;          least possible time, using only the given flights
;; NOTE: to simplify the problem, your program should incorporate
;;       the totally unrealistic simplification that no layover
;;       time is necessary, so it is possible to arrive at 1500
;;       and leave immediately on a different flight that departs
;;       at 1500
;; EXAMPLES:
;;     (fastest-itinerary "JFK" "JFK" panAmFlights)  =>  empty
;;
;;     (fastest-itinerary "LGA" "PDX" deltaFlights)
;; =>  (list (make-flight "Delta 0121"
;;                        "LGA" "MSP"
;;                        (make-UTC 11 00) (make-UTC 14 09))
;;           (make-flight "Delta 2163"
;;                        "MSP" "PDX"
;;                        (make-UTC 15 00) (make-UTC 19 02)))
;; STRATEGY: combine simpler functions

(define (fastest-itinerary ap1 ap2 lof)
  (cond
    [(string=? ap1 ap2) empty]
    [else (fastest-can-reach-route ap1 ap2 lof)]))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; travel-time : String String ListOfFlight -> NonNegInt
;; GIVEN: the names of two airports, ap1 and ap2 (respectively),
;;     and a ListOfFlight that describes all of the flights a
;;     traveller is willing to consider taking
;; WHERE: it is possible to fly from the first airport (ap1) to
;;     the second airport (ap2) using only the given flights
;; RETURNS: the number of minutes it takes to fly from the first
;;     airport (ap1) to the second airport (ap2), including any
;;     layovers, by the fastest possible route that uses only
;;     the given flights
;; EXAMPLES:
;;     (travel-time "JFK" "JFK" panAmFlights)  =>  0
;;     (travel-time "LGA" "PDX" deltaFlights)  =>  482
;; STRATEGY: combine simpler functions

(define (travel-time ap1 ap2 lof)
  (cond
    [(string=? ap1 ap2) 0]
    [else
     (total-travel-time (fastest-itinerary ap1 ap2 lof))]))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TEST CASES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; Test for can-get-there?

(begin-for-test
  (check-equal?
   (can-get-there? "LGA" "BOS" (list f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12
                                     f13 f14 f16 f17 f18 f19 f20))
   true
   "Can reach to BOS from LGA with given list of flights")
  
  (check-equal?
   (can-get-there? "LGA" "PDX" (list f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12
                                     f13 f14 f16 f17 f18 f19 f20))
   false
   "Can not reach to PDX from LGA with given list of flights")
  
  (check-equal?
   (can-get-there? "LGA" "BOS" empty)
   false
   "Can not reach to BOS from LGA with given list of flights")
  
  (check-equal?
   (can-get-there? "LGA" "LGA" empty)
   true
   "Can reach to BOS from LGA with given list of flights")
  
  (check-equal?
   (can-get-there? "BOS" "DXB" (list f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12
                                     f13 f14 f16 f17))
   false
   "Can not reach to DXB from BOS with given list of flights")
  
  (check-equal?
   (can-get-there? "PDX" "BOS" (list f6 f13))
   true
   "Can reach to BOS from PDX with given list of flights"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; TEST for fastest-itinerary

(begin-for-test
  (check-equal?
   (fastest-itinerary "DXB" "BOS" (list f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12
                                        f13 f14 f16 f17 f18 f19 f20))
   (list f7 f3)
   "fastest itineary is (list f7 f3)")
  
  (check-equal?
   (fastest-itinerary "MSP" "BOS" (list f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12
                                        f13 f14 f16 f17 f18 f19 f20))
   (list f4)
   "two fastest itineary (list f4) (list f3 f2)")
  
  (check-equal?
   (fastest-itinerary "BOS" "BOS" (list f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12
                                        f13 f14 f16 f17 f18 f19 f20))
   empty
   "fastest itineary is not empty if source and destination are same")
  
  (check-equal?
   (fastest-itinerary "LGA" "BOS" (list f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12
                                        f13 f14 f16 f17 f18 f19 f20))
   (list f5 f6)
   "fastest itineary is (list f5 f6)"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; TEST for travel-time

(begin-for-test
  (check-equal?
   (travel-time "PDX" "DEL" (list f11 f12 f13 f9 f10 f14 f15 f16))
   849
   "travel time is 849")
  
  (check-equal?
   (travel-time "LGA" "LGA" (list f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12
                                  f13 f14 f16 f17))
   0
   "travel time is 0")
  
  (check-equal?
   (travel-time "MSP" "BOS" (list f2 f3 f4))
   495
   "travel time is 495"))