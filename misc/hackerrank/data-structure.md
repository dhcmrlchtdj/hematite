# data structure

---

## array && arraylist

https://en.wikipedia.org/wiki/Dynamic_array
https://github.com/facebook/folly/blob/master/folly/docs/FBVector.md#memory-handling

array 是定长的不说了
arraylist 还是数组不是链表，不过加上了扩容的机制

当长度为 N 的数组存储了 M 个元素时，会自动伸缩数组长度。
M 接近 N，可以增大 N
M 接近 0，可以减少 N
伸缩实际上把整个数组复制到了一个新数组里，所以是有性能损失的

关于 arraylist 的性能
保证插入 n 个元素的时间是 O(n)
所以平摊后每次插入仍可算是 O(1) 的（平摊分析，amortized analysis

关于何时对 N 进行伸缩，伸缩多少，看怎么取舍了
growth factor 为 a 时，浪费的空间是 (a-1)/n，每次插入的耗时为 a/(a-1)
比如常见的 a=2, a=1.5，还有 py 奇葩的 (n + n >> 3)，大约是 a=1.125

facebook 说 a=2 对内存分配不友好
a=2:	10,		20,		40,			80
a=1.3:	0,		13,		17(16.9),	23(22.1)
上面是简化的 a=2 和 a=1.3 时的情况
a=1.3 在分配 23 时，可以重用前面 10/13 释放的内存
而 a=2 永远不可能进行这种重用，总是必须申请更多内存

---
