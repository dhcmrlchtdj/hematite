# go scheduler

---

https://rakyll.org/scheduler/

- work-sharing, worker 被动接收任务
- work-stealing, worker 主动去其他 worker 那边分担任务
- go 1.1 scheduler (use work-stealing)
    - global goroutine queue
    - local goroutine queue (each process)
    - OS thread
    - processor
        - max = GOMAXPROCS
        - one processor may have zero or more OS thread
        - at any time, only one OS thread is runing (per processor)

---

https://morsmachine.dk/go-scheduler

- a M:N scheduler
    - G, goroutine
    - M, OS thread
    - P, processor (context)
        - only GOMAXPROCS are running Go code at any point
        - global runqueue + local runqueue (each context)
        - (local runqueue) bring down mutex contention
- why context (processor)
    - hand context off to other threads when the running thread blocked
        - for example, waiting for system call
        - when the system call returns, the thread must try and get a context in order to return the goroutine
            - steal a context from other threads
            - or, put the goroutine to global queue
        - （听着像是 context 只是保存 runqueue
        - （要尽量避免 system call？否则需要大量 thread？
- contexts periodically check the global runqueue for goroutines
    - 不仅仅读取 local runqueue
- when a context runs out, it will try to steal about half of the runqueue from another context

---

https://github.com/tiancaiamao/go-internals/blob/master/zh/05.3.md

- 线程池 + 任务队列
- 运作中的 M + 陷入系统调用的 M

---

https://docs.google.com/document/d/1TTj4T2JO42uD5ID9e89oa0sLKhJYD0Y_kqxDv3I3XMw
https://github.com/golang/go/blob/release-branch.go1.1/src/pkg/runtime/proc.c

- 呃……
