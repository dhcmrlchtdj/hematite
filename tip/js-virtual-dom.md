# virtual dom

---

https://infernojs.org/docs/guides/benefits/list-rendering

---

> Inferno has two ways of rendering lists: Keyed algorithm and Non keyd algorithm.
> keyed lists will preserve the internal state of list items.
> The basic idea behind keyed algorithm is to minimize the number of patch operations.
> Non keyed algorithm has an advantage in performance when rendering static lists.

- key 用来标记列表的项，核心目标是减少 DOM 插入删除的操作。
- 文中的例子很直观。
    - 有 key 的时候，修改 key 对应的节点的内容
    - 没有 key 的时候，直接修改到目标状态

---

https://facebook.github.io/react/docs/reconciliation.html

---

> a heuristic O(n) algorithm based on two assumptions:
> - Two elements of different types will produce different trees.
> - The developer can hint at which child elements may be stable across different renders with a key prop.

- 如果类型不同，不会处理子组件，直接全部替换。
- 类型相同的 DOM，替换内容
- 类型相同的 Component，渲染新的 DOM
- key 的作用，前面 inferno 更直观
- tradeoffs
    - 只是修改内容，最好保持容器类型相同
    - 用好 key

---

https://facebook.github.io/react/docs/optimizing-performance.html#avoid-reconciliation

---

- 使用 `shouldComponentUpdate` 减少对比，优化性能
- 被认为不需要更新的，子节点也都不参与判断
- `React.PureComponent` 提供了对 props/state 的比对，但是不支持数组之类的对象
- 可以使用不可变数据来简化比较

---

https://facebook.github.io/react/contributing/implementation-notes.html
https://github.com/facebook/react/tree/v15.5.4/src/renderers/shared/stack/reconciler
https://github.com/infernojs/inferno/blob/v3.1.2/packages/inferno/src/index.ts

---

