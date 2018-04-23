# virtual dom 3

---

https://github.com/infernojs/inferno/issues/273

---

- 前面提到了 inferno 复杂的 patchKeyedChildren
- issue 里说到，snabbdom 的比较算法已经很好了，只是 DOM 操作略多
- inferno 用到的算法则是整合了许多算法实践的产物

- 这种复杂的代码，看 ivi 这样带注释的版本更易懂一些
- 实现和 inferno 应该是一样的

---

## ivi

---

https://github.com/ivijs/ivi/blob/dd4f3f3c92e1c758f5e3df2e803604bc071ce9cd/src/vdom/implementation.ts#L1416-L1966

---

> This algorithm finds a minimum number of DOM operations

该算法的目标，是 DOM 操作最小化。（虽然还是在部分边缘情况做了妥协）

整个过程分了三步

---

### step 1

> 1. Find common suffix and prefix, and perform simple moves on the edges.

遍历查找相同的首尾元素

---

输入如下，A 是旧的，B 是新的

```
A: -> [a b c d e f g] <-
B: -> [a b f d c g] <-

A: -> [b c d e f g] <-
B: -> [b f d c g] <-

A: -> [c d e f g] <-
B: -> [f d c g] <-

A: -> [c d e f] <-
B: -> [f d c] <-
```

首先，abg 都可以排除掉，不需要任何操作

```
A: -> [c d e f] <-
B: -> [f d c] <-

A: -> [d e f c] <-
B: -> [f d c] <-

A: -> [d e f] <-
B: -> [f d] <-

A: -> [f d e] <-
B: -> [f d] <-

A: -> [e] <-
B: -> [] <-
```

然后 cf 可以进行移动，移动后会发现 d 又可以继续排除

```
A: -> [e] <-
B: -> [] <-
```

例子里，B 已经空了，将 A 里剩下的全部移除即可。
如果是相反的情况，A 里面空了，那么 B 剩下的全部插入即可。

至于不能处理的复杂情况，就进入下一步处理。

---

### step 2

> 2. Look for removed and inserted nodes, and simultaneously check if one of the nodes is moved.

新插入的节点、被删除的节点、被移动的节点

---

```
A: -> [a b c d e f g] <-
B: -> [a c b h f e g] <-

A: -> [b c d e f] <-
B: -> [c b h f e] <-
```

对于如上输入，应用 step1 之后，得到不能处理的复杂情况。

后续的算法，就是典型的 diff 算法了呀。
（这样说来，其实一开始就可以用那些 diff 算法了呀。总之先往下讲

为 B 建立一个 key 到 index 的映射，然后遍历 A，可以知道 A 中元素是被移动或者删除了。
（这里没有处理新增的 case 呀

```
A: [b c d e f]
B: [c b h f e]

I: {
  c: 0,
  b: 1,
  h: 2,
  f: 3,
  e: 4,
}

P: [1 0 -1 4 3]
```

这里 I 是映射关系，P 是对 A 的移动。

---

### step 3

> 3. Find minimum number of moves if `moved` flag is on, or insert new nodes if the length is changed.

这步是对上一步结果的简化，减少 DOM 操作

---

这步的主要想法，使用 LIS 让移动的操作最少。

```
A: [b c d e f]
B: [c b h f e]
P: [1 0 -1 4 3]
LIS:      [1 4]
```

比如前面的 P，可以算出 LIS。
然后反向遍历，这个过程不太好描述……

---

### summary

总结一下，就是 diff 算法决定增删移，然后用 LIS 辅助减少移动次数。

---

## snabbdom

---

https://github.com/snabbdom/snabbdom/blob/v0.6.9/src/snabbdom.ts#L179-L249

---

- snabbdom 没有注释，不过有了前面的基础，其实就好懂了
- 一开始和 ivi 的 step1 是相同的，将头尾没变化的元素排除
- 剩下的元素里，对旧的列表建立索引
- 该新增新增，该删除删除，该移动移动
