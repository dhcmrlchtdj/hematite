merge sort
- divede arry to two halve
- recursively sort each half
- merge two halves

program best practices
- use assertions to check internal invariants
- assume assertions will be disabled in production code

merge sort
- 二分后可以变成一个高度为 lgN 的树，树的每一层都执行 O(N) 次操作，所以总操作为 O(NlgN) 次
- 不是原地排序时，空间使用与 N 成正比，理论上可以实现原地排序，不过比较麻烦，不实用
- 对输入没有依赖，即使是个逆序数组，一样很快
- 优化：对于较小的数据，直接使用插入排序（比如小于 7 个
- 优化：对比一下左边最大和右边最小，如果已经有序就可以不管了

bottom-up mergesort
- 自底向上实现，不需要递归而且实现也比较简单
- 普通的 mergesort 是大的二分，自底向上是 2/4/8/16/... 这样往大了聚合


first goal of algorithm design: optimal algorithm

stable
- 一组联系人，先按电话排序，再按姓名排序。
    如果此时一个人的多个电话还是有序的，那么这个排序就是稳定的。
- preserve the relative order of items with equal keys
- insertion/mergesort 都是稳定的，selection/shellsort 都是不稳定

---

quicksort
- shuffle array
- partition for j, a[j] in place
    - no larger entry at left
    - no smaller entry at right
- sort each piece recursively

quicksort
- 原地交换避免了额外的空间。使用额外空间可以保证稳定，但是不值得
- 需要进行乱序来保证性能

quicksort
- 理论上，平均来说比 mergesort 慢，因为比较次数更多
- 实践来看比 mergesort 快，因为数据移动的次数少了
- 乱序可以避免出现最糟的情况

quicksort
- 优化：小数组使用插入排序（小于 10 个
- 优化：中点选择上，随机选 3 个数，取中位数

duplicate keys
- 很多数据里，是有重复值的
    - 很影响 quicksort 的性能，除非取的中点正好是重复的这个值
    - mergesort 不受影响
- 使用 3-way partitioning 来处理这个问题

---

find Kth smallest item
- k=0, k=N-1, k=N/2, ...
- 可以使用前面的 partition 的方法
- 二分后，只需要考虑其中一边，另外半边可以抛弃

---

which one to choose
- internal sort
    - insertion sort, selection sort, bubble sort, shaker sort
    - quicksort, mergesort, heapsort, samplesort, shellsort
    - solitaire sort, red-black sort, splaysort, yaroslavskiy sort, psort
- external sort
    - poly-phase mergesort, cascade-merge, osillating sort
- string/radix sort
    - distribution, msd, lsd, 3-way string quicksort
- parallel sort
    - bitonic sort, batcher even-odd sort
    - smooth sort, cube sort, column sort
    - gpusort
