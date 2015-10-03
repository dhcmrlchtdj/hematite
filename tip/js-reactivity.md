# reactivity

---

https://github.com/kriskowal/gtor

---

|          | Singular         | Plural              |
| -------- | ---------------- | ------------------- |
| Spatial  | `Value`          | `Iterable<Value>`   |
| Temporal | `Promise<Value>` | `Observable<Value>` |

---

|                            | getter   | setter    |
| -------------------------- | -------- | --------- |
| Value                      | getter   | setter    |
| Iterable<Value> / array    | iterator | generator |
| Promise<Value> / deferred  | promise  | resolver  |
| Observable<Value> / stream | reader   | writer    |

---

singular reactive value

|             | unicast | broadcast |
| ----------- | ------- | --------- |
| strong type |         | future    |
| weak type   | task    | promise   |

---

plural reactive value

|         | unicast            | broadcast            |
| ------- | ------------------ | -------------------- |
| one-way |                    | publisher/subscriber |
| two-way | productor/consumer |                      |

productor 会缓存数据等待 consumer 读取，但 publisher 不会等待 subscriber 出现

+ discrete - push
+ continuous - pull/poll

离散性数据适合推送，连续性数据适合拉取或轮询

---
