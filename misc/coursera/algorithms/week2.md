stack, lifo
queue, fifo
madule programming style, separete interface and implements

---

resize array

## s1
- push / double size when array is full
- pop / halve size when array is one-half full
- 上面这种策略在减半后很可能马上要增加，效率太差

## s2
- push / double size when array is full
- pop / halve size when array is one-quarter full

## amortized analysis

## resizing array vs linked list
- linked-list
	- 每次操作都只需要常数的时间
	- 额外的空间和时间来维护列表
- resizing-array
	- 每次操作在分摊后基本为常数
	- 不怎么浪费空间

---

generics
iterators

---

