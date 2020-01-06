# CouchDB

前一段时间，不知道为何会接触到 PouchDB，然后就接触到了 CouchDB。
CouchDB 支持多副本同步，保证最终一致性。

我一开始的疑问是怎么处理冲突的？架构上是单主？多主？还是无主？

- http://docs.couchdb.org/en/stable/replication/conflicts.html#conflict-avoidance
- http://guide.couchdb.org/draft/conflicts.html
- https://pouchdb.com/guides/conflicts.html

结果，所有资料都表面，我们需要自己手动处理冲突……

---

> CouchDB will choose an arbitrary winner based on a deterministic algorithm
> since the replication history is stored, you can always go back in time to resolve the conflict.

- CouchDB 是 multi-master 架构。
- 发生冲突的时候，所有冲突的版本都会留在历史记录里。（就像 git 的不同分支）
- 发现数据不对了，需要用户自己去历史记录里选个正确的。
- 太粗暴了……

> Each revision includes a list of previous revisions.
> The revision with the longest revision history list becomes the winning revision.
> If they are the same, the _rev values are compared in ASCII sort order, and the highest wins.

- 这个冲突合并算法，也非常简陋……

---

我觉得吧，未来是 new SQL 的。CouchDB 这样子，洗洗睡吧……
