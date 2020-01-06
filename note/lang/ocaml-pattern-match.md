# pattern match

---

http://moscova.inria.fr/~maranget/papers/ml05e-maranget.pdf
https://github.com/clojure/core.match/wiki/Understanding-the-algorithm

---

太鶸了，看不懂论文……

---

- pattern match 有两种处理方式
    - backtracking automata
        - 生成的代码小
        - 运行时可能会回溯，反复计算
    - decision trees
        - 代码可能会膨胀得毕竟厉害
        - 不需要重复计算

---

> compilation to decision trees with maximal sharing, guided by a good column .

- 论文里提出的算法，核心是 maximal sharing 和 heuristic

---

具体思路，可以先看 core.match 的讲解（确实没看懂论文，😢

> Maranget's approach produces optimal decision trees by finding the columns
> that must be tested and testing them first.
> This is done by scoring columns to determine what to test next.

我们在匹配的时候，是从上到下从左到右，通过列出矩阵，我们可以找出要先匹配哪个条件
裁剪去部分条件后，得到一个更小的矩阵，反复应用这种算法，得到最终结果

---

从 core.match 复制来的流程图

```
 x y z
-------
[_ f t] 1
[f t _] 2
[_ _ f] 3
[_ _ t] 4
[_ _ _] 5

---

 x y z
-------
[0 1 1] 1
[0 1 0] 2
[0 0 0] 3
[0 0 0] 4
[0 0 0] 5

---

 y x z
-------
[f _ t] 1
[t f _] 2
[_ _ f] 3
[_ _ t] 4
[_ _ _] 5
```

上面这个过程，能毕竟清晰地看到转化的过程

这只是最简单的情况。
对于 List/Record/Variant/OR，都可以在矩阵里展开计算。

```
    v    x
-----------
[[_ 2 2] t] 1
[[_ 2 3] f] 2
[[1 2 4] _] 3
[   _    _] 4

---

 v_0 v_1 v_2 x
---------------
[ _   2   2  t] 1
[ _   2   3  f] 2
[ 1   2   4  _] 3
```
