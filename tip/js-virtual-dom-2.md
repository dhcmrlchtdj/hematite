# virtual dom 2

---

## snabbdom

---

https://github.com/snabbdom/snabbdom/tree/v0.6.9

---

核心之一是 `VNode` 的数据结构

```typescript
interface VNode {
    sel: string | undefined;
    data: VNodeData | undefined;
    children: Array<VNode | string> | undefined;
    elm: Node | undefined;
    text: string | undefined;
    key: Key;
}
```

构建 `VNode` 的方法 `h` 就不展开了。
结果来说，最终生成的是树状的结构，根据这个结构我们可以直接生成 DOM。

---

另外一个重点是 `patch(oldVnode: VNode | Element, vnode: VNode): VNode` 方法。

这里我感觉设计还是复杂了。
参数是 `Element` 的时候，用意是插入 DOM；
参数是 `VNode` 的时候，用意是更新 DOM。
感觉功能直接分开更直观。

代码实现里，`Element` 其实一开始就转换成了 `VNode`。
后面都是 `VNode` 之间的比较。

---

patch 的过程中

- `insertedVnodeQueue` 记录所有的操作，等到整个 patch 过程结束后，一次性修改
- 如果两个 `VNode` 不同，会由 `createElm` 递归创建 DOM 节点并替换，不会再进行对比判断
- 两个 `VNode` 被认为相同，则由 `patchVnode` 来更新节点
- 子节点分成了 `children` 和 `text` 两种情况，可能是为了使用方便，但是感觉把代码搞复杂了
- `updateChildren` 的过程，就是移动子节点、递归对比子节点。有点乱

---

## inferno

---

https://github.com/infernojs/inferno/tree/v3.1.2

---




