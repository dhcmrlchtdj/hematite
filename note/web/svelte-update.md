# svelte update

---

提过动画相关的 `intro/outro`，创建相关的 `create/claim/hydrate`，跳过挂载和销毁的 `mount/destroy`，剩下就是更新用的 `update`。

svelte 处理更新是以 component 为单位的，在 update 内部用 if 判断相关 DOM 节点是否需要更新。
是否需要更新，有个 `dirty` 标记，还用上了位运算。

比如 `dirty[0] & 1` 的判断，可以找到对应的 `$$invalidate(0, ...)` 调用。
`$$invalidate` 里会更新 context 并调用 `make_dirty -> schedule_update -> flush -> update`。
随着这个调用链，最终执行到组件的 `update`。

---

以 component 为更新单位，所以粒度拆细一点对提升性能是有帮助的。

JS 的位运算是 32bit 的，一个 dirty 能标注的变量有限。
svelte 的解决方案是 dirty 数组，一个不够多来几个嘛。
`dirty[(i / 31) | 0] |= 1 << i % 31`

（其实我觉得 svelte 可以来个提示，结合更新以 component 为单位这点，一个组件变量超过 32 个，这就应该拆分了吧。
