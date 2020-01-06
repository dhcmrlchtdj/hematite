# tcpdump dns

---

http://nil.uniza.sk/linux-howto/using-tcpdump-diagnostic-dns-debian

---

突然发现 119.29.29.29 的 DNS 坏了，不能解析 v2ex.com。
跑到 VPS 上测试了下，发现 VPS 上又正常。
本地加上 trace 看了下，这样是能正常返回结果的。

所以，问题在哪……
上 tcpdump 看了下。

```
$ tcpdump -vvv -nt port 53
... [udp sum ok] 40652 ServFail q: A? v2ex.com. 0/0/0 (26)
```

ServFail 是什么鬼……
