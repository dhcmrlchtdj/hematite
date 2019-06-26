# scheme debug

---

https://cisco.github.io/ChezScheme/csug9.4/debug.html#./debug:s9

---

chez 提供了 `trace` 和 `untrace`，可以用来观察函数的调用过程。
有时候错误提示完全看不出哪里出问题，可以用 trace 跟一下。

```
> (define half
    (lambda (x)
      (cond
        [(zero? x) 0]
        [(odd? x) (half (- x 1))]
        [(even? x) (+ (half (- x 1)) 1)])))
> (half 5)
2
> (trace half)
(half)
> (half 5)
|(half 5)
|(half 4)
| (half 3)
| (half 2)
| |(half 1)
| |(half 0)
| |0
| 1
|2
2
> (define traced-half half)
> (untrace half)
(half)
> (half 2)
1
> (traced-half 2)
|(half 2)
|1
1
```
