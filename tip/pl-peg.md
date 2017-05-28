# PEG

---

翻了 PEG 的两篇论文
Parsing Expression Grammars 和 Packrat Parsing

---

- top-down parser
    - recursive descent parser
        - predictive parser / LL parser
        - backtracking parser
    - packrat parser

- bottom-up parser
    - operator precedence parser
        - shunting-yard algorithm
        - precedence climbing method
        - pratt parsing / top down operator precedence

- recursive descent。每个语法成分，基本都能直接对应到某个函数
- predictive。保证线性时间；通过 `look ahead` 来判断接下去是什么符号。
- backtracking。解析能力强，但时间复杂度高；直接尝试各种可能，失败就回溯。
- packrat。backtracking + memoizing，保证解析能力和线性时间复杂度。

---

> A PEG may be viewed as a formal description of a top-down parser.

虽然论文说了很多东西，但其实还是一个 top-down parser。
并且是一个 backtracking parser。

---

> redundant calls to the same parse function on the same input substring
> these redundant calls can be eliminated through memoization

backtracking parser 因为大量重复调用，所以时间复杂度可能会比较高。
不过，函数重复调用，自然会想到用记忆化来优化一下。
然后就有了 packrat parser。

---

记忆化，那就空间换时间了。
权衡一下值不值得，值得就可以开搞了。

优势在于拥有回溯的解析能力，又能保证线性的时间复杂度。

---

> lexical analysis can be integrated seamlessly into a packrat parser

packrat 可以同时进行词法分析和语法分析，不需要把两个流程分开。

> One limitation packrat parsing shares with other top-down schemes is that
> it does not directly support left recursion.

左递归虽然是问题，不过可以进行左递归消除。
（也有些自动处理左递归的算法

---

实在没啥好记的，直接开搞吧。
