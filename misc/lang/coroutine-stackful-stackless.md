# stackful / stackless

---

对 stackless/stackful 的实际区别，一直没太明白

尝试整理一下
- 区别在哪？
- 如何选择？

---


https://news.ycombinator.com/item?id=17242771
> whether you can yield execution across a function that doesn't know about async/await
> whether the implementation uses the same stack discipline for calls that can yield vs those that cannot

https://blog.varunramesh.net/posts/stackless-vs-stackful-coroutines/
> whether a coroutine needs a stack while it is suspended
> (stackless coroutine can) use the current call stack for executing the next coroutine
> stackful coroutines let you suspend your coroutines at any point

https://www.zhihu.com/question/65647171/answer/233495694
> 跳转离开，在任何语言里都有2种最基本的方法：1）从当前函数返回； 2）调用一个新的函数。

- stackful coroutine 可以在任意位置 suspend
    - 比如 golang/lua
    - http://journal.stuffwithstuff.com/2015/02/01/what-color-is-your-function/ 说的也是这个事情
- stackless coroutine 在 suspend 的地方需要关键字
    - 比如 c#/js 的 async/await
    - 在 suspend 之前，可以把之前的状态保留下来，而不需要完整的堆栈

```
var fiber = Fiber.new {
    (1..10).map {|i|
        // Wren can yield from inside this block.
        Fiber.yield(i)
    }
}
```

上面这个例子，`map` 的回调函数直接 yield 到了外层。
这种跨函数的 yield 在 stackless coroutine 里就做不到。
（是不是有点像 delimited continuation 的 reset/shift 呢？

---

还是缺少很直观的认知
