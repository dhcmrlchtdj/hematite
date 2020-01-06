# async compare

---

http://clojure.com/blog/2013/06/28/clojure-core-async-channels.html

> (actors) still couple the producer with the consumer.

> channels are subject to deadlocks

---

https://en.wikipedia.org/wiki/Communicating_sequential_processes

+ CSP 的 procrss 是匿名的，actor 是带标示的
+ CSP 的数据传递是同步的，actor system 的数据传递是异步的
    - CSP 可以借由 buffer 变得异步
    - actor system 可以通过使用某种通信协议变得同步
+ CSP 使用确定的 channel 传递信息，actor 直接传递给另一个 actor
    - process 如果只从一个 channel 读取数据，那么和一个 actor 没什么区别
    - actor 同样能当成 channel 来使用，达到解耦的目的

---

http://stackoverflow.com/questions/20632512/comparing-core-async-and-functional-reactive-programming-rx

- FRP 关注的是传递变化情况。源头发现变化，传递到其他地方。
- CSP 关注的是系统解耦。进程之间用 channel 传递信息。

两者关注的是不同层次的抽象

---

http://clojure.com/blog/2013/06/28/clojure-core-async-channels.html

> Events complect communication and flow of control.

事件机制（包括 FRP）在复杂之后，就会出现 communication 和 flow control 混杂的情况。

作者的逻辑是这样的
- 缺少 thread 的支持，所以转向 events
- 使用 FRP 等许多机制，让 events 更加清晰
- 一个事件触发未知个数的代码块开始运行，这样不好
    - don't do too much work in your handler

---

http://ambassadortothecomputers.blogspot.com/2010/05/how-froc-works.html

- `behaviors`
    - 会随时间变化的值
    - 始终存在
- `events`
    - 只存在一瞬间
    - 前后的值可能相同，可能不同
- `signals`
    - events or behaviors

---

http://cs.stackexchange.com/questions/9038/how-do-functional-reactive-programming-and-the-actor-model-relate-to-each-other

- actors
    - message passing is described explicitly and imperatively
    - tend to be async

- FRP
    - data flow is described declaratively
    - tends to be synchronous

---

http://cs.stackexchange.com/questions/9038/how-do-functional-reactive-programming-and-the-actor-model-relate-to-each-other

- FRP
    - model signals and events on a linear timeline
    - composable，多个操作可以组合
    - supports local state through integrals or accumulators

- actors
    - process messages in non-deterministic order
    - not composable，不能将两个 actor 组合成一个大的 actor
    - supports state by allowing each actor to specify its behavior for the next message in response to the current one

---

http://stackoverflow.com/questions/1028250/what-is-functional-reactive-programming
http://apfelmus.nfshost.com/blog/2011/03/28-essence-frp.html

> The essence of functional reactive programming is to
> specify the dynamic behavior of a value
> completely at the time of declaration.

---

http://jelv.is/frp/

- FRP is a novel, more declarative way of writing reactive systems like user interfaces and games.
- FRP can be used wherever you would normally use an event/observer callback-based style.

- make time explicit
- program with values over time
- handle both continuous and discrete time

- behavior, value continuous over time
- event, value at a particular time
- stream, infinite list of events ordered by time

---

https://begriffs.com/posts/2016-07-27-tikhon-on-frp.html

- motivation without definitions makes you feel like you understand something
    but what you understand is not the abstraction itself

- functional means simple, composable, and declarative

- Behaviors change continuously
- Events happen at points in time
- Behavior is a function from time to values
- Event is pair of time and value

---

http://reactivex.io/rxjs/manual/overview.html

- Think of RxJS as Lodash for events.
- Observables are like functions with zero arguments, but generalize those to allow multiple values.
- Observables are able to deliver values either synchronously or asynchronously.
- Subscribing to an Observable is like calling a function, providing callbacks where the data will be delivered to.
- Observers are just objects with three callbacks, one for each type of notification that an Observable may deliver.
- A Subscription essentially just has an unsubscribe() function to release resources or cancel Observable executions.
- A Subject is like an Observable, but can multicast to many Observers. Subjects are like EventEmitters: they maintain a registry of many listeners.
- An Operator is a function which creates a new Observable based on the current Observable. This is a pure operation: the previous Observable stays unmodified.
- A Scheduler lets you define in what execution context will an Observable deliver notifications to its Observer.
