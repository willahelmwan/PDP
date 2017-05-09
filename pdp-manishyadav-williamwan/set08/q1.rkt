;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Goal: Use the ADTs in the provided flight.rkt to define and provide functions
;;       can-get-there? , fastest-itinerary , and travel-time. can-get-there?
;;       checks to see if the flight can get from one airport to another
;;       airport. fastest-itinerary checks to see which flight route is the
;;       fastest to get from one airport to another airport. travel-time gives
;;       the fastest time go from one airport to another airport. No there are
;;       no non-trivial round trips. Make the program run in polynomial time.

(require rackunit)
(require "extras.rkt")
(require "flight.rkt")
(check-location "08" "q1.rkt")

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


;; A ListOfString (LOS) is one of
;; -- empty
;; -- (cons String LOS)
;; INTERPRETATION:
;; empty is a sequence of String with no elements
;; (cons s los) represents a sequence of LOS whose first element is s and
;;                 whose other elements are represented by los.

;; TEMPLATE:
;; los-fn : LOS -> ??
;; HALTING MEASURE: length of los
#;
(define (los-fn los)
  (cond
    [(empty? los) ...]
    [else (...
           (string-fn (first los))
           (los-fn (rest los)))]))


(define-struct node (flight weight parent))
;; A Node is a structure:
;; (make-node Flight NonNegReal LOF)
;; INTERPRETATION:
;; flight is a Flight of the Node
;; weight is a NonNegReal that represent the weight of the Node, the weight
;;    of the starting node is 0 and all the other nodes starts with +inf.0,
;;    the child node's weight later becomes the sum of the layover time between
;;    the Flight of the parent node and the Flight of the child node and the
;;    weight of the parent node. 
;; parent is a LOF that contains only one Flight that is the Flight of the
;;    Node's parent node.

;; TEMPLATE:
;; node-fn : Node -> ??
#;
(define (node-fn n)
  (... (node-flight n)
       (node-weight n)
       (node-parent n)))


;; A ListOfNode (LONODE) is one of
;; -- empty
;; -- (cons Node LONODE)
;; INTERPRETATION:
;; empty is a sequence of Node with no elements
;; (cons n lonode) represents a sequence of LONODE whose first element is n and
;;                 whose other elements are represented by lonode.

;; TEMPLATE:
;; lonode-fn : LONODE -> ??
;; HALTING MEASURE: length of lonode
#;
(define (lonode-fn lonode)
  (cond
    [(empty? lonode) ...]
    [else (...
           (node-fn (first lonode))
           (lonode-fn (rest lonode)))]))

;; END DATA DEFINITION


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; HELPER FUNCTIONS:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; arrival-flights : String LOF -> LOF
;; GIVEN: a name of arrivial airport and a ListOfFlights
;; RETURN: a LOF arrives to the same airport
;; EXAMPLE:
;; (arrival-flights "LGA" testLOF) =
;; (list f18 f19 f20)

;; STRATEGY: use HOF filter on lof

(define (arrival-flights des lof)
  (filter
   ;; Flight -> Boolean
   ;; RETURNS: true iff arrival airport of the Flight is same as des
   (lambda (f1) (string=? (arrives f1) des))
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; lof-reach-from-src : LOF LOF String -> LOF
;; GIVEN: a ListOfFlight lof1, a ListOfFlight lof2 and a src
;; RETURNS: a ListOfFlight that contains the Flights in lof1 that can be
;;          reached from src using lof2.
;; EXAMPLE:
;; (lof-reach-from-src (list f1 f2 f3 f4 f5 f6 f7) (list f1 f2) "DXB") =
;; (list f6 f7)

;; STRATEGY: Use HOF filter on lof1

(define (lof-reach-from-src lof1 lof2 src)
  (filter
   ;; Flight -> Boolean
   ;; RETURNS: true iff departure airport of the Flight can be reached
   ;;          from the source
   (lambda (f) (can-get-there? src (departs f) lof2))
   lof1))


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

;; faster : LOF LOF -> LOF
;; GIVEN: two ListOfFlights
;; WHERE: the two LOF are not empty
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

;; arrival-airports : ListOfFlight -> ListOfString
;; GIVEN: a ListOfFlight
;; RETURNS: a ListOfString made with each Flight's arriving airport in the
;;          given ListOfFlight
;; EXAMPLES:
;; (arrival-airports (list f1 f2)) = (list "MSP" "LHR")

;; STRATEGY: Use HOF map on lof

(define (arrival-airports lof)
  (map
   arrives
   lof))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; can-get? : LOS LOS String LOF -> Boolean
;; GIVEN: a LOS travelled-airports, a LOS current-airports, a String des,
;;        and ListOfFlight that describes all of the flight
;;        a traveler is willing to consider taking.
;; WHERE:
;;       travelled-airports is the LOS having airports reachable in fewer
;;       than n steps from some starting airport 'src', for some n
;;       current-airports is the LOS having airports reachable from 'src'
;;       in n steps but not in n-1 steps.
;; RETURNS: true iff des is reachable from current-airports using given lof.
;; EXAMPLES:
;; (can-get? empty (list "MSP") "LHR" testLOF) = true

;; STRATEGY: recur on next-current-airports
;; HALTING MEASURE: Length of current-airports

(define (can-get? travelled-airports current-airports des lof)
  (cond
    [(member des current-airports) true]
    [(empty? current-airports) false]
    [else
     (local
       ((define next-travelled-airports
          (append travelled-airports current-airports))
        (define next-current-airports 
          (list-diff (all-children-ap current-airports lof)
                     next-travelled-airports)))
       (can-get? next-travelled-airports next-current-airports des lof))]))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; children-ap : String LOF -> LOS
;; GIVEN: A String ap and ListOfFlight lof
;; RETURN: A LOS having children airports of given airport ap
;; WHERE: children airports are the airports which are reachable from given
;;        airport using the given lof
;; EXAMPLE:
;; (children-ap "MSP" testLOF) = (list "LHR" "BOS" "LGA")

;; STRATEGY: Combine simpler functions

(define (children-ap ap lof)
  (arrival-airports (departure-flights ap lof)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; all-children-ap : LOS LOF -> LOS
;; GIVEN: A LOS having parent airports and ListOfFlight
;; RETURN: LOS represents the children of all airports of given LOS
;; WHERE: children airports are the airports which are reachable from parent
;;        airport using the given lof
;; EXAMPLE:
;; (all-children-ap (list "MSP" "LHR") testLOF) = (list "LHR" "BOS" "LGA")
;; (all-children-ap (list "LGA") testLOF) = (list "MSP" "DXB" "DTW")

;; STRATEGY: use HOF foldr on lo-ap

(define (all-children-ap lo-ap lof)
  (foldr
   ;; String LOS -> LOS
   ;; RETURN: LOS having union of given LOS s and children-ap of ap
   ;; WHERE: children airports are the airports which are reachable from
   ;;        airport ap using the given lof
   (lambda (ap s)
     (list-union
      (children-ap ap lof)
      s))
   empty
   lo-ap))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; list-cons : String LOS -> LOS
;; GIVEN: a String and ListOfString
;; RETURN: a ListOfString having str added to list1, if it is not a member of
;; list1 otherwise list1
;; EXAMPLE:
;; (list-cons "MSP" (list "MSP" "LHR")) = (list "MSP" "LHR")
;; (list-cons "MSP" (list "LHR")) = (list "MSP" "LHR")

;; STRATEGY: Combine simpler functions

(define (list-cons str list1)
  (if (member str list1)
      list1
      (cons str list1)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; list-union : LOS LOS -> LOS
;; GIVEN: two ListOfString
;; RETURN: ListOfString having union of the two given ListOfString
;; EXAMPLE:
;; (list-union (list "MSP" "LHR") (list "MSP")) = (list "LHR" "MSP")
;; (list-union (list "LHR") (list "MSP")) = (list "LHR" "MSP")

;; STRATEGY: use HOF foldr on list1

(define (list-union list1 list2)
  (foldr
   list-cons
   list2
   list1))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; list-diff : LOS LOS -> LOS
;; GIVEN: two ListOfString
;; RETURN: ListofString having all elements of list2 removed from list1
;; EXAMPLE:
;; (list-diff (list "MSP" "LHR") (list "MSP")) = (list "LHR")

;; STRATEGY: use HOF filter on list1

(define (list-diff list1 list2)
  (filter
   ;; String -> Boolean
   ;; RETURNS: true iff str is not a member of list2
   (lambda (str) (not (member str list2)))
   list1))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; start-node : Flight -> Node
;; GIVEN: a Flight
;; RETURNS: a Node made with the Flight, which has weight of 0, and parent
;;          as empty.
;; EXAMPLE:
;; (start-node f1) =  (make-node f1 0 '())

;; STRATEGY: Combine simpler functions

(define (start-node f)
  (make-node f 0 empty))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; initial-node : Flight -> Node
;; GIVEN: a Flight
;; RETURNS: a Node made with the Flight, which has weight of +inf.0,
;;          and parent as empty.
;; EXAMPLE:
;; (initial-node f1) = (make-node f1 #i+inf.0 '())

;; STRATEGY: Combine simpler functions

(define (initial-node f)
  (make-node f +inf.0 empty))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; initialization : LOF Flight -> LONODE
;; GIVEN: a LOF and a Flight
;; RETURNS: a LONODE with each of the Flight made in to an Node with
;;          initial-node function except the given flight, which is made into
;;          a Node with start-node function.
;; EXAMPLE:
;; (initialization (list f1 f2 f3) f1) =
;; (list
;;   (make-node f1 0 '())
;;   (make-node f2 #i+inf.0 '())
;;   (make-node f3 #i+inf.0 '())

;; STRATEGY: Use HOF map on lof

(define (initialization lof f)
  (map
   ;; Flight -> Node
   ;; RETURNS: a Node made with start-node if f1 equals to f or a Node made
   ;;          with initial-node if f1 does not equal to f.
   (lambda (f1) (if (equal? f f1) (start-node f1) (initial-node f1)))
   lof))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; path-weight : Node Node -> NonNegReal
;; GIVEN: a Node n1 and a Node n2
;; RETURNS: the sum of the layover time between the flight of n1 and the
;;          flight of n2 and the travel time of the flight of n2. 
;; EXAMPLE:
;; (path-weight (make-node f1 0 '()) (make-node f2 #i+inf.0 '())) = 1500

;; STRATEGY: Use template for Node on n1 and n2

(define (path-weight n1 n2)
  (+ (layover-duration (node-flight n1) (node-flight n2))
     (flight-duration (node-flight n2))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; smaller-weight : Node Node -> Node
;; GIVEN: two Nodes
;; RETURNS: the Node with smaller weight
;; EXAMPLE:
;; (smaller-weight (make-node f1 200 empty) (make-node f2 30 empty))
;;    = (make-node f2 30 empty)

;; STRATEGY: Use template for Node on n1 and n2

(define (smaller-weight n1 n2)
  (if (< (node-weight n1) (node-weight n2)) n1 n2))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; smallest-weight : LONODE -> Node
;; GIVEN: a LONODE
;; WHERE: the LONODE is not empty
;; RETURNS: a Node with the smallest weight
;; EXAMPLES:
;; (smallest-weight
;;   (list (make-node f1 2 '()) (make-node f2 3 '()) (make-node f3 0 '()))) =
;;   (make-node f3 0 '())

;; STRATEGY: Use template of LONODE on lonode
;; HALTING MEASURE: length of lonode

(define (smallest-weight lonode)
  (cond
    [(empty? (rest lonode)) (first lonode)]
    [else (smaller-weight (first lonode) (smallest-weight (rest lonode)))]))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; new-node-weight : Node Node -> NonNegReal
;; GIVEN: a Node n1 and a Node n2
;; RETURNS: the sum of the path-weight between n1 and n2 and the weight of n1.
;; EXAMPLES:
;; (new-node-weight (make-node f1 2 '()) (make-node f2 3 '())) = 1502

;; STRATEGY: Use template for Node on n1 and n2

(define (new-node-weight n1 n2)
  (+ (path-weight n1 n2) (node-weight n1)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; remove-node : Flight LONODE -> LONODE
;; GIVEN: a Flight and a LONODE
;; RETURNS: a LONODE with the node that contains the given Flight removed.
;; EXAMPLES:
;; (remove-node
;;   f1
;;   (list (make-node f1 2 '()) (make-node f2 3 '()) (make-node f3 0 '()))) =
;;   (list (make-node f2 3 '()) (make-node f3 0 '()))

;; STRATEGY: Use HOF filter on lonode

(define (remove-node f lonode)
  (filter
   ;; Node -> Boolean
   ;; RETURNS: true iff the Node's flight is not f
   (lambda (n) (not (equal? f (node-flight n))))
   lonode))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; children-nodes : Node LONODE -> LONODE
;; GIVEN: a Node and a LONODE
;; RETURNS: a List of Nodes that are the children on the given Node.
;; EXAMPLES:
;; (children-nodes (make-node f1 2 '())
;;      (list (make-node f1 2 '()) (make-node f2 3 '()) (make-node f3 0 '()))) =
;;      (list (make-node f2 3 '()))

;; STRATEGY: Use HOF filter on lonode

(define (children-nodes n lonode)
  (filter
   ;; Node -> Boolean
   ;; RETURNS: true iff the departure airport of the flight of the Node is
   ;;          the same as the arrival airport of flight of n.
   (lambda (n1) (string=? (departs (node-flight n1))
                          (arrives (node-flight n))))
   lonode))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; update-node : Node NonNegReal Flight -> Node
;; GIVEN: a Node, a weight, and a Flight
;; RETURNS: a new Node with the node-parent replaced with the list of the given
;;          Flight and the node-weight replaced with the weight iff the weight
;;          is less than the node-weight of the given Node.
;; EXAMPLES:
;; (update-node (make-node f1 2 '()) 1 f3) = (make-node f1 1 (list f3))   

;; STRATEGy: Use template for Node on n

(define (update-node n weight f)
  (if (< weight (node-weight n))
      (make-node (node-flight n) weight (cons f empty))
      n))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; update-lonode-weight-parent : LONODE Node Flight -> LONODE
;; GIVEN: a LONODE, a Node, and a Flight
;; RETURNS: a new LONODE with each Node in the list updated with the new node
;;          weight computed from the given Node and each Node in the list and
;;          with each Node in the list updated with the list of the given
;;          Flight as node-parent iff the computed weight is less than the
;;          current node-weight of each Node.
;; EXAMPLES:
;; (update-lonode-weight-parent
;;  (list (make-node f2 3000 '()) (make-node f3 0 '()))
;;  (make-node f1 2 '())
;;  f4) =
;;  (list (make-node f2 1502 (list f4)) (make-node f3 0 '()))

;; STRATEGY: Use HOF map on lonode

(define (update-lonode-weight-parent lonode n f)
  (map
   ;; Node -> Node
   ;; RETURNS:  a new Node with the node-parent replaced with the list of the
   ;;           given Flight and the node-weight replaced with the weight iff
   ;;           the weight is less than the node-weight of the given Node.
   (lambda (n1) (update-node n1 (new-node-weight n n1) f))
   lonode))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; update-lonode : Node LONODE -> LONODE
;; GIVEN: A LONODE and a Node
;; RETURNS: a new LONODE with given Node replaced the Node with the same
;;          node-flight
;; EXAMPLES:
;; (update-lonode
;;   (make-node f1 1000 '())
;;   (list (make-node f1 2 '()) (make-node f2 3 '()) (make-node f3 0 '()))) =
;;   (list (make-node f1 1000 '()) (make-node f2 3 '()) (make-node f3 0 '()))

;; STRATEGY: Combine simpler functions.

(define (update-lonode n lonode)
  (cons n (remove-node (node-flight n) lonode)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; update-lonodes : LONODE LONODE -> LONODE
;; GIVEN: a LONODE lonode1 and a LONODE lonode2
;; RETURNS: a new LONODE with all Nodes in lonode1 with the same flight as the
;;          Nodes in lonode2 replaced with the Nodes in lonode2.
;; EXAMPLES:
;; (update-lonodes
;;  (list (make-node f1 2 '()) (make-node f2 3 '()) (make-node f3 0 '()))
;;  (list (make-node f1 1000 '()) (make-node f2 20 '()))) =
;; (list (make-node f1 1000 '()) (make-node f2 20 '()) (make-node f3 0 '()))

;; STRATEGY: Use HOF foldr on lonode2

(define (update-lonodes lonode1 lonode2)
  (foldr
   update-lonode
   lonode1
   lonode2))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; fastest-nodes : LONODE LONODE -> LONODE
;; GIVEN: a LONODE lonode1 and a LONODE lonode2
;; WHERE: lonode1 is LONODE that keeps track of all the processed Nodes,
;;        lonode2 has the Nodes that have not been processed.
;; RETURNS: a LONODE that contains all Node from lonode2, but now each Node has
;;          a weight that represent the fastest time from the start-node and
;;          also has a node-parent. 
;; EXAMPLE:
;; (define lon (initialization (list f1 f2 f3) f1))
;; (fastest-nodes empty lon) = (list (make-node f3 1926 (list f2)
;;                                   (make-node f2 1500 (list f1)
;;                                   (make-node f1 0 '()))

;; STRATEGY: Recur on next-lonode2
;; HALTING MEASURE: Length of lonodes2

(define (fastest-nodes lonode1 lonode2)
  (cond
    [(empty? lonode2) lonode1]
    [else
     (local
       ((define next-lonode1
          (cons (smallest-weight lonode2) lonode1))
        (define next-lonode2 
          (remove-node
           (node-flight (smallest-weight lonode2))
           (update-lonodes
            lonode2
            (update-lonode-weight-parent
             (children-nodes (smallest-weight lonode2) lonode2)
             (smallest-weight lonode2)
             (node-flight (smallest-weight lonode2)))))))
       (fastest-nodes next-lonode1 next-lonode2))]))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; find-node : LONODE LOF -> Node
;; GIVEN: a LONODE and a LOF
;; WHERE: the LOF only contains one Flight
;; RETURNS: the Node whose node-flight is the same as the Flight in the given
;;          LOF
;; EXAMPLES:
;; (define lon (initialization (list f1 f2 f3) f1))
;; (find-node lon (list f1)) = (make-node f1 0 '())

;; STRATEGY: Use HOF filter on lonode

(define (find-node lonode lof)
  (first
   (filter
    ;; Node -> Boolean
    ;; RETURNS: true iff the node-flight of the Node is the same as the Flight
    ;;          in the given LOF.
    (lambda (n) (equal? (node-flight n) (first lof)))
    lonode)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; fastest-path : LONODE LOF -> LOF
;; GIVEN: a LONODE computed from fastest-nodes and a LOF
;; WHERE: the given LOF only contains one Flight
;; RETURNS: a LOF that represent the fastest to get from the Flight of the
;;          start-node of the LONODE to the Flight in the given LOF.
;; EXAMPLES:
;; (define lon (initialization (list f1 f2 f3) f1))
;; (define lonn (fastest-nodes empty lon))
;; (fastest-path lonn (list f3)) = (list f1 f2 f3)

;; STRATEGY: reur on (node-parent (find-node lonode lof))
;; HALTING MEASURE: the length of lof

(define (fastest-path lonode lof)
  (cond
    [(empty? lof) empty]
    [else
     (append
      (fastest-path lonode (node-parent (find-node lonode lof)))
      lof)]))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; filter-fastest-route : LLOF LOF -> LLOF
;; GIVEN: a LLOF llof and a LOF lof
;; RETURNS: a LLOF with all LOFs whose first Flight's departure airport
;;          is the same as the departure airport of first Flight of lof
;; EXAMPLES:
;; (filter-fastest-route (list (list f1) (list f2)) (list f1))
;;   = (list (list f1))

;; STRATEGY: Use HOF filter on llof

(define (filter-fastest-route llof lof)
  (filter
   ;; LOF -> Boolean
   ;; RETURNS: true iff the departure airport of the first Flight of lof1 is
   ;;          the same as the departure airport of the first Flight of lof.
   (lambda (lof1) (equal? (departs (first lof1)) (departs (first lof))))
   llof))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; fastest-route-arrival : LOF LOF Flight -> LOF
;; GIVEN: a LOF lof1, a ListOfFlight lof2, and a Flight f
;; RETURNS: a LOF that represent the fastest route from a Flight in lof2 to
;;          f.
;; EXAMPLES:
;; (fastest-route-arrival testLOF (list f1) f10) =
;;   (list f1 f19 f8 f10)

;; STRATEGY: Use HOF map on lof2

(define (fastest-route-arrival lof1 lof2 f)
  (fastest
   (filter-fastest-route
    (map
     ;; Flight -> LOF
     ;; RETURNS: a LOF that represent the fastest to get from f1 to f. 
     (lambda (f1) (fastest-path
                   (fastest-nodes empty (initialization lof1 f1))
                   (cons f empty)))
     lof2)
    lof2)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; fastest-route : LOF LOF LOF -> LOF
;; GIVEN: a LOF lof, a LOF lof1, and a LOF lof2
;; RETURNS: a LOF that represent the fastest route using any Flight in lof1 to
;;          reach any Flight in lof2.
;; EXAMPLES:
;; (fastest-route testLOF (list f1) (list f10 f17)) =
;;   (list f1 f4 f17)

;; STRATEGY: Use HOF map on lof2

(define (fastest-route lof lof1 lof2)
  (fastest
   (map
    ;; Flight -> LOF
    ;; RETURNS: a LOF that represent the fastest route from a Flight in lof1 to
    ;;          f1. 
    (lambda (f1) (fastest-route-arrival lof lof1 f1))
    lof2)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; filtered-lof : String String LOF -> LOF
;; GIVEN: a source ap1, a destination ap2, and a LOF lof
;; RETURNS: a LOF that contains all flights whose departure airport can be
;;          reached from ap1 and arrival airport can reach ap2.
;; EXAMPLE:
;; (filtered-lof "LGA" "DEL" testLOF) =
;;    (list f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f17 f18 f19 f20)

;; STRATEGY: Combine simpler functions. 

(define (filtered-lof ap1 ap2 lof)
  (lof-reach-from-src (lof-can-reach-des lof lof ap2)
                      (lof-can-reach-des lof lof ap2)
                      ap1))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FUNCTIONS:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; can-get-there? : String String ListOfFlight -> Boolean
;; GIVEN: the names of two airports, src and des (respectively), and a
;;        ListOfFlight that describes all of the flight a traveler is willing
;;        to consider taking.
;; RETURNS: true iff it is possible to fly from the first airport (src) to the
;;          second airport (des) using only the given flights.
;; EXAMPLES:
;; (can-get-there? "06N" "JFK" panAmFlights) = false
;; (can-get-there? "JFK" "JFK" panAmFlights) = true
;; (can-get-there? "06N" "LAX" deltaFlights) = false
;; (can-get-there? "LAX" "0fN" deltaFlights) = false
;; (can-get-there? "LGA" "PDX" deltaFlights) = true
;; STRATEGY: combine simpler functions

(define (can-get-there? src des lof)
  (can-get? empty (list src) des lof))


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
    [else
     (fastest-route (filtered-lof ap1 ap2 lof)
                    (departure-flights ap1 (filtered-lof ap1 ap2 lof))
                    (arrival-flights ap2 (filtered-lof ap1 ap2 lof)))]))
      

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


;; Citation: "Greedy Algorithms | Set 7 (Dijkstra’s shortest path algorithm),"
;;           GeeksforGeeks, http://www.geeksforgeeks.org/greedy-algorithms-
;;           et-6-dijkstras-shortest-path-algorithm/
