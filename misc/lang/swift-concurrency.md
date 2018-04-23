# swift concurrency

---

https://github.com/apple/swift/blob/master/docs/proposals/Concurrency.rst

---

这个提案说的是 `Swift thread-safety layer`，目标是 `low-level thread-safety layer`
而 `Actirs/Coroutines/Async-Await` 则是在其上构建的 `high-level safe concurrency solutions`

---

> Safe concurrency is commonly implemented by eliminating shared mutable memory.

状态随时间发生变化，这个是并发的万恶之源吧。
这里讲 Go/Erlang/Rust 都是以 避免共享可变数据 这种方式来提供并发支持。

> Mutable data can be shared between threads as long as the access to the data
> is synchronized and some program properties are verified by the compiler.

这句到底在说什么……
如果数据读写可以同步，并发就已经被抽象掉了吧，和写同步程序没有区别了。
那数据是否可变，和并发其实就无关了。

> In Swift thread safety is implemented by preventing threads from sharing mutable memory.

没明白这里的 mutable memory 和前面的 mutable data 什么区别。

---

> new threads are created in a new memory enclave that is separate from the
> parent thread.
> Values can be copied in and out of the new thread context, but the child
> thread must never obtain a reference that points to the outside world.
> Non-reentrant code needs to be explicitly marked as such.

提到了三点设计

1. 子进程独立的内存空间
2. 给子进程的数据采用传值的方式，不能传递引用
3. 明确标记不可重入的代码
