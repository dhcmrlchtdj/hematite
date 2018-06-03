# midori

---

http://joeduffyblog.com/2015/11/03/blogging-about-midori/

---

## Blogging about Midori

---

> programming language, compilers, OS, services, applications, programming models
> language, compilers, core frameworks, concurrency models, and IDEs/tools

巨大的野心

> Most of my blog entries will focus on the key lessons that we're now trying to
> apply back to the products, like asynchrony everywhere, zero-copy IO,
> dispelling the false dichotomy between safety and performance,
> capability-based security, safe concurrency, establishing a culture of
> technical debate, and more.

复盘，对于成长有重要意义。

---

## A Tale of Three Safeties

---

- 三种不同类型的安全
    - memory safety
    - type safety
    - concurrenct safety

---

> The answer is surprisingly simple: layers.

> There was of course some unsafe code in the system.
> Each unsafe component was responsible for "encapsulating" its unsafety.

硬件、软件、网络，可能出问题的地方很多。
为了实现前面三种不同类型的安全，使用安全的语言编写重写整个系统。
只有少量的 OS 内核使用不安全的语言，把不安全的部分，限制在最少。

---

> we banned unsafe concurrency

至于并发，按我理解，这里提及了 erlang/go 的消息传递机制及 rust 的所有权机制。

---

## Objects as Secure Capabilities

---

- 通过 type, memory, concurrency safety 实现 security
- 使用 capabilities 实现 security (access control
- 依靠编程语言及其类型系统，约束 capabilities

---

在 unix 下面，通过判断 user/group 的权限实现访问控制。
（比如 `open("filename", O_RDONLY)` 这样的调用
这样的权限检查属于运行时行为，带有不确定性。

个人想法。没想明白。
希望把验证放到编译期，意味着把信息放到类型中（？）。
这要怎么放进去呢？确实是运行时的信息吧。
但话也不能说绝对，idris 那样的类型系统，确实能持有更多类型信息。
只是我自己懂得不够多。

想在文件系统实现 capability，需要从系统设计层面提供支持。
比如 Linux Capabilities。

---

- capability 被实现成一个 object（可以复用 OO 中关于 security / authority 的实践经验
- 关于 Distributed Capabilities，没看懂。大意是 unforgeable token 可传递？
    - 是不是有点像 ownership 的传递？或者是类似于消息传递，传递了实体？

---

## Asynchronous Everything

---

- ultra-lightweight, fine-grained processes
- strongly typed message passing interfaces

---

- promise
    - all asynchrony is expressed in the type system
    - `Promise<T>`
- async/await
    - `T / Result<T> / Async<T> / Async<Result<T>>`
    - `Promise<T> -> AsyncResult<T>`
    - async/await encouraged a pull-style of concurrency
    - `IObservable<T> / IObserver<T>` offered bridges between pull and push

- 个人想法
    - 异步，始终是个需要特殊处理的事物。要有类型系统支持，最好还要特殊语法支持
    - 不仅仅是异步，很多语言特性，有了语法糖吃得才甜

---

- C#'s implementation of async/await is entirely a front-end compiler trick

- ultra-lightweight processes
    - each process had a distinct heap that was independently collectible
    - stack start as small as 128 bytes and grow as needed (doubled each time)
    - execute all non-asynchronous code on classical stacks

- message passing
    - all of the data structures necessary to talk cross-process were in user-mode, so no kernel-mode transitions were needed
    - pipelining
    - three-party handoff

---

- cancellation
    - use-case, how to implement the browser's "cancel" button reliably
    - CancellationToken
- state management
    - message passing systems don't have race conditions is an outright lie
    - Statelessness was by far the easiest pattern. Isolation was a close second. Everything else was just a little dirty.
- ordering
    - Distributed systems are unordered. It sucks. Don’t fight it. You’ll regret trying.
- debugging
    - The solution, as with many such challenges, was tooling.
- resource management
    - self-control vs automatic resource management

- 个人想法
    - 作者这个章节，反复提及 scale
    - 设计上需要支持系统开发到应用开发，之前 C# 使用的一些方案就不适用了

---

## Safe Native Code

---

- AOT / JIT
- compliation architecture
    - compiler / high-level IR / low-level IR
- optimizations
    - bounds check elimination
    - overflow checking
    - inlining
    - code size
- system architecture
    - GC
        - conservative / precise
        - cooperative / preemptive
        - generational collector
        - concurrent mark-sweep compacting collector
    - separate compilation
    - parametric polymorphism
    - virtual dispatch
    - async model
        - the compiler was key to making linked stacks work
    - memory ordering model
    - error model
        - exceptions / return codes
        - ended up being a hybrid of two things
            - Fail-fast for programming bugs.
            - Typed exceptions for dynamically recoverable errors.
    - contracts


- 个人想法
    - 这里很多东西，没有动手实现过
    - 很多概念不是第一次看到，但还不足以完全理解

---

## The Error Model

---

> the whole system was written in it, including drivers, the domain kernel, and all user code.

> Like many other things we did in Midori,
> a "whole system" approach was necessary to getting it right,
> taking several iterations over several years.

这点被作者反复提及。

---

- fail-fast (abandonment), for programming bugs
- statically checked exceptions, for recoverable errors

---

- error codes
    - coupled with a dataflow-style of programming and pattern matching
    - option types help to address this (forget to check a return code) for functional languages
    - some languages (ML family) mix this elegant model with the world of unchecked exceptions. This taints the elegance of the monadic data structure approach.
    - (rust's try! macro) leads us to a beautiful sweet spot

- exceptions
    - unchecked exceptions model
        - any function call can throw an exception, transferring control non-locally somewhere else. Where? Who knows.
    - checked exceptions
        - java exceptions are used to communicate unrecoverable bugs
        - You don't actually know everything that might be thrown in java, thanks to our little friend RuntimeException.
    - universal problems
        - throwing an exception is usually ridiculously expensive
        - exceptions can significantly impair code quality
        - control flow for throws is usually invisible

> For a significant class of error, none of these approaches are appropriate!

---

the difference between recoverable errors and bugs

- recoverable error
    - usually the result of programmatic data validation
    - programs are expected to recover
    - it will happen in well-constructed programs no matter what you do

- bug
    - a kind of error the programmer didn't expect
    - it cannot be handled or fixed at runtime, it can only be fixed by its developer

> The key thing is not preventing failure per se, but rather knowing how and when to deal with it.

---

> an operating system is just a distributed network of cooperating processes,
> much like a distributed cluster of microservices or the Internet itself.
> The main differences include things like latency; what levels of trust you can
> establish and how easily; and various assumptions about locations, identity, etc.

> As programs continue moving to the cloud, and become aggressively decomposed
> into smaller independent services, this clear separation of transient and
> persistent state is even more important.

---

- isolation is critical
- isolation encourages simplicity

- 个人理解
    - 隔离好不同进程，能方便从各种异常中恢复
    - erlang 在异常和并发两个方面，都值得学习

---

> - The functional perspective would be to use dataflow for all errors, but exceptions were very control-flow-oriented.
> - You’re in a statically typed programming language, and the dynamic nature of exceptions is precisely the reason they suck.
> - Exceptions thrown by a function became part of its signature, just as parameters and return values are.

- 个人想法
    - rust 的做法比较让人喜欢
    - ocaml 的 oo 和 exception 都喜欢不起来
    - 该不该有语法糖，还没想清楚优劣

---

- Retrospective
    - An architecture that assumed fine-grained isolation and recoverability from failure.
    - Distinguishing between bugs and recoverable errors.

---

## Performance Culture

---

