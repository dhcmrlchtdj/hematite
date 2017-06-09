# Packrat Parsing

---

http://bford.info/pub/lang/thesis/
http://bford.info/pub/lang/packrat-icfp02/
http://bford.info/pub/lang/peg
https://zhuanlan.zhihu.com/p/25260077

---

- recursive descent parsing 可以分为 predictive parsers 和 backtracking parsers
- 回溯分析会遍历所有可能分支，所以分析能力更强，但是可能出现指数级别的耗时
- 预测分析只看有限个符号来决定分支，但是能保证线性的时间内完成分析
- Packrat Parsing 借助 memoization，实现了线性时间复杂度的回溯分析
