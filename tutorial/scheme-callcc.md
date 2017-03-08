# call/cc

---

http://www.scheme.com/tspl4/further.html#./further:h3
http://www.r6rs.org/final/html/r6rs/r6rs-Z-H-14.html#node_sec_11.15
https://en.wikipedia.org/wiki/Call-with-current-continuation

---

看 seasoned schemer 第十九章
遇到一个难以理解的特性
call/cc 会跳转捕获处，并忽略调用处的上下文

---

先给个 letcc 定义，其实就是 call/cc 啦
虽然看起来只是少了一层 lambda
不过这样形式上和 let/letrec 等更接近，更好理解些？

```scheme
(define-syntax letcc
  (syntax-rules
    ()
    ((letcc k body ...)
     (call/cc (lambda (k) body ...)))))
```

---

先看下 TSPL4 的例子

- `(letcc k (* 5 4))` => 20
- `(letcc k (* 5 (k 4)))` => 4
- `(+ 2 (letcc k (* 5 (k 4))))` => 6

可以看到

- 在 k 没有被调用的时候，函数的返回值会作为 letcc 的返回值
- 在 k 被调用的时候，传给 k 的参数会作为 letcc 的返回值

---

letcc 的常见用途之一，是减少无效的计算，提早返回
还是 TSPL4 的例子

```scheme
(define product
  (lambda (ls)
    (letcc
      break
      (letrec
        ([f (lambda (l)
              (cond [(null? l) 1]
                    [(= (car l) 0) (break 0)]
                    [else (* (car l) (f (cdr l)))]))])
        (f ls)))))

(product '(1 2 3 4 5))
(product '(7 3 8 0 1 9 5))
```

这里不用 break 其实还是能得到正确答案，只是 0 会重复参与计算
借助 break 可以提前跳出循环，break 的参数，直接作为整个 letcc 的返回值

---

前面都是 k 在 letcc 内部调用的例子
下面讲讲 k 在 letcc 外部的情况

```scheme
(let ([x (letcc k k)]) (x (lambda (ignore) "hi"))) ;; => "hi"

(((letcc k k) (lambda (x) x)) "HEY!") ;; => "HEY!"
```

感觉第二行还好理解一些
`(lambda (x) x)` 作为 `letcc` 的返回值，然后调用返回 `"HEY!"`

第一行稍微有点绕
`(x ...)` 的参数作为 `letcc` 的返回值
导致程序回到 `(let ([x ...]) ...)`
接着 `x` 被绑定到 `(lambda (ignore) "hi")`
之后继续执行后面的语句，或者叫做重新执行，不过这时 `x` 已经不是 `k` 了
`x` 也就是 `(lambda (ignore) "hi")` 被调用并返回 `"hi"`

---

还是 k 跑到 letcc 外部的例子

```scheme
(define retry #f)
(define factorial
  (lambda (x)
    (if (= x 0)
      (letcc k (set! retry k) 1)
      (* x (factorial (- x 1))))))

(factorial 4) ;; => 24
(retry 1) ;; => 24
(retry 2) ;; => 48
```

理解起来没什么问题
调用 `retry` 的时候，参数作为 letcc 的返回值，参与 `factorial` 未完成的计算

比较怪异的是 `(+ 1 (retry 1))`
返回的不是 25 而是 24
要理解的话，就是 `(retry ...)` 回到了 `factorial`，当前的调用信息全部丢失了

---

中场休息一下，用 CPS 改写前面的 call/cc

```scheme
(define product
  (lambda (ls kk)
    (letrec
      ([f (lambda (l k)
            (cond [(null? l) (k 1)]
                  [(= (car l) 0) (kk 0)]
                  [else (f (cdr l) (lambda (x) (k (* (car l) x))))]))])
      (f ls kk))))

(product '(1 2 3 4 5) (lambda (x) x))
(product '(7 3 8 0 1 9 5) (lambda (x) x))
```

```scheme
(define retry #f)
(define factorial
  (lambda (x k)
    (if (= x 0)
      (begin (set! retry k) (k 1))
      (factorial (- x 1) (lambda (y) (k (* x y)))))))

(factorial 4 (lambda (x) x)) ;; => 24
(retry 1) ;; => 24
(retry 2) ;; => 48
```

值得一提，这里 `(+ 1 (retry 1))` 返回的是 25 不是 24 哦

---

回来看下 r6rs 是怎么说的

> The escape procedure is a Scheme procedure that, if it is later called,
> will abandon whatever continuation is in effect at that later time and will
> instead reinstate the continuation that was in effect when the escape
> procedure was created.

前面纠结的 `(+ 1 (retry 1))`，在这里被 abandon 一笔带过

r6rs 文档后面给了一个 call/cc 的例子
在 foreach 循环里中途返回

r7rs 里的这段描述基本一摸一样，就改了两个单词。
后面补充了一句关于 call/cc 使用场景的介绍

> A common use of call/cc is for structured, non-local exits from loops or
> procedure bodies, but in fact call/cc is useful for implementing a wide
> variety of advanced control structures.
