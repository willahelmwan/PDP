;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Goal: create the function edit. The function consumes two inputs, an editor
;; ed and a KeyEvent ke, and it produces another editor. 

(require rackunit)
(require 2htdp/universe)    ; needed for key=?
(require "extras.rkt")

(check-location "02" "q1.rkt")

(provide
  make-editor
  editor-pre
  editor-post
  editor?
  edit)

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
  (cond
    [(> (string-length str) 0) (string-ith str (- (string-length str) 1))]
    [else ""]))

;; DATA DEFINITION: none.

;; string-first: NonEmptyStr -> 1String
;; GIVEN: a non-empty string
;; RETURNS: the first 1String
;; EXAMPLES:
;; (string-first "hello") = "h"
;; (string-first " hi") = " "
;; (string-first "\thello hi ") = "\t"
;; (string-first " ") = " "
;; STRATEGY: combine simpler functions

(define (string-first str)
  (cond
    [(> (string-length str) 0) (string-ith str 0)]
    [else ""]))

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

;; DATA DEFINITION: none.

;; string-rest: Str -> Str
;; GIVEN: a string str
;; RETURNS: a string with the first character removed from the original string
;; EXAMPLES:
;; (string-remove-last "hello!") = "ello!"
;; (string-remove-last " hi") = "hi"
;; (string-remove-last "\thello hi ") = "hello hi "
;; (string-remove-last " ") = ""
;; (string-remove-last "") = ""
;; STRATEGY: combine simpler functions

(define (string-rest str)
 (cond
   [(= (string-length str) 0) ""]
   [(> (string-length str) 0) (substring str 1 (string-length str))]))


(define-struct editor [pre post])

;; DATA DEFINITION:
;; An Editor is a structure:
;;  (make-editor String String)
;; INTERPRETATION: (make-editor s t) describes an editor whose visible text is
;; (string-append s t) with the cursor displayed between s and t

;; TEMPLATE
;; editor-fn : Editor -> ??
#;
(define (editor-fn ed)
  (...
    (editor-pre ed)
    (editor-post ed)))

(define ed1 (make-editor "Hello" "World")) ; example editor #1.
(define ed2 (make-editor "" "World")) ; example editor #2.
(define ed3 (make-editor "Hello" "")) ; example editor #3.
(define ed4 (make-editor "" "")); example editor #4.
(define ed5 (make-editor "a" "b")); example editor #5.

;; edit: Editor KeyEvent -> Editor
;; Given: an editor ed and a KeyEvent ke.
;; RETURNS: another editor.
;; EXAMPLES:
;; (edit ed1 " ") = (make-editor "Hello " "World")
;; (edit ed1 "\b") = (make-editor "Hell" "World")
;; (edit ed1 "\t") = (make-editor "Hello" "World")
;; (edit ed1 "\r") = (make-editor "Hello" "World")
;; (edit ed1 "left") = (make-editor "Hell" "oWorld")
;; (edit ed1 "right") = (make-editor "HelloW" "orld")
;; (edit ed1 "down") = (make-editor "Hello" "World")
;; (edit ed1 "\\") = (make-editor "Hello\\" "World")
;; (edit ed1 "o") = (make-editor "Helloo" "World")
;; (edit ed1 "\u007F" = (make-editor "Hello" "World")
;; (edit ed2 "a") = (make-editor "a" "World")
;; (edit ed2 "\b") = (make-editor "" "World")
;; (edit ed2 "left") = (make-editor "" "World")
;; (edit ed3 "right") = (make-editor "Hello" "")
;; (edit ed4 "a") = (make-editor "a" "")
;; (edit ed4 "left") = (make-editor "" "")
;; (edit ed4 "right") = (make-editor "" "")
;; (edit ed4 "\b") = (make-editor "" "")
;; STRATEGY: use template for Editor on ed.

(define (edit ed ke)
  (cond
    [(= (string-length ke) 1)
     (cond
       [(key=? ke "\b") (make-editor (string-remove-last (editor-pre ed)) (editor-post ed))]
       [(key=? ke "\t") ed]
       [(key=? ke "\r") ed]
       [(key=? ke "\u007F") ed]
       [else (make-editor (string-append (editor-pre ed) ke) (editor-post ed))])]
    [else
     (cond
       [(key=? ke "left") (make-editor (string-remove-last (editor-pre ed))
        (string-append (string-last (editor-pre ed)) (editor-post ed)))]
       [(key=? ke "right") (make-editor (string-append (editor-pre ed)
        (string-first (editor-post ed))) (string-rest (editor-post ed)))]
       [else ed])]))

(begin-for-test
  (check-equal? (edit ed1 " ") (make-editor "Hello " "World")
                "the the Editor after input ed1 and ' ' should be (make-editor 'Hello ' 'World').")
  (check-equal? (edit ed1 "\b") (make-editor "Hell" "World")
                "the the Editor after input ed1 and '\b ' should be (make-editor 'Hell' 'World').")
  (check-equal? (edit ed1 "\t") (make-editor "Hello" "World")
                "the the Editor after input ed1 and '\t' should be (make-editor 'Hello' 'World').")
  (check-equal? (edit ed1 "\r") (make-editor "Hello" "World")
                "the the Editor after input ed1 and '\r' should be (make-editor 'Hello' 'World').")
  (check-equal? (edit ed1 "left") (make-editor "Hell" "oWorld")
                "the the Editor after input ed1 and 'left' should be (make-editor 'Hell' 'oWorld').")
  (check-equal? (edit ed1 "right") (make-editor "HelloW" "orld")
                "the the Editor after input ed1 and 'right' should be (make-editor 'HelloW' 'orld').")
  (check-equal? (edit ed1 "down") (make-editor "Hello" "World")
                "the the Editor after input ed1 and 'down' should be (make-editor 'Hello' 'World').")
  (check-equal? (edit ed1 "\\") (make-editor "Hello\\" "World")
                "the the Editor after input ed1 and '\\' should be (make-editor 'Hello\\' 'World').")
  (check-equal? (edit ed1 "o") (make-editor "Helloo" "World")
                "the the Editor after input ed1 and 'o' should be (make-editor 'Helloo' 'World').")
  (check-equal? (edit ed1 "\u007F") (make-editor "Hello" "World")
                "the the Editor after input ed1 and '\u007F' should be (make-editor 'Hello' 'World').")
  (check-equal? (edit ed2 "a") (make-editor "a" "World")
                "the the Editor after input ed2 and 'a' should be (make-editor 'a' 'World').")
  (check-equal? (edit ed2 "\b") (make-editor "" "World")
                "the the Editor after input ed2 and '\b' should be (make-editor '' 'World').")
  (check-equal? (edit ed2 "left") (make-editor "" "World")
                "the the Editor after input ed2 and 'left' should be (make-editor '' 'World').")
  (check-equal? (edit ed3 "right") (make-editor "Hello" "")
                "the the Editor after input ed3 and 'right' should be (make-editor 'Hello' '').")
  (check-equal? (edit ed4 "a") (make-editor "a" "")
                "the the Editor after input ed4 and 'a' should be (make-editor 'a' '').")
  (check-equal? (edit ed4 "left") (make-editor "" "")
                "the the Editor after input ed4 and 'left' should be (make-editor '' '').")
  (check-equal? (edit ed4 "right") (make-editor "" "")
                "the the Editor after input ed4 and 'right' should be (make-editor '' '').")
  (check-equal? (edit ed4 "\b") (make-editor "" "")
                "the the Editor after input ed4 and '\b' should be (make-editor '' '').")
  (check-equal? (edit ed5 "\b") (make-editor "" "b")
                "the the Editor after input ed5 and '\b' should be (make-editor '' 'b').")
  (check-equal? (edit ed5 "left") (make-editor "" "ab")
                "the the Editor after input ed5 and 'left' should be (make-editor '' 'ab').")
  (check-equal? (edit ed5 "right") (make-editor "ab" "")
                "the the Editor after input ed5 and 'right' should be (make-editor 'ab' '')."))
