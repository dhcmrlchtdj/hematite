# reactivity

---

https://github.com/kriskowal/gtor

---

|                  | Singular         | Plural              |
| ---------------- | ---------------- | ------------------- |
| sync / Spatial   | `Value`          | `Iterable<Value>`   |
| async / Temporal | `Promise<Value>` | `Observable<Value>` |

单值／多值 在 空间／时间 上的表现形式

---

## Concepts

---

|                            | getter   | setter    |
| -------------------------- | -------- | --------- |
| Value                      | getter   | setter    |
| Iterable<Value> / array    | iterator | generator |
| Promise<Value> / deferred  | promise  | resolver  |
| Observable<Value> / stream | reader   | writer    |

前述的四种类型，对应的 getter 和 setter

---

singular reactive value

|             | unicast(cancelable) | broadcast |
| ----------- | ------------------- | --------- |
| strong type |                     | future    |
| weak type   | task                | promise   |

---

plural reactive value

|         | unicast(cancelable) | broadcast            |
| ------- | ------------------- | -------------------- |
| one-way |                     | publisher/subscriber |
| two-way | productor/consumer  |                      |

productor 会缓存数据等待 consumer 读取，但 publisher 不会等待 subscriber 出现

+ discrete - push
+ continuous - pull/poll

离散性数据适合推送，连续性数据适合拉取或轮询

---

## Primitives

---

前面讲了分类和概念，下面分析每种 primitive

---

### iterator

+ iterator 是同步的
+ iterator 的返回值叫做 iteration，包含值和是否完成 { value, done }
+ generator function 的返回值是 iterator，生成器返回迭代器
+ iterator 是 lazy，而 array 是 eager

---

### generator functions

+ generators 和 iterators 都是 unicast 的
+ iterator 可以通过 `.next()` `.throw()` 向 generator 传递信息

---

### asynchronous values

+ promise / resolver / deferred，读／写／统称
+ resolver 可以理解为只有一个返回值的 generator，可以 return/throw，
    只有一个返回值，自然就没有 yield 了。
---

### asynchronous functions

+ 将 promise 和 generator functions 结合起来，可以模拟 asynchronous functions。
    （指的是 async/await 那种形式）

---

### promise queues

+ 通常意义上的队列，需要队列中先有元素才能进行读取
+ promise queue 在每次被读取时都返回一个 promise，所以读取可以先于写入
+ 返回的是 promise，所以多次读取的时候，可能出现后读取的 promise 先返回的情况
+ 按我理解，stream 主要特点之一就是多返回值，这里用了其他方式实现了时间纬度的多返回值

| value        | getter    | setter    |
| ------------ | --------- | --------- |
| PromiseQueue | queue.get | queue.set |

+ 实现上可以用队列存储所有待处理的 promise。
    每次 get 都新增一个 promise，每次 set 都解析一个 promise。

---

### semaphores

+ 信号量用于控制数据的读写权限，是阻塞的
+ 在反应式编程中，不会采取阻塞的做法，而会采用非阻塞的 promise
+ 可以用 promise 来模拟 mutex，用 promise queue 模拟 semaphore。
+ 在 promise resolve 的时候，就相当于拿到了锁。
    在模拟 semaphore 的时候，promise queue 中 resolve 的 promise 是固定的。
    每次操作消耗一个 promise，操作结束之后再将 queue 中的下一个 promose 给 resolve 了。

---

### promise buffers

+ 如果要实现一个 producer-consumer 的模型，可以将 promise queue 用于数据缓存。
+ productor 生成数据后，放到名为 buffer 的 promise queue 中，然后 consumer 从 buffer 中读取数据。
+ 再添加另一个 promise queue，每次 consumer 读取时都往里面添加一个 promise。
    productor 就可以通过这个队列判断 consumer 读取了多少数据
+ stream 的场景之一，就是 producer-consumer
+ 在 promise 中可以将 defer 隐藏起来，只给出 resolve/reject，返回一个 promise。
    在 stream 中也可以将 buffer 隐藏起来，只给出 write/close/abort，返回一个 read stream。

| value          | getter           | setter            |
| -------------- | ---------------- | ----------------- |
| promise buffer | promise iterator | promise generator |
