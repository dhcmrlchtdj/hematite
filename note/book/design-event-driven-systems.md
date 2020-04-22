# design event-driven systems

---



---

## II. Designing Event-Driven Systems

---

### 5. Events: A Basis for Collaboration

---

> composing services not through chains of commands and queries, but rather through streams of events

---

作者将操作划分成三类

- command 改变系统状态，有返回值
- event 改变系统状态，没有返回值
- query 不改变系统状态，有返回值

command 对应 request-driven
event 对应 event-driven
query 则是完全另一种东西

---

request-driven 和 event-driven 都能实现功能，问题是如何选择，边界在哪里

按之前项目的经验，A/B/C 三类任务，放在一个 worker 里还是拆成三个 worker？
首先是逻辑上，属于一个流程的多个步骤（比如 A1/A2/A3），还是完全变成了另一种概念（比如 A/B/C），概念变化可以考虑分开。
然后根据任务对 buffer 长度和 worker 数量的不同要求做拆分，比如数据库只允许固定数量的并发连接，但网络请求允许更多并发连接，就可以分成不同的 worker。

---

> Communication between microservices needs to be based on asynchronous message passing
> (while logic inside each microservice is performed in a synchronous fashion).

---

> request-driven protocols used inside the bounded context, and messaging between them

bounded context 是 DDD 提出来的概念。
在 context 内部，可以采用 request-driven 的方式，而不同的 context 通信，可以采用 event-driven 的方式。

---

### 6. Processing Events with Stateful Functions

---

> This has led some implementers to build systems around a functional core,
> which processes events asynchronously, wrapped in an imperative shell, used
> to marshal to and from outward-facing request-response interfaces.

> The “functional core, imperative shell” pattern keeps the key elements of the
> system both flexible and scalable, encouraging services to avoid side effects
> and express their business logic as simple functions chained together through
> the log.

这里 functional core 指的是 dataflow 那种处理数据的方式。

---

这章节标题说的 stateful，其实是这样子的。

假设有个 email service，收到 order event 的时候，要给用户发邮件。
然后发送邮件，要查询用户信息，用户信息来自 customer event。
传统的方式是通过 RPC 请求另一个 customer service，获得用户信息。
这里的 stateful，则是 email service 根据 customer event 自己维护一个临时库，不再依赖外部 service。
自己有数据库，自然也就 stateful 了。

可能还是经验太少吧，节省这一点 RPC 的开销反而把系统搞复杂了，值得吗？
维持数据一致性的难度，要大于优化 RPC 性能吧？

---

### 7. Event Sourcing, CQRS, and Other Stateful Patterns

---

Command Query Responsibility Segregation 和 Event Sourcing 两个词都成 buzzword 了吧。

> what these concepts mean
> how they can be implemented
> when they should be applied

---

> Event Sourcing ensures every state change in a system is recorded
> Making Events the Source of Truth

从这两句话可以看出，event sourcing 其实就是 log。
database 和 log 的关系，一体两面，不需要多说了。

---

> CQRS separates the write path from the read path and links them with an asynchronous channel.

异步之后的数据一致性，要怎么保证？还是放弃 read-after-write 一致性？

---


