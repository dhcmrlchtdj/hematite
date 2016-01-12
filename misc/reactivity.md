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
