# redundancy vs dependencies

---

http://yosefk.com/blog/redundancy-vs-dependencies-which-is-worse.html

---

- 减少代码冗余
- 减少外部依赖

我理解，上诉两个要求，是为了实现设计上的高内聚低耦合

作者文中讨论了两个要求发生冲突的情形（在跨模块的功能调用中，很容易发现这种问题

> the case when minimizing redundancy conflicts with minimizing dependencies

---

作者的观点很直接：冗余好过依赖。
当然，肯定不是这么粗暴的划分，还是来看下论证过程。

> Redundancy always means duplicated efforts, and sometimes interoperability problems.

> But dependencies are worse.
> The only reasonable thing to depend on is a full-fledged, real module, not an amorphous bunch of code.

---

核心是作者认为，module 应该是完整的。

- a reasonably compact, stable interface
- documentation
- tests
- reasonable size
- owner
- life cycle

不是几行代码就能被叫做 module
作为依赖的 module，应该是高质量的、可靠的

如果一个功能抽象，不能满足上诉需求，是不足以被称为 module 的。
依赖这种不可靠的 module，风险是很大的。

---

遇到这种取舍的时候，是否需要把冗余代码拆分出来。
判断的标准即使上面列举的要求。
不能满足的话，允许部分代码冗余会是更好的选择。
