# The Law of Leaky Abstractions

---

https://www.joelonsoftware.com/2002/11/11/the-law-of-leaky-abstractions/

---

leaky abstraction

> TCP attempts to provide a complete abstraction of an underlying unreliable
> network, but sometimes, the network leaks through the abstraction and you
> feel the things that the abstraction can’t quite protect you from.

> You’re not supposed to have to care about the procedure, only the
> specification. But sometimes the abstraction leaks and causes horrible
> performance and you have to break out the query plan analyzer and study
> what it did wrong, and figure out how to make your query run faster.

TCP 和 SQL 的例子
这些抽象，无法完全屏蔽底层实现

---

> All non-trivial abstractions, to some degree, are leaky.

---

> learn how to do it manually first, then use the wizzy tool to save time.
> ... the only way to deal with the leaks competently is to learn about how
> the abstractions work and what they are abstracting.

作者表示，人们会这么想，其实真是因为抽象泄漏
碰到问题的时候，就必须去了解底层的实现

---

在 IRC 上看到人提起这篇文章
说到硬件抽象做得比软件抽象好很多

因为你不需要了解硬件的实现
而前面例举的软件抽象，没能按照预期工作时，都不得不去了解底层实现

---

文中说的问题，接触的东西越多，感觉就越明显吧。
