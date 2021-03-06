(define excercise12 (/ (+ 5 4 (- 2 (- 3 (+ 6 4/5)))) (* 3 (-  6 2) (- 2 7))))
(display "Excercise 1.2: ")
(display excercise12)
(newline)

;; Exercise 1.3
;; Define a procedure that takes three numbers
;; as arguments and returns the sum of the ssquares of the two larger numbers

;; NOTE: Lacking more advanced features, I just enumerate all possibilities (3! = 6)
(define (max2of3 a b c) (cond ((>= a b c) (cons a b))
                           ((>= a c b) (cons a c))   
                           ((>= b a c) (cons b a))
                           ((>= b c a) (cons b c))
                           ((>= c a b) (cons c a))
                           ((>= c b a) (cons c b))))
(define (square x) (* x x))

(define (excercise13 a b c) (+ (square (car (max2of3 a b c))) (square (cdr (max2of3 a b c)))))

;; Newton's Method. Chapter 1.1.7
;;
;; NOTE: Modified "good-enough?" is solution
;; to Excercise 1.7
(define (good-enough? guess x)
    (< (/ (abs (- x (square guess))) x)  0.001))


(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x) x)))

(define (average x y) 
  (/ (+ x y) 2))

(define (improve guess x) (average guess (/ x guess)))

;; Improve sqrt (via newtons method) until it is "good-enough?"
(define (sqrt x) (sqrt-iter 1 x))

;; Little utility program to run a certian number of iterations
(define (sqrt-n guess x n) (if (= n 0) guess
    (sqrt-n (improve guess x) x (- n 1))))

;; Exercise 1.8
;;
;; Implement a cbrt procedure using
;; the fact that a guess `y` can be improved:
;; (x/y^2+2y)/3
;;
;; I wanted to generalize this to arbitrary
;; roots *SOOO* bad, but I decided to wait
(define (cube x) (* x x x))

(define (good-enough-cbrt? guess x)
    (< (/ (abs (- x (cube guess))) x)  0.001))


(define (cbrt-iter guess x)
  (if (good-enough-cbrt? guess x)
      guess
      (cbrt-iter (improve-cbrt guess x) x)))

(define (improve-cbrt guess x) (/
  (+ (/ x (square guess)) (* 2 guess))
  3))

(define (cbrt x) (cbrt-iter 1 x))

;; Excercise 1.11
(define (f n) (if (< n 3) n
             (+ (f (- n 1)) (* 2 (f (- n 2))) (* 3 (f (- n 3))))))

(define (f-iter n)
  (define (iter a b c level) (if (= level n) a
    (iter (+ a (* 2 b) (* 3 c)) a b (+ level 1)))) ; compute next level
  (if (< n 3) n
      (iter 2 1 0 2)))

;; Excercise 1.12
(define (pascal-triangle-rec row column)
  (define row-size (+ row 1))
  (cond
    ((< column 0) 0) ; leftmost bound
    ((>= column row-size) 0) ; rightmost bound
    ((= row 0) 1) ; first row all ones
    ((= row 1) 1) ; second row all ones
    (else (+ (pascal-triangle-rec (- row 1) (- column 1)) (pascal-triangle-rec (- row 1) column)))))

(define (range start end) (if (< start end) (cons start (range (+ start 1) end)) '()))

(define (build-pascal-triangle row)
  (define row-size (+ row 1))
  (map (lambda (column) (pascal-triangle-rec row column)) (range 0 row-size)))

;; Excercise 1.16
;;
;; "Design an procedure that evolves an iterative expontetation
;;  process that uses successive squaring and uses a lograithmic number of steps"
;;
;; NOTE: I struggled with this for a while. Trying to write the algorithim in python first did *not* help. It only obscured the underlying problem.
;; The book was right, the key is the identity b^n = (b^2)^(n/2)
;; I was focusing on the state-transformation of the accumulator,
;; and trying to keep the base the same.
;; In fact, the key transformation which is the squring of the base 
;; which enables halving the current-pow.
;;
;; The accumulator is really just a side-show, needed only for the 'odd?' case.
;; The "hint" in the book obscures this fact, talking way more about
;; the accumulator and causing me to overthink it....
(define (fast-expt base power)
  (define (odd? num) (= 1 (remainder num 2)))
  (define (square x) (* x x))
  (define (expt-iter acc base current-pow) ; product = a * b^n
    (cond ((= current-pow 0) acc)
    ((odd? current-pow) (expt-iter (* acc base) base (- current-pow 1)))
    (else (expt-iter acc (square base) (/ current-pow 2)))))
  (expt-iter 1 base power))

(define (dbg n x)
  (display n)
  (display ": ")
  (display x)
  (display "\n")
  x)

;; Exercise 1.17 & 1.18
;;;
;; I jumped directly to the iterative process (skipping the recursive version)
(define (fast-* a b)
  (define (odd? num) (= 1 (remainder num 2)))
  (define (double x) (+ x x))
  (define (halve x) (/ x 2))
  (define (*-iter acc a b) ; product = acc + a * b
    (cond ((= b 0) acc)
          ((odd? b) (*-iter (+ acc a) a (- b 1)))
          (else (*-iter acc (double a) (halve b)))))
  (*-iter 0 a b))