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
