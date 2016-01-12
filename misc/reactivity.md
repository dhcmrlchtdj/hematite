# reactivity

---

https://github.com/kriskowal/gtor

---

|                  | Singular         | Plural              |
| ---------------- | ---------------- | ------------------- |
| sync / Spatial   | `Value`          | `Iterable<Value>`   |
| async / Temporal | `Promise<Value>` | `Observable<Value>` |

---

|                            | getter   | setter    |
| -------------------------- | -------- | --------- |
| Value                      | getter   | setter    |
| Iterable<Value> / array    | iterator | generator |
| Promise<Value> / deferred  | promise  | resolver  |
| Observable<Value> / stream | reader   | writer    |

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

+ a generator function returns an iterator. `Iteration<T>`
+ a asynchronous function returns a promise. `Promise<T>`
+ a asynchronous generator function return a promise iterator. `Promise<Iteration<T>>`
+ an iterator returns an iteration, but a promise iterator returns a promise for an iteration.
