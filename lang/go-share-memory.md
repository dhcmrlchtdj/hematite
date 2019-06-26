# Share Memory By Communicating

---

https://blog.golang.org/share-memory-by-communicating
https://golang.org/doc/effective_go.html#sharing
https://github.com/golang/go/wiki/MutexOrChannel

---

通常在多线程编程时，会通过 share memory 的方式通信
为了保证数据准确，会对数据加锁
（有时会使用有一些 thread-safe 的数据结构，比如 py 的 queue

---

在 go 里面，会通过 channel 在不同的 goroutine 之间传递数据
保证在同一时间，只有一个 goroutine 能够接触到数据

> Do not communicate by sharing memory; instead, share memory by communicating.

channel 控制了数据的传递、获取
（本身就类似于一把锁？

---

- channel
	- passing ownership of data
	- distributing units of work
	- communicating async results
- mutex
	- caches
	- state

在选择 channel 还是 mutex 这个问题上
官方很敷衍的说了一句，如果觉得当前的方案显得复杂，看下另一种方案会不会更简洁
