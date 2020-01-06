# incremental dom

---

https://medium.com/google-developers/introducing-incremental-dom-e98f79ce2c5f
https://github.com/google/incremental-dom/tree/0.1.0

---

（后续版本都面目全非了，先看了眼 0.1.0

思路上是 vdom 到 dom，不是 reactive。
不知道要修改什么，直接遍历整个 dom 树，直接进行各种增删改。

使用了 `insertBefore`，有 key 的元素会被直接移动。
在渲染列表的时候，靠这种方式构造出所有需要的节点，然后从尾部将不要的全部删除。
这样确实简化了代码，无脑 `insertBefore` 就好。

对于 vdom 常见的另一个假设，tag 比较，也是一样的。
没有做什么特别的处理，就是按照 `elementOpen/elementClose` 该写写该删删。
