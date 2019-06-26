# tcpflow

---

调试代码的时候，想看接口传输的数据，奈何 tcpdump 太不直观。
然后找到了 tcpflow。

---

```
$ tcpflow -cp -i lo port 9000
```
