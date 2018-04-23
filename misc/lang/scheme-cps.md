# scheme cps

---

https://cgi.soic.indiana.edu/~c311/lib/exe/fetch.php?media=cps-notes.scm

---

- CPS 也可以看看 little schemer 的第八章
- 这个函数风格，是不是就是 little 里面搞出来的，讲解方式也有点类似

---

文章里讲了两条规则

+ whenever we see a lambda in the code we want to CPS,
	we have to add an argument, and then process the body:
	`(lambda (x ...) ...) => (lambda (x ... k) ...^)`
+ "don't sweat the small stuff!"

---

文中给的例子

```scheme
(define rember8
  (lambda (ls)
    (cond [(null? ls) '()]
          [(= (car ls) 8) (cdr ls)]
          [else (cons (car ls) (rember8 (cdr ls)))])))

(define rember8
  (lambda (ls k)
    (cond [(null? ls) (k '())]
          [(= (car ls) 8) (k (cdr ls))]
          [else (rember8 (cdr ls) (lambda (x) (k (cons (car ls) x))))])))
```

```scheme
(define multirember8
  (lambda (ls)
    (cond [(null? ls) '()]
          [(= (car ls) 8) (multirember8 (cdr ls))]
          [else (cons (car ls) (multirember8 (cdr ls)))])))

(define multirember8
  (lambda (ls k)
    (cond [(null? ls) (k '())]
          [(= (car ls) 8) (multirember8 (cdr ls) k)]
          [else (multirember8 (cdr ls) (lambda (x) (k (cons (car ls) x))))])))
```

---

主要的技巧，还是在递归时如何构造出回调函数来。

---

https://cgi.soic.indiana.edu/~c311/doku.php?id=cps-refresher

---

不带 cps 的版本

```scheme
(define fact
  (lambda (n)
    (cond [(zero? n) 1]
          [else (* n (fact (sub1 n)))])))
```

带 cps 的版本
下面多给了一个 fact 的封装

```scheme
(define fact-cps
  (lambda (n k)
    (cond [(zero? n) (k 1)]
          [else (fact-cps (sub1 n) (lambda (x) (k (* x n))))])))

(define fact
  (lambda (n)
    (fact-cps n empty-k)))
(define empty-k (lambda (v) v))
```

---

复杂一点点的 fib

```scheme
(define fib
  (lambda (n)
    (cond
      [(zero? n) 1]
      [(= n 1) 1]
      [else (+ (fib (sub1 n)) (fib (sub1 (sub1 n))))])))

(define fib-cps
  (lambda (n k)
    (cond [(zero? n) (k 1)]
          [(= n 1) (k 1)]
          [else (fib-cps (sub1 n)
                     (lambda (v1)
                       (fib-cps (sub1 (sub1 n))
                            (lambda (v2)
                              (k (+ v1 v2))))))])))
```
