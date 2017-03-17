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

## CSP vs FRP

---

http://stackoverflow.com/questions/20632512/comparing-core-async-and-functional-reactive-programming-rx
http://clojure.com/blog/2013/06/28/clojure-core-async-channels.html

---

- FRP 关注的是传递变化情况。源头发现变化，传递到其他地方。
- CSP 关注的是系统解耦。进程之间用 channel 传递信息。

两者关注的是不同层次的抽象

---

> Events complect communication and flow of control.

事件机制（包括 FRP）在复杂之后，就会出现 communication 和 flow control 混杂的情况。

作者的逻辑是这样的
- 缺少 thread 的支持，所以转向 events
- 使用 FRP 等许多机制，让 events 更加清晰
- 一个事件触发未知个数的代码块开始运行，这样不好
    - don't do too much work in your handler
