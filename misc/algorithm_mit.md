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
### Insertion Sort, Merge Sort
### Heaps and Heap Sort
### Binary Search Trees, BST Sort
### AVL Trees, AVL Sort
### Counting Sort, Radix Sort, Lower Bounds for Sorting and Searching
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
