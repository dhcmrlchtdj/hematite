# sequence number

---

最近看分布式的资料时，经常看到 sequence number。

- TCP 里用于判断消息的顺序
- RPC 里可以作为消息 ID（用法和 TCP 可以说是一致的
- Raft 里的 term 还有 log index，也都是数字

我的一个疑问是，这种序列号怎么存储？溢出了怎么办？

---

https://tools.ietf.org/html/rfc793#section-3.3

翻了下 TCP 的文档，TCP 的 sequence number 是 32bit 的，也就是 0~0xFFFFFFFF。

> Since the space is finite, all arithmetic dealing with sequence numbers must be performed modulo 2**32.
> This unsigned arithmetic preserves the relationship of sequence numbers as they cycle from 2**32 - 1 to 0 again.

通过取模，保证数值不会溢出。

不过，发送溢出的场景，怎么保证 seq 比较不出错呢？
如果用队列来缓存 TCP 包，那么第一个包的 seq 加上队列的长度，可以计算出后续 seq 的允许范围。

---

但 Raft 要怎么办，还没想明白。
等我自己实现一个再补上 😂
