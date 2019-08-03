# kotlin coroutine

https://github.com/Kotlin/KEEP/blob/master/proposals/coroutines.md

---

`suspend fun <T> CompletableFuture<T>.await(): T`
会被改写成
`fun <T> CompletableFuture<T>.await(continuation: Continuation<T>): Any?`

- 增加了 continuation 参数
- 返回值类型 `Any?` 实际应该是 `COROUTINE_SUSPENDED | T`，可惜 kotlin 类型系统不足以表达

- state machine
    - one class per suspending lambda
    - a suspending function is compiled to a state machine
    - states correspond to suspension points

---


