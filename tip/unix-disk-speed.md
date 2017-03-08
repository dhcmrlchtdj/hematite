# disk speed

---

https://wiki.archlinux.org/index.php/Benchmarking/Data_storage_devices

---

经常看到别人用 `dd` 测试 vps 的硬盘。
看了下 arch wiki，hdparm 更简单些吧。

```
Timing cached reads:   17270 MB in  2.00 seconds = 8640.54 MB/sec
Timing buffered disk reads: 1948 MB in  3.00 seconds = 648.71 MB/sec
```

```
Timing cached reads:   9156 MB in  2.00 seconds = 4580.68 MB/sec
Timing buffered disk reads: 640 MB in  3.01 seconds = 212.55 MB/sec
```

对比一下，hostigation 的性能太悲剧了。
感觉是刚才在 vps 面板里玩坏了……
