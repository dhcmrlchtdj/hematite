# frecency algorithm

---

https://zhuanlan.zhihu.com/p/50548459
https://github.com/rupa/z
https://developer.mozilla.org/en-US/docs/Mozilla/Tech/Places/Frecency_algorithm

---

> "frecency" is a concept that combines of frequency and recency.

看到 z.sh / firefox 在使用这个算法，觉得挺有意思。
用于记录历史访问情况，做自动不全。

---

数据存储

- 只需要存储三个数据：`path / rank / time`
- 每次访问 path 时 `rank = rank + 1`
- rank 总和超过 9000 时，执行 aging 算法，`rank = rank * 0.99`
- 自动删除 `rank < 1` 的 path
- 自动删除已失效的 path

---

路径匹配

```sh
function frecent(rank, time) {
    # relate frequency and time
    dx = t - time
    if( dx < 3600 ) return rank * 4
    if( dx < 86400 ) return rank * 2
    if( dx < 604800 ) return rank / 2
    return rank / 4
}
```

根据 time 对 rank 进行加权计算
选择 rank 最大的那个 path

---

上面是介绍的 z.sh
和 firefox 的区别，更多是使用场景

> Range 1: 0-4 days (Weight 1.0) Range 2: 5-14 days (Weight 0.7) Range 3: 15-31 days (Weight 0.5) Range 4: 32-90 days (Weight 0.3) Range 5: 91+ days (Weight 0.1)
> Starred pages get a 40% bonus, bookmarks get a 100% bonus.
