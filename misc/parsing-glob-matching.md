# glob matching

---

https://research.swtch.com/glob
https://research.swtch.com/glob.go

---

关于如何正确实现 shell 的 glob 匹配。

---

> translate the glob pattern to a regular expression and then invoke a
> linear-time regular expression match.

简单点就转换成正则，然后就看正则的效率了。
如果正则实现符合预期，就能实现线性时间的匹配。

---

> Because * is the only variable-sized wildcard in the pattern syntax and
> therefore the only source of possible backtracking, there’s an even easier
> implementation: don’t backtrack to an earlier star.

出现 `*` 的时候记录当前位置。
如果碰到下个 `*`，记住下个 `*` 的位置就可以了，可以认为前面那个 `*` 的工作已经完成了。
