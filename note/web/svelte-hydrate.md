# svelte hydrate

---

首先是 svelte 编译器要加上 `hydratable: true` 选项
这样编译出的组件会带有 `function claim(nodes)` 及 `function hydrate()` 实现

- hydratable=false，只会输出 `create()`
- hydratable=true，原来的 `create()` 会被拆分成两个函数，`create()` 和 `hydrate()`，并在 `claim(nodes)` 里注入一些代码
    - `create()` 和 `claim(nodes)` 最后都会调用 `hydrate()`

至于组件渲染时的 `hydrate: true` 参数，只是控制运行时行为，对编译产物无影响。
开启 hydrate 参数时，创建组件时会调用 `claim(nodes)` 和 `nodes.forEach(detach)`，保持页面 DOM 与目标结构一致。

---

关键就是理解 `claim()` 的过程

- claim(nodes) 和 create() 有一致的结构
- 在 claim 里输出的 `claim_xxx(nodes)`
- 在 create 里有对应的 `create_xxx()` 或者是 `xxx()`
- `claim_xxx(nodes)` 会去 nodes 里寻找服务端 hydrate 过的 DOM 节点
    - 找到了，会把节点从 nodes 里删除，并返回 DOM 节点
    - 没找到，会用 `create_xxx()/xxx()` 创建需要的 DOM 节点
    - 两点作用，其一是获取 DOM 节点用于之后的响应式更新，其二是后面删除不需要的节点
- 寻找之后，剩下的节点是那些服务端输出，但是最新渲染结果不需要的 DOM 节点，会调用 detach 从页面删除
- `claim(nodes)/create()` 就是在构造最终需要的 DOM 结构
- claim 就是在根据最新的状态构造 DOM 结构，同时遍历页面 DOM，该增增，该删删，该改改

---

- `hydrate()` 里没什么特别需要关注的，给生成的 DOM 加上该有的各种 attribute
