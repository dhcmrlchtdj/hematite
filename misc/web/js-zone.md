# zone

---

https://www.dartlang.org/articles/libraries/zones
https://github.com/angular/zone.js/
https://github.com/angular/zone.js/blob/master/dist/zone.js.d.ts

https://nodejs.org/api/async_hooks.html
https://blog.golang.org/context

---

之前一篇 java MDC 的文章，想到了 zone 这个东西。

---

> A Zone is an execution context that persists across async tasks.
> You can think of it as thread-local storage for JavaScript VMs.

问题是，怎么定义 thread 呢？
比如处理网络请求，肯定是希望一个请求对应一个虚拟的 thread
但在不同 task 切换时，怎么判断 thread 是否发生了切换？

另外就是，这种机制对性能的影响有多少？

---

- 显式创建一个 zone（比如调用 `runZoned(() => {/*new zone here*/})`
- 直到当前 task 返回之前，都在一个 zone 中
- zone 里可以创建新的 zone

根据目前为止的条件
创建时，保存之前的 zone，然后将新的 zone 传递匿名函数
当 zone 内部出现异步调用，保存当前的 zone（用某个 UUID 关联起来
当异步调用开始时，再靠 UUID 取回 zone
