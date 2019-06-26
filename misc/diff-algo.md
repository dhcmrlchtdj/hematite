# diff algorithm

---

http://prettydiff.com/guide/unrelated_diff.xhtml
https://news.ycombinator.com/item?id=13983085
https://gist.github.com/ndarville/3166060

---

- identify as much equality as possible

---

### algorithm quality

- precision
- speed
- code simplicity

---

### speed

- reduce the number of passes through data
    - PrettyDiff has 3 passes

---

### output

```
output := [ item, ... ]
item   := { type, start1, end1, start2, end2 }
type   := "equal" | "replace" | "insert" | "delete"
```

---

### algorithm

- 输入数组 `newArr` 和 `oldArr`
- 构造字典 `dict`
- 遍历输入
    - 所有相同的，`equal`
    - 所有完全不同的，`replace`
    - 只在 `oldArr` 出现的，`delete`
    - 只在 `newArr` 出现的，`insert`
    - 在 `oldArr` 出现次数更多的，`delete`
    - 在 `newArr` 出现次数更多的，`insert`
    - 出现多次的属于替换，`replace`
- 优化输出
    - 相邻且类型相同的操作合并
    - 插入删除相邻，换成替换操作
    - 空替换能否与相邻的插入删除合并
