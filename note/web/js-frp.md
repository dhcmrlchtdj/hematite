# virtual DOM / FRP

---

https://github.com/funkia/turbine/issues/32

---

> virtual DOM solves a problem that we can completely avoid by using FRP.

开宗明义，FRP 再用 virtual DOM 是多余的。
（cycle.js 中枪……

---

- virtual DOM 里，先读取状态生成新的 DOM，然后由框架去判断如何更新实际页面。
- FRP 里，状态的变化可以直接对应到页面的修改，不需要 virtual DOM 那样的框架去判断要修改什么。
    - 部分 FRP 框架却不是这个思路
    - 它们将小状态聚合成一个大的状态，此时就无法判断状态变化对应页面的什么修改了。
    - 然后走了 virtual DOM 的路子，框架去判断如何更新实际页面。
    - 问题在于，状态聚合意味抛弃修改信息，聚合后又用比较的方式来判断如何修改。
- react fiber 等方案，本身就足以说明 virtual dom 的算法存在 overhead
- 理论上，FRP 在某些场景下，应该会比 virtual dom 更合适

---

- 这是 FRP 框架的问题，不是 virtual DOM 框架的问题
- 变化难以追踪才是业务开发遇到的主要问题
- 感觉这里说的 FRP，还是 observer 的思路吧
