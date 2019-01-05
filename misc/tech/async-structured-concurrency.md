# structured concurrency

---

https://vorpus.org/blog/notes-on-structured-concurrency-or-go-statement-considered-harmful/

---

> The popular concurrency primitives - go statements, thread spawning functions,
> callbacks, futures, promises, ...
> they're all variants on goto, in theory and in practice.

> Unfortunately, to fully capture these benefits, we do need to remove the old
> primitives entirely, and this probably requires building new concurrency
> frameworks from scratch – just like eliminating goto required designing new
> languages.

`goto` 太过灵活。允许任意跳转，使得程序维护变得困难。
作者认为 golang 的 `go` 也存在类似的问题。

相对的，对 `goto` 进行限制，用 `if/while/function` 足以表达语义。
对 `go` 进行限制后，作者得出了 structured concurrency。

---

https://matklad.github.io/2018/06/18/exceptions-in-structured-concurrency.html

---

那么，structured concurrency 到底在说什么呢？
感觉这篇文章说的更直白

> The benefit of this organization is that all threads form a tree, which gives
> you greater control, because you know for sure which parts are sequential and
> which are concurrent.
> Concurrency is explicitly scoped.

将异步的流程，表达成树形。
不仅仅是逻辑上是树形，在代码控制层面也表达为树形。

---

> when one of the tasks in scope fails, all others are immediately cancelled,
> and then awaited for.

这个倒确实是 JS 里缺失的。
Promise.all 失败时，没失败的任务也不会取消。

---

https://news.ycombinator.com/item?id=16921761

---

> This addresses the wrong problem.
> The real issue is control over data shared between threads, not control flow.

HN 上的评论，好像大部分都是负面的。
看不太懂，不过这句在理。

代码流程和逻辑，是不是能够一一对应，需不需要做到一一对应。
我现在判断不清楚。
不过，并发，缺失是数据问题吧。

---

https://medium.com/@elizarov/structured-concurrency-722d765aa952

---

> Coroutines are always related to some local scope in your application, which
> is an entity with a limited life-time, like a UI element.

看例子的代码，明确构造了一个 `coroutineScope`。

```
// before
suspend fun loadAndCombine(name1: String, name2: String): Image {
    val deferred1 = async { loadImage(name1) }
    val deferred2 = async { loadImage(name2) }
    return combineImages(deferred1.await(), deferred2.await())
}

// after
suspend fun loadAndCombine(name1: String, name2: String): Image =
    coroutineScope {
        val deferred1 = async { loadImage(name1) }
        val deferred2 = async { loadImage(name2) }
        combineImages(deferred1.await(), deferred2.await())
    }
```

> All the async coroutines become the children of this scope and, if the scope
> fails with an exception or is cancelled, all the children are cancelled, too.

作者也是提到异常处理。
所以，structured concurrency 的着眼点，是异常处理？
或者说，是把几个并发的任务，归到了一组里。

---

最后提一点个人困惑。
前面有一点我是认同的，并发的问题是在于数据。
如果操作都是幂等的，那么取消就取消了。
但实践中，写入操作，不能这么粗暴直接取消吧。
这时候，需要事务？怎么结合呢？
