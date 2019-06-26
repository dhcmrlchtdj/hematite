# latency

看 https://www.fastly.com/blog/lucet-performance-and-lifecycle 的时候是懵的。

```
30µs for instantiation
5µs for context switching
23µs for destruction
```

多少延迟对标什么操作，没有概念。

---

https://gist.github.com/jboner/2841832

- CPU 操作是 ns 级别的
    - L1 ~ 0.5ns
    - L2 ~ 7ns
    - mutex ~ 25ns
    - memory reference ~ 100ns
- 4K SSD，1M 内存，1K 网络传输，这是 us 级别的
    - compress 1K memory ~ 3us
    - send 1K over network ~ 10us
    - randomly 4K SSD ~ 150us
    - sequentially 1M memory ~ 250us
    - sequentially 1M SSD ~ 1ms
    - sequentially 1M disk ~ 20ms
- 网络与硬盘
    - round trip within datacenter ~ 500ms
    - disk seek ~ 10 ms
- 读 1M 数据
    - sequentially 1M memory ~ 250us
    - sequentially 1M SSD ~ 1ms
    - sequentially 1M disk ~ 20ms

---

对照上面的数据，好像也只能得出 lucet 全是内存操作这个结论……
