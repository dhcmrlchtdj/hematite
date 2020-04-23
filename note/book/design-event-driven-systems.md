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

## III. Rethinking Architecture at Company Scales

---

### 8. Sharing Data and Services Across an Organization

---

> how do we design systems that age well at company scales and keep our businesses nimble?

感觉整章都没讲什么东西

> the more we reuse a component, the more dependencies that component has, and the harder it is to change.

复用意味着耦合，增加了未来修改的难度。
这还是在讲 bounded context 吧。

---

### 9. Event Streams as a Shared Source of Truth

---

> The “database inside out” idea is important because a replayable log, combined with a set of views, is a far more malleable entity than a single shared database
> The different views can be tuned to different people’s needs, but are all derived from the same source of truth: the log.

这章还是在讲 log 和 database 的关系。
不同业务可以通过 log 构建不同的 view 去满足不同的 query。
（数据库也有 materialized view 呀

---

### 10. Lean Data

---

> Lean data is a simple idea: rather than collecting and curating large
> datasets, applications carefully select small, lean ones -- just the data they
> need at a point in time -- which are pushed from a central event store into
> caches, or stores they control.

感觉还是在讲一样的东西

---

## IV. Consistency, Concurrency, and Evolution

---

### 11. Consistency and Concurrency in Event-Driven Systems

---

> When you write a record, it stays written. When you read a record, you read
> the most recently written value.

> If you perform multiple operations in a transaction, they all become visible
> at once, and you don’t need to be concerned with what other users may be doing
> at the same time.

人话解释什么是 consistency

---

> A useful way to generify these ideas is to isolate consistency concerns into
> owning services using the single writer principle.

> We adapted eventual consistency with the single writer principle, keeping its
> lack of timeliness but avoiding collisions.

缺少实际经验，不知道 raft 之类强一致性会带来多少性能影响。
什么样的性能需求，才需要牺牲强一致性呢？

---

### 12. Transactions, but Not as We Know Them

---

> Exactly Once Is Both Idempotence and Atomic Commit

RPC 的三种情况，at-most-once / at-least-once / exactly-once

- 作为 receiver，怎么保证 at-most-once 呢？可以像 database 一样要求数据加主键

---

> Now the aim of a transaction is to ensure only “committed” data is seen by
> downstream programs. To make this work, when a consumer sees a Begin marker it
> starts buffering internally. Messages are held up until the Commit marker
> arrives. Then, and only then, are the messages presented to the consuming
> program. This buffering ensures that consumers only ever read committed data.

一个 Begin 加一个 Commit，将多个消息合并成事务。
一个事务持续多久呢？心跳包？还是直接超时？

> To ensure each transaction is atomic, sending the Commit markers involves the
> use of a transaction coordinator.

一个 coordinator 来分发 Begin 标记

---

### 13. Evolving Schemas and Data over Time

---

> Protobuf and JSON Schema are both popular, but most projects in the Kafka space use Avro

嗯？

---

> Say you added a “return code” field to the schema for an order; this would be
> a backward-compatible change.
> Programs running with the old schema would still be able to read messages,
> but they wouldn’t see the “return code” field (termed forward compatibility).
> Programs with the new schema would be able to read the whole message, with the
> “return code” field included (termed backward compatibility).
> Unfortunately, you can’t move or remove fields from a schema in a compatible
> way

什么是向前什么是向后，分不清。
前后是相对谁而言的呢……

---

> most of the time backward compatibility between schemas can be maintained
> through additive changes (i.e., new fields, but not moves or deletes).
> But periodically schemas will need upgrading in a non-backward-compatible way.
> The most common approach for this is Dual Schema Upgrade Window, where we
> create two topics, orders-v1 and orders-v2, for messages with the old and new
> schemas, respectively.

只要能接受数据冗余，直接分发多种格式的数据是最方便的吧。
看起来也是唯一的方法。

---

## V. Implementing Streaming Services with Kafka

---

### 15. Building Streaming Services

---

> The orders service implements a blocking HTTP GET so that clients can read
> their own writes.
> This technique is used to collapse the asynchronous nature of the CQRS pattern.

> block the GET operation until the event arrives

处理第七章的 read-after-write 一致性
