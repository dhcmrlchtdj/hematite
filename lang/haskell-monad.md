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
---

前几天在 rust 群里，看到别人聊起 monad。
大佬说到不支持 HKT 的语言表示不了 monad。

开始觉得不理解，monad 不就是某种容器吗？
实现 return 和 bind 就好了，为什么说表示不了呢？

搜了下 HKT，发现确实是这样啊。
拿上面的例子来说

```
return: 'a -> 'a t
bind: 'a t -> ('a -> 'b t) -> 'b t
```

在实际使用的时候，这里的 `t` 必须是某个特定的容器（比如 `option/result`）。
在 ocaml 里，表达不了任意容器的概念。

而在 haskell 里，有 typeclass，例子里的 m 可以是任意的容器。
这样能完整表达出 monad 的约束。

```
class Monad m where
    return:: a -> m a
    bind:: m a -> (a -> m b) -> m b
```

HKT 真棒…
