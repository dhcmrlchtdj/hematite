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

### Counting Sort, Radix Sort, Lower Bounds for Sorting and Searching

---

## Hashing
### Hashing with Chaining
#### Simulation Algorithms
### Table Doubling, Karp-Rabin
#### DNA Sequence Matching
### Open Addressing, Cryptographic Hashing
#### Quiz 1 Review
## Numerics
### Integer Arithmetic, Karatsuba Multiplication
### Square Roots, Newton's Method
## Graphs
### Breadth-First Search (BFS)
### Depth-First Search (DFS), Topological Sorting
## Shortest Paths
### Single-Source Shortest Paths Problem
### Dijkstra
### Bellman-Ford
### Speeding up Dijkstra
#### Quiz 2 Review
## Dynamic Programming
### Memoization, Subproblems, Guessing, Bottom-up; Fibonacci, Shortest Paths
### Parent Pointers; Text Justification, Perfect-Information Blackjack
### String Subproblems, Pseudopolynomial Time; Parenthesization, Edit Distance, Knapsack
### Two Kinds of Guessing; Piano/Guitar Fingering, Tetris Training, Super Mario Bros.
## Advanced Topics
### Computational Complexity
### Algorithms Research Topics
