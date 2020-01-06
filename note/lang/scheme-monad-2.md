# a schemer's view of monads

---

> A Schemer’s View of Monads
> Partial Draft
> Adam C. Foltzer & Daniel P. Friedman
> December 2, 2011

看文件下载地址，应该是 indiana c311 的内容
有 Daniel Friedman 的名字挂在那里
硬着头皮试一下，看能不能搞懂 monad

---

## lecture 1: state monad

---

### identity monad

---

介绍了一下 begin 和 let
怎么用 lambda 实现这个两个语义

```scheme
(begin
 (display "one")
 (display "two"))

(define my-begin (lambda (x f) (f x)))
(my-begin
  (display "one")
  (lambda (_) (display "two")))
```

```scheme
(let ([x 5]) (+ x 3))

(define my-let (lambda (x f) (f x)))
(my-let
  5
  (lambda (x) (+ x 3)))
```

---

前面的转写可以看到，my-begin 和 my-let 完全一样
提取一下，就有了一个最简单的 monad，identity monad

```scheme
(define bind-identity
  (lambda (Ma sequel)
    (sequel Ma))) ;; ==> Mb

(define unit-identity
  (lambda (a) a))
```

用 bind 和 unit 来写前面的 begin/let
看起来会是这样

```scheme
;; begin
(bind-identity
  (unit-identity (display "one"))
  (lambda (_) (unit-identity (display "two"))))

;; let
(bind-identity
  (unit-identity 5)
  (lambda (x) (unit-identity (+ x 3))))
```

关于这个 unit，不知道怎么解释

> unit-M is a function that brings a value into the world of a monad M

> bringing scheme values into the identity monad with unit-identity

---

单单只有这个 identity monad，确实没什么用，反而把 begin/let 变得更复杂了

关键在于，提供一种机制，能够修改执行顺序
作者引用 real world haskell 的说法，称之为 programmable semicolon

> provide a hook into how we evaluate expressions in sequence
> bind-M is a programmable semicolon

具体到 bind-identity
编码了一种最基础的顺序逻辑，“先做这个，再做那个”

---

### state monad

---

- 看得有点懵 😂
- 要习惯递归才能看得懂 scheme……
- scheme 的 macro 好厉害……
- 作者
	- 给了直接实现，cps 实现，sps 实现，state 实现多种例子
	- 用 trace 演示了 cps 和 state 过程的区别

- `bindM` 控制流程
- `unitM` 将值转换到 monad

---

> the state monad provides us with the illusion of a mutable global variable.
> we get the usual benefits of effectful computation without the usual drawbacks.

状态在函数间传递，起到的作用其实类似于一个全局变量
但这个状态的修改，本身是有序的

---

```scheme
(define remberevensXcountevens-2pass
  (lambda (l)
    (cons (remberevens-direct l) (countevens-direct l))))

(define remberevens-direct
  (lambda (l)
    (cond [(null? l) '()]
          [(pair? (car l)) (cons (remberevens-direct (car l)) (remberevens-direct (cdr l)))]
          [(or (null? (car l)) (odd? (car l))) (cons (car l) (remberevens-direct (cdr l)))]
          [else (remberevens-direct (cdr l))])))

(define countevens-direct
  (lambda (l)
    (cond [(null? l) 0]
          [(pair? (car l)) (+ (remberevens-direct (car l)) (remberevens-direct (cdr l)))]
          [(or (null? (car l)) (odd? (car l))) (remberevens-direct (cdr l))]
          [else (+ 1 (remberevens-direct (cdr l)))])))

(remberevensXcountevens-2pass '(2 3 (7 4 5 6) 8 (9) 2))
```

```scheme
(define remberevensXcountevens-cps
  (lambda (l k)
    (cond [(null? l) (k (cons '() 0))]
          [(pair? (car l))
           (remberevensXcountevens-cps
             (car l)
             (lambda (pa)
               (remberevensXcountevens-cps
                 (cdr l)
                 (lambda (pd)
                   (k (cons
                        (cons (car pa) (car pd))
                        (+ (cdr pa) (cdr pd))))))))]
          [(or (null? (car l)) (odd? (car l)))
           (remberevensXcountevens-cps
             (car l)
             (lambda (p)
               (k (cons (cons (car l) (car p)) (cdr p)))))]
          [else (remberevensXcountevens-cps
                  (cdr l)
                  (lambda (p)
                    (k (cons (car p) (+ 1 (cdr p))))))])))

(remberevensXcountevens-cps '(2 3 (7 4 5 6) 8 (9) 2) (lambda (p) p))
```

```scheme
(define unit-state
  (lambda (a)
    (lambda (s)
      (cons a s))))

(define bind-state
  (lambda (ma sequel)
    (lambda (s)
      (let ([p (ma s)])
        (let ([aa (car p)] [ss (cdr p)])
          (let ([mb (sequel aa)])
            (mb ss)))))))

(define remberevensXcountevens
  (lambda (l)
    (cond [(null? l) (unit-state '())]
          [(pair? (car l))
           (bind-state
             (remberevensXcountevens (car l))
             (lambda (a)
               (bind-state
                 (remberevensXcountevens (cdr l))
                 (lambda (d) (unit-state (cons a d))))))]
          [(or (null? (car l)) (odd? (car l)))
           (bind-state
             (remberevensXcountevens (cdr l))
             (lambda (d) (unit-state (cons (car l) d))))]
          [else
            (bind-state
              (lambda (s) (cons '_ (+ 1 s)))
              (lambda (_) (remberevensXcountevens (cdr l))))])))

((remberevensXcountevens '(2 3 (7 4 5 6) 8 (9) 2)) 0)
```

```scheme
(define remberevensXcountevens-sps
  (lambda (l s)
    (cond [(null? l) (cons '() s)]
          [(pair? (car l))
           (let ([p (remberevensXcountevens-sps (car l) s)])
             (let ([pp (remberevensXcountevens-sps (cdr l) (cdr p))])
               (cons (cons (car p) (car pp)) (cdr pp))))]
          [(or (null? (car l)) (odd? (car l)))
           (let ([p (remberevensXcountevens-sps (cdr l) s)])
             (cons (cons (car l) (car p)) (cdr p)))]
          [else
            (let ([p (remberevensXcountevens-sps (cdr l) s)])
              (cons (car p) (+ 1 (cdr p))))])))

(remberevensXcountevens-sps '(2 3 (7 4 5 6) 8 (9) 2) 0)
```

---

## lecture 2: other monads

---

### monad laws

---

> each monad is a pair of functions, `unitM` and `bindM`

- (bindM m unitM) = m
- (bindM (unitM x) f) = (f x)
- (bindM (bindM m f) g) = (bindM m (lambda (x) (bindM (f x) g)))

---

### types and shapes

---

```
unitM: a -> ma
bindM: ma -> (a -> mb) -> mb
sequelM = a -> mb
```

---

### maybe monad

```scheme
(define unit-maybe
  (lambda (a)
    (cons 'Just a)))

(define bind-maybe
  (lambda (ma sequel)
    (cond [(eq? (car ma) 'Just)
           (let ([a (cadr ma)]) (sequel a))]
          [else ma])))
```

---

### continuation monad

```scheme
(define unit-cont
  (lambda (a)
    (lambda (k)
      (k a))))

(define bind-cont
  (lambda (ma sequel)
    (lambda (k)
      (let ([kk (lambda (a)
                  (let ([mb (sequel a)])
                    (mb k)))])
        (ma kk)))))
```

```scheme
(define remberevensXcountevens
  (lambda (l)
    (cond [(null? l) (unit-cont (cons '() 0))]
          [(pair? (car l))
           (bind-cont
             (remberevensXcountevens (car l))
             (lambda (pa)
               (bind-cont
                 (remberevensXcountevens (cdr l))
                 (lambda (pd)
                   (unit-cont (cons (cons (car pa) (car pd)) (+ (cdr pa) (cdr pd))))))))]
          [(or (null? (car l)) (odd? (car l)))
           (bind-cont
             (remberevensXcountevens (cdr l))
             (lambda (p)
               (unit-cont (cons (cons (car l) (car p)) (cdr p)))))]
          [else (bind-cont
                  (remberevensXcountevens (cdr l))
                  (lambda (p)
                    (unit-cont (cons (car p) (+ 1 (cdr p))))))])))

((remberevensXcountevens '(2 3 (7 4 5 6) 8 (9) 2)) (lambda (p) p))
```

---

### exception monad

```scheme
(define unit-exception
  (lambda (a)
    (cons 'Success a)))

(define bind-exception
  (lambda (ma sequel)
    (cond [(eq? (car ma) 'Success)
           (let ([a (cadr ma)]) (sequel a))]
          [else ma])))
```

---

### writer monad

```scheme
(define unit-writer
  (lambda (a)
    (cons a '())))

(define bind-writer
  (lambda (ma sequel)
    (let ([a (car ma)])
      (let ([mb (sequel a)])
        (let ([b (car mb)])
          (cons b (append (cdr ma) (cdr mb))))))))
```

---

### reader monad

```scheme
(define unit-reader
  (lambda (a)
    (lambda (v)
      a)))
(define bind-reader
  (lambda (ma sequel)
    (lambda (v)
      (let ([a (ma v)])
        (let ([mb (sequel a)])
          (mb v))))))
```
