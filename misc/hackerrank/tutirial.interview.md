# data structure

---

## array && arraylist

https://en.wikipedia.org/wiki/Dynamic_array

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

https://github.com/facebook/folly/blob/master/folly/docs/FBVector.md#memory-handling

facebook 说 a=2 对内存分配不友好
a=2:	10,		20,		40,			80
a=1.3:	0,		13,		17(16.9),	23(22.1)
上面是简化的 a=2 和 a=1.3 时的情况
a=1.3 在分配 23 时，可以重用前面 10/13 释放的内存
而 a=2 永远不可能进行这种重用，总是必须申请更多内存

---

## hash

hash table 相关的太多了
不过接触更多的好像都是 hash function 实现，tree 实现的接触的少

首先会有 hash function 选择的问题
然后就是如何处理冲突，链表算比较简单的，还有 open addressing
open addressing 可以各种线性、非线性地增加下标，还有二次 hash 啥的

hash 里有个 load factor = n/k 的概念，即 k 个桶装了 n 个实体
越大则取值越慢，过小则说明浪费空间

为了保持 load factor 处在合适的值（比如 py 是 2/3，java 是 3/4）
实现时会对桶的数量进行动态调整（比如用 arraylist 来作为底层实现）
调整时可能会直接创建新列表后全量复制，也可以创建列表并在各种操作时慢慢复制，等等等等

---

## linked list && stack && queue

Singly-Linked List
Doubly-Linked List

FILO, peek/push/pop
FIFO, enqueue/dequeue

---

## heap

max heap / min heap
插入时，在最后一位插入，然后调整到合适位置
取出时，取出后把最后一位拿到开头，再调整到合适位置

可用数组表示
parent = (index - 2) / 2
left child = index * 2 + 1
right child = index * 2 + 2

---

## tree

binary tree
binary search tree
balanced binary search tree

---

## trie

---

# summary

一轮题目做下来
最明显的问题，时间摊派
把耗时操作分散到其他地方，比如输出结果耗时，就在输入时摊派计算量

另外就是 python 内存爆炸……靠 `__slots__` 救了回来……跪了
还是需要一个提示更强，编写方便的语言，rust ？

---

# algorithm

---

## bit manipulation

`2,8,10,16`，各种进制的表示、转换
`&,|,^,~,<<,>>`，各种位操作

---

## recursion

使用 memorization
使用 iteration 改写 recursion

---

## big O

+ different steps get added
+ drop constants
+ different inputs => different variables
+ drop non-dominate terms

复杂的分析还是多学习哈

---

## DP

DP
greedy

---

## sort

---

## binary search

O(logN)

---

## tree

DFS/BFS/...
