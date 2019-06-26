# Event Sourcing

---

https://docs.microsoft.com/en-us/azure/architecture/patterns/event-sourcing
https://docs.microsoft.com/en-us/azure/architecture/patterns/cqrs

---

自己目前做的事情，都只需要 CRUD 就能搞定，但还是了解下吧。

---

ES 和 CQRS 经常被放到一起说。

按顺序的话，首先是 CQRS。
用户的操作指令到服务器，服务器将变化的内容记录到 ES，再由 ES 更新另一个存储（比如 MySQL）。
用户的查询指令到服务器，直接到另一个存储读取最新的状态。

感觉上是不是和 SSTable 很像呢。
操作都是 append-only 的，然后定期的合并方便读取。

---

比起直接 CRUD，搞 ES/CQRS 的优势是什么呢？为什么要搞呢？
一个好处应该是可以重放，中间可以随便截取一段什么的。
不同用户的操作，可以先一起记录，后面再慢慢处理冲突的问题。

我的疑问也就在这里了，多用户冲突了的话，要怎么办呢？
ES 到读取的持久化是需要时间的吧，这样的话，用户无法马上知道自己的操作成功还是失败了？
需要额外的通知机制？

---

复杂度确实高出了不少
