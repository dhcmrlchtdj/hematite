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

bubble sort
- 和右边比较交换，结果上把最大的一个移动到最右边，即出去的是最大的
- 反向的 selection sort，但是交换次数多了

selection sort, find index of the smallest remaining entry
- 对新元素进行筛选，保证进来的是最小的
- running in quadratic time, even if input is sorted
- data movement is minimal, linear nuidurlber of exchanges

insertion sort, swap with each larger entry to left
- 随便进来一个，然后重新整理顺序
- 最好的情况是，输入为有序数组，对比和移动次数都会很少

shell sort, 
- 改进 insertion sort，每次不是移动一格
- 如何选取距离
	- 2^n - 1
	- 3x + 1, X(n) = X(n-1) * 3 + 1, X(0) = 0
	- empirical, 1, 5, 19, 41, 109, 209, 505, 929, 2161, 3905, ...

> https://www.zhihu.com/question/24637339/answer/84079774
> 假设我们要从小到大排序，一个数组中取两个元素如果前面比后面大，则为一个逆序，容易看出排序的本质就是消除逆序数
> 可以证明对于随机数组，逆序数是O(N^2)的
> 而如果采用“交换相邻元素”的办法来消除逆序，每次正好只消除一个，因此必须执行O(N^2)的交换次数
> 这就是为啥冒泡、插入等算法只能到平方级别的原因
> 反过来，基于交换元素的排序要想突破这个下界，必须执行一些比较，交换相隔比较远的元素，使得一次交换能消除一个以上的逆序
> 希尔、快排、堆排等等算法都是交换比较远的元素，只不过规则各不同罢了

---

shuffling
- 随机为元素附加一个值，然后对这个值进行排序
- 直接排序，比较函数随机返回结果，而不是根据实际大小
- knuth shuffle
	- 遍历并交换 A[i]/A[r]，其中 r 从 (0,i) 里随机挑选（均匀分布）
