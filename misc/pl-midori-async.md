# midori

---

http://joeduffyblog.com/2015/11/19/asynchronous-everything/

---

## promise

---

```
p.WhenResolved(
    ... as above ...
).Ignore();
```

> This turns out to be a bit of an anti-pattern.
> It’s usually a sign that you’re mutating shared state.

---

promise 的不足之处

> The model tossed out decades of familiar programming language constructs,
> like loops.

> It led to callback soup, often nested many levels deep, and often in some
> really important code to get right.

---

## async/await

---

- `T`: the result of a prompt, synchronous computation that cannot fail.
- `Async<T>`: the result of an asynchronous computation that cannot fail.
- `Result<T>`: the result of a a prompt, synchronous computation that might fail.
- `AsyncResult<T>`: the result of an asynchronous computation that might fail.
    - shortcut for `Async<Result<T>>`

> guaranteed by type system

---

> Maybe the biggest problem was that it encouraged a pull-style of concurrency.

---

## The Execution Model

---

> And when I say “no blocking,” I really mean it: Midori did not have demand
> paging which, in a classical system, means that touching a piece of memory
> may physically block to perform IO.

> C#’s implementation of async/await is entirely a front-end compiler trick.

---

## Message Passing
## Streams
## Cancellation
## Ordering
## Resource Management

---

## mime

缺少实践，还是有点难懂。
调度的时候，使用 await 之类的关键字作为主动释放处理器的点。
配合执行情况，固定时间片后强制释放处理器。
这样的策略是不是比较好呢？

另外，关于到底 yield 操作该不该由用户显示标注呢？
不知道代码是否会被 yield，会不会造成什么问题呢？
