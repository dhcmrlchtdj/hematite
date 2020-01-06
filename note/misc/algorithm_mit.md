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

- graph G = (V, E)
    - V = set of vertices
    - E = set of edges
        - directed / undirected

- graph representation
    - adjacency lists
        - map(vertexA, [edge from vertexA])
        - space complexity, O(V+E)
    - adjacency matrix
        - two dimension array
    - implicit graphs
    - object-oriented variations
    - incidence lists

- breadth-first search (BFS)
    - explore graph level by level
    - O(V+E) time
    - implementation
        - queue
        - seen mark
    - shortest path property (from root to vertex)

---

### Depth-First Search (DFS), Topological Sorting

---

- depth-first search (DFS)
    - recursively explore graph, backtracking as necessary
    - O(V+E) time
    - implementation
        - recursive
        - seen mark

- edge classification
    - tree edges (DFS visit order)
        - 按照 DFS 遍历的顺序，可以画出一颗树来
    - nontree edges
        - 非 tree 的边，可以继续分成三类（还是按照相对 tree 顺序来说的）
        - back edge: to ancestor
        - forward edge: to descendant
        - corss edge: to another subtree
        - 判断方法
            - 有个递增的全局变量 clock
            - 在开始遍历节点前记录 start=clock++，在完成遍历时记录 end=clock++
            - 如果指向了遍历中或遍历过的节点，可以通过 start end 判断出当前边属于哪种
    - only tree & back edges exist in undirected graph
        - 此时 forward 变成了 back
        - 此时 cross 变成了 tree

- cycle detection
    - graph G has a cycle === DFS has a back edge
    - (can be detected by seen mark with level?

- topological sort
    - run DFS then output reverse order = topological sort order

---

## Shortest Paths

---

### Single-Source Shortest Paths Problem

---

- weighted graphs
    - Graph = (Verteces, Edges, Weight)
    - shortest path algorithm: Dijkstra / Bellmen-Ford

- single source shortest paths
    - subpaths of shortest paths are shortest paths
    - DP，其实很符合直觉
    - 通常用 DFS

- negative-weight edges
    - wtf
    - might have negative weight cycles
    - Dijkstra 算法就不能处理这种情况

---

### Dijkstra

---

- shortest paths in DAGs
- shortest paths in graphs without negative edges

---

- Dijkstra
    - 有向图，单源最短路问题。起点到各个点的最短路。
    - BFS
    - 所有节点都对应一个距离，起点是 0，其他节点 ∞
    - 标记已处理的点和未处理的点
    - 取未处理的节点中，最小的那个点。处理该点所有的边，进行 relax 操作。然后将该节点标记为已处理。
    - 重复处理过程，直到所有节点处理完。

---

### Bellman-Ford

---

- 能够处理 negative edges
- 能够发现 negative-weight cycles（这种情况下是没有最短路的

---

- Bellman-Ford
    - 分成两步，第一步计算出起点到任意节点的最短路
        - 一开始起点是 0，起点节点是 ∞
        - 遍历所有的边 `(u, v)`，执行 `relax(u, v)`
            - `relax(u, v) => if d(v)>d(u)+w(u,v) then d(v)=d(u)+w(u,v)`
        - 上述操作重复执行 `|v|-1` 次
    - 第二步判断是否存在 negative-weight cycle
        - 遍历所有的边 `(u,v)`
        - 如果 `d(u) + w(u, v) < d(v)` 就说明存在 negative-weight cycle

- 和 Dijkstra 其实有点像
    - Dijkstra 是每次选择距离最小的那个节点，只处理这个节点的边
    - Bellman-Ford 每次都处理所有的边

---

### Speeding up Dijkstra

---

- single-source single-target Dijkstra
    - 只要求一个点，那么就不需要遍历完全部节点（废话啊……

- bidirectional search
    - 同时从起点 s 和终点 t 进行搜索
    - 假如某个点，既在 s 的搜索结果中，又在 t 的搜索结果中，那么这条路径就确定了
    - 继续进行其他点的处理，直到所有节点的最短路都确定下来
    - （这样的操作，相比直接从头到位查找，有实际效果吗？

- goal-directed search / A-star
    - modify the edge weights with potential function over vertices.
    - `w'(u,v) = w(u,v) - lambda(u) + lambda(v)`
    - 挑选合适的函数，让修改后的 w' 都变成正数，然后就可以套用 Dijkstra
    - 不懂

---

## Dynamic Programming

---

### Memoization, Subproblems, Guessing, Bottom-up; Fibonacci, Shortest Paths

---

- DP
    - careful brute force
    - recursion + memoization + guessing
    - shortest paths in some DAG

- DP
    - memoize & re-use solution to subproblem
    - time complexity = number of subproblems * time/subproblem
- bottom-up DP
    - topological sort of subproblem depencency DAG
    - no recursion (practically faster)
    - save space (no need remember all subproblem result)
    - 其实不复杂
        - 一开始说的 DP，是直接计算需要的值，逐步分解到小问题
        - bottom-up DP，是先计算小问题，逐步推导到需要的值
- subproblem depencency should be acyclic

- graph with cycles

---

### Parent Pointers; Text Justification, Perfect-Information Blackjack

---

- 5 steps to DP
    - define subproblems
    - guess (part of solution)
    - relate subproblem solutions
    - recuse + memoize
        - or build DP table bottom-up
        - check subproblems acyclic/topological order
    - solve original problem

- 感觉 DP 第一步就很有难度了，如何拆解问题

---

- text justification: split text into "good" lines
    - 比较直接，但效果不好的方法：每行都尽可能塞下更多词（greedy），然后行内平分间距。
    - DP
        - 如何定义效果好不好。为每一行计算一个 badness，让最后的 badness 的总和最小
        - 如何定义 badness，超过行宽则 `∞`，不超过行宽则 `(line_len - words_len)^3`
            - 目标肯定是让每行的空格都尽可能少，但为什么要用 `^3`，似乎是因为 latex 选了这个函数
        - `DP[i] = min(badness(i,j) + DP[j] for j in (i+1,n))`
        - 如何拆解问题
            - 假设一共 N 个词
            - 假设第一行最多可以放 M 个词
            - 子问题就是对 (N-1) ... (N-M) 个词进行 justification
            - （问题拆开后，就可以看到和最短路问题相同的模式了

- parent pointers
    - 在处理问题的过程中做缓存（实际编码应该能注意到？重复计算的地方
    - remember which guess was best
    - just like memoization and button-up, but automatic (no thinking required)

- longest increasing subsequence
    - 关键应该是问题拆解？
    - 对于 x，子问题应该是找出右边大于 x 的值的 LIS，都算好后，取最长的那个加上 x
    - 其实这种过程，和 map-reduce 很类似啊

---

### String Subproblems, Pseudopolynomial Time; Parenthesization, Edit Distance, Knapsack

---

- useful subproblems for strings/sequences x
    - suffixes `x[i:]` O(|x|)
    - prefixes `x[:i]` O(|x|)
    - substrings `x[i:j]` O(|x|^2)

---

- edit distance
    - edit: insert c, delete c, replace c
    - (if insert&delete cost 1, replace cost 0; it's equivalent to finding longest common subsequence
    - subproblems, `edit_distance(x[i:],y[j:])`
        - 每个子问题，都能拆成三个子问题
        - `cost(delete(x[i]) + edit_distance(x[i+1:],y[j:])`
        - `cost(insert(y[j]) + edit_distance(x[i:],y[j+1:]))`
        - `cost(replace(x[i],y[j]) + edit_distance(x[i+1:],y[j+1:]))`
        - 然后看哪种开销最小

---

- knapsack （背包问题）
    - question
        - knapsack of size S
        - list of items, each item has integer size Si and value Vi
        - choose subset of items of max total value
    - solution
        - 其实和前面的 text justification 是很像的
        - 分成 S1...Sn 这样 N 个子任务，子问题变化的是背包的大小，从 S 变成 S-Si
        - 整合结果的时候，V1...Vn 加上子问题的结果，取最大的那个即可
    - not polynomial time

---

- polynomial - good
- exponential - bad
- pseudopolynomial - so so

---

### Two Kinds of Guessing; Piano/Guitar Fingering, Tetris Training, Super Mario Bros.

---

- 2 kinds of guessing
    - guess which other subproblems to use (used by every DP except Fibonacci)
    - create more subproblems to guess/remember more structure of solution (used by knapsack DP)
        - effectively report many solutions to subproblem
        - lets parent subproblem know features of solution

---

## Advanced Topics

---

### Computational Complexity

---

- computational difficuly
    - P   = { problems solvable in polynomial time }
    - NP  = { problems solvable in polynomial time via a "lucky" algorithm }
        - = { decision problems with solutions that can be "checked" in polynomial time }
    - EXP = { problems solvable in exponential time }
    - R   = { problems solvable in finite time }
    - `P < NP < EXP < R < uncomputable`
        - `P < NP < NP-hard`, NP/NP-hard 的交集被叫做 NP-complete
        - `P < NP < EXP < EXP-hard`, EXP/EXP-hard 的交集被叫做 EXP-complete

- uncomputable: no algorithm solves it correctly in finite time on all inputs
- decision problem: answer is YES or NO
- most decision problems are uncomputale
    - 比如 halting problem

- reductions: convert your problem into a problem you already know how to solve

---

- P 就是能在多项式时间内解决的问题
- NP 就是能在多项式时间验证答案正确与否的问题
- P=NP，对于一个问题，如果能在多项式时间内验证答案的正确性，问能否在多项式时间内求解

---

### Algorithms Research Topics

---

- 提了下利用多核
- 提了下后续课程
