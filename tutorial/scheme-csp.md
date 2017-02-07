# scheme csp

---

https://cgi.soic.indiana.edu/~c311/lib/exe/fetch.php?media=cps-notes.scm

---

- CSP 也可以看看 little schemer 的第八章
- 这个函数风格，是不是就是 little 里面搞出来的，讲解方式也有点类似

---

文章里讲了两条规则

+ whenever we see a lambda in the code we want to CSP,
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
