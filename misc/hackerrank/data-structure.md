## link list

https://www.hackerrank.com/challenges/detect-whether-a-linked-list-contains-a-cycle
单个链表出现循环的地方
快慢指针


https://www.hackerrank.com/challenges/get-the-value-of-the-node-at-a-specific-position-from-the-tail
一个单向链表
要求 O(N) 复杂度
倒数第 x 个元素
快慢指针


https://www.hackerrank.com/challenges/find-the-merge-point-of-two-joined-linked-lists
两个链表的交点
http://stackoverflow.com/questions/1594061/check-if-two-linked-lists-merge-if-so-where/14956113#14956113
自己和自己头尾相连，慢慢遍历，迟早也会相交，但是效率太差
A 尾接 B 头，B 尾接 A 头，遍历效率会提升很多，因为连接后总长度一致啊
想了想，不要求空间复杂度，直接上字典呀

SO 上还有种方法
先遍历 A B 长度，然后较长的那个先减去差值
这样 A B 的两个指针距离交点的长度就相同了

## stack

https://www.hackerrank.com/challenges/waiter
这题的问题不是 stack，而是 Nth prime

需要估计第 N 个质数是什么，有一个素数定理
p(n) ~ n*ln(n)，第 n 个素数接近于 n*ln(n)

测试了一下，n 越小偏差越大
比如 n 为一百时，需要 n*ln(n)*1.2 才能保证个数
比如 n 为千万时，需要 n*ln(n)*1.15 才能保证个数
比如 n 为万亿时，需要 n*ln(n)*1.11 才能保证个数

数据量不大直接算也不慢，直接慢慢算算了


https://www.hackerrank.com/challenges/largest-rectangle
https://www.hackerrank.com/challenges/and-xor-or
两道题目应该属于一样的问题，我都不会，这才是 stack 该出现的问题吧
大意都是要找到一个区间，然后需要两个端点参与计算，问题就是如何确认端点在哪里
感觉像是规划类的题目
