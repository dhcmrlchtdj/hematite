# algorithm

6.006

---

## Introduction

---

### Algorithmic Thinking, Peak Finding

---

- 1D array, peak of array
- 2D array, peak of matrix

- divide and conquer
    - T(1) = O(1), T(N) = T(N/2) + O(1);
    - T(N) = T(N/(2^i)) + i*O(1);
    - N/(2^i) = 1 => i = log2N;
    - T(N) = T(1) + log2N*O(1);
    - T(N) = O(log2N)

---

### Models of Computation, Python Cost Model, Document Distance

---

- model of computation
    - cost of algorithm = sum of operations costs
- RAM and Pointer Machine

- document distance
    - two string list
    - two vector
    - angular distance, arccos(inner_product(L1,L2)/(sqrt(inner_product(L1,L1)*inner_product(L2,L2))))
    - Euclidean distance, sqrt(sum(pow2(Pi-Qi)))
    - cosine similarity, sum(Ai*Bi)/((sqrt(sum(pow2(Ai))))*(sqrt(sum(pow2(Bi)))))

---

## Sorting and Trees

---

### Insertion Sort, Merge Sort

---

- problems that become easy once items are in sorted order

- insertion sort
    - compare A[i] with A[i-1], A[i-2], ..., A[0]
    - A[0]...A[i-1] is sorted, so we can use binary search to compare
    - binary insertion sort
        - O(logN) for compare, O(n) for swap
- selection sort
- bubble sort

- merge sort
    - split && merge
    - T(N) = 2T(N/2) + cN
        - height = 1 + lgN

- recurrence complexity
    - `1 + 1/2 + 1/4 + ... < 2`
    - T(N) = 2T(N/2) + cN => O(NlgN)
    - T(N) = 2T(N/2) + c => O(N), leave=N
    - T(N) = 2T(N/2) + cN^2 => O(N^2), root=N^2

- in-place sort is better than merge sort in auxiliary space usage

---

### Heaps and Heap Sort

---

- priority queue
- heap
    - array
    - nearly complete binary tree
    - parent(i)=i/2; left(i)=2i; right(i)=2i+1
    - complexity
        - heapify, O(lgN)
        - build_heap, O(NlgN)
- heap sort
    - build heap
    - swap(A[0],A[N])
    - heapify(A[0, N-1])
    - swap, heapify, swap, heapify

---

### Binary Search Trees, BST Sort

---

- BST
    - height, H
    - complexity
        - search, O(H)
        - insert, O(H)

---

### AVL Trees, AVL Sort

---

- BST, height, H
- AVL
    - property, `abs(Hleft - Hright) <= 1`
        - not about leaves
        - about height of subtree
    - insert
        - simple BST insert
        - fix AVL perperty
            - 新插入的节点，要么直接满足 AVL property
            - 不满足，就 rotation，一直向上，直到全部满足 AVL property
- rotation

```
left_rotate(x) x 变成 y 的左子树

  x                           y
 / \    left_rotate(x)->     / \
A   y   <-right_rotate(y)   x   C
   / \                     / \
  B   C                   A   B
```

```python
def height(node):
    if node is None:
        return -1
    else:
        return node.height

def rebalance(self, node):
    while node is not None:
        node.height = max(height(node.left), height(node.right)) + 1
        if height(node.left) >= 2 + height(node.right):
            if height(node.left.left) >= height(node.left.right):
                self.right_rotate(node)
            else:
                self.left_rotate(node.left)
                self.right_rotate(node)
        elif height(node.right) >= 2 + height(node.left):
            if height(node.right.right) >= height(node.right.left):
                self.left_rotate(node)
            else:
                self.right_rotate(node.right)
                self.left_rotate(node)
        node = node.parent
```

- AVL sort, O(NlgN)
    - build AVL tree, O(NlgN)
    - in-order traversal, O(N)

---

- abstract data type (ADT): interface specification
- data structure (DS): algorithm for each operations
- priority queue is ADT, heap/AVL is DS

---

### Counting Sort, Radix Sort, Lower Bounds for Sorting and Searching

---

- comparision model
- decision tree, binary decision tree
    - lower bounds
        - searching, lgN
        - sorting, NlgN
- linear-time sorting for integer
    - O(n) for small integer
    - counting sort (not what we want)
        - RAM
        - A[0...N] => map[Ai] => sortedA[0, N]
        - 根据数组内容（最大值），用数组构造了一个 map
        - 比如 Ai 出现了 2 次，就可以有 map[Ai] = [Ai,Ai]
        - 根据 map 输出排序后的数组
        - 但是数字如果很大，array 就会很大了。
    - radix sort
        - use counting sort as subroutine
        - 对每一位进行排序，只会有 0~9，所以数组本身能够很小
        - 每次排序其实都依赖于之前排序的结果，所以 subroutine 必须是 stable 的

---

> A sorting algorithm is **stable** if elements with the same key appear in the
> output array in the same order as they do in the input array.

---

## Hashing

---

### Hashing with Chaining

---

- dictionary
- simple approach: direct-access table
    - store items in an array, indexed by key
    - prehash, map keys to integers
    - hashing, reduce all keys down to reasonable size M for table
        - hash function
        - collision
            - chaining
            - open addressing
- chaining
- simple uniform hashing (assumption)
    - n = count(keys)
    - m = count(slots)
    - load factor A = n / m
        - expected keys count per slot
        - expected length of a chain
    - time complexity for searching, O(1+A)
- hash function
    - division, h(k) = k mod m
        - m must be prime
    - multiplication, h(k) = [(a*k) mod 2^w] >> (w-r)
        - k is w bit integer
        - r can be any integer which less than w
        - m = 2^r
        - 看课件的图会容易理解一些
    - universal hashing, h(k) = [(ak+b) mod p] mod m
        - p is large prime which larger than any k
        - a and b are random integer which less than p

---

### Table Doubling, Karp-Rabin

---

- how to choose m (how large should table be)
    - want m = O(n); m too small => slow; m too big => wasteful
    - start small constant, grow or shrink as necessary
    - rehashing, move all items from old table to new table
- amortized analysis
    - operation has amortized cost T(N)
        if k operations cost less than or equal to kT(N)
- resizable arrays
    - 感觉，n/m=2/3 => m'=m/2*3; n/m=1/3 => m'=m*2/3 比较好点？

---

- string matching
    - does S occur as substring of T?
- simple algorithm
    - time complexity O(|S| * |T|)
    - O(|S|) for each comparision
    - compare O(|T| - |S|) times
- karp-rabin algorithm
    - compare by hash
    - 利用 hash，让 compare 从 O(|S|) 变成 O(1)
    - 计算 hash 本身还是一个 O(|S|) 的操作
    - 选择合适的 hash function (rolling hash) 能够进一步简化 hash 的计算
        - 比如计算 abcde 和 bcdef 的 hash，中间 bcde 可以不重复计算
    - H = C1*A^(k-1) + C2*A^(k-2) + ... + C(k-1)*A^1 + Ck*A^0
        - C 是每一位的 char
        - A 可以理解成进制（比如 ascii 可以当成 256 进制？）
        - append(C) => H*A + C
        - dropHead(C) => H - C*A^(k-1)
        - 这个算 prehash，结果可能很大。不过其实只是为了比较，也没什么关系吧？

---

### Open Addressing, Cryptographic Hashing

---

- open addressing
    - one item per slot
    - probing strategy
        - linear probing
            - cluster
        - double hashing
    - uniform hash assumption
        - each key is equally like to have any one of the m! permutations as its
            probe sequence.
        - (not really true

- open addressing: better cache performance (better memory usage, no pointer needed)
- chaining: less sensitive to hash functions and the load factor

---

- cryptographic hashing
    - a deterministic procedure that takes an arbitrary block of data and
        returns a fixed-size bit string, the (cryptographic) hash value
    - desirable property
        - one-way
        - collsion-resistance
        - target collsion-resistance

---

## Numerics

---

### Integer Arithmetic, Karatsuba Multiplication
### Square Roots, Newton's Method

---

- irrational
- 卡特兰数 catalan number
- 不懂……

---

- newton's method
    - Xi+1 = Xi - F(Xi)/F'(Xi)

- high precision multiply
    - karatsuba's method
    - 不懂

- 不懂

---

## Graphs

---

### Breadth-First Search (BFS)

---



---

### Depth-First Search (DFS), Topological Sorting

---



---

## Shortest Paths

---

### Single-Source Shortest Paths Problem
### Dijkstra
### Bellman-Ford
### Speeding up Dijkstra
#### Quiz 2 Review

---

## Dynamic Programming
### Memoization, Subproblems, Guessing, Bottom-up; Fibonacci, Shortest Paths
### Parent Pointers; Text Justification, Perfect-Information Blackjack
### String Subproblems, Pseudopolynomial Time; Parenthesization, Edit Distance, Knapsack
### Two Kinds of Guessing; Piano/Guitar Fingering, Tetris Training, Super Mario Bros.

---

## Advanced Topics
### Computational Complexity
### Algorithms Research Topics
