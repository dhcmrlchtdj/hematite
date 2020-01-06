# java tutorial

---

## concurrency

https://docs.oracle.com/javase/tutorial/essential/concurrency/index.html

- create thread
    - `class R:Runnable {override fun run()=println("implement Runnable")};Thread(R()).start()`
    - `class T:Thread() {override fun run()=println("extend Thread")};T().start()`
- synchronization
    - `synchronized` keyword
        - block the same method on the same object
        - happens-before relationship, changes to the state of the object are visible to all threads
    - `synchronized` statement
- liveness
    - deadlock
    - livelock
    - starvation 并发度太低
- immutable
- collection
    - BlockingQueue
    - ConcurrentHashMap
    - ConcurrentSkipListMap
- executor
    - thread pools
    - fork-join

---

## IO
https://docs.oracle.com/javase/tutorial/essential/io/index.html



