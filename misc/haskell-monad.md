# all about monads

---

https://wiki.haskell.org/All_About_Monads

---

最近在想一个问题，怎么收集多个模块的 log。

比如 web server 希望收集到全部调用链的 log，统一加上 requestID，方便排查。
但这个过程中，肯定有一些完全独立的模块，比如数据库的读写。
这些模块本身功能很独立，不希望和其他东西耦合起来，根本不像知道 requestID 的存在。
不管是传入 requestID 还是传入 logger，感觉都不是非常合适。

所以能不能用 monad 解决呢。

---

monad laws

```
BIND (RETURN x) f == f x
BIND m RETURN == m
BIND (BIND m f) g == BIND m ((x) => BIND (f x) g)   // associativity
```

---

```
return: 'a -> 'a t
bind: 'a t -> ('a -> 'b t) -> 'b t

return: 'a -> 'a t
join: 'a t t -> 'a t
```
