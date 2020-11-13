# svelte local

svelte 的动画有个 local 参数，可以解决父子元素动画冲突的问题

---

不带 `local` 修饰，`intro/outro` 里直接调用 `add_render_callback`
带 `local`，调用前有个 `if (local)` 判断

---

一个 html tag 带上 `transition`，就会给所有祖先节点加上 `intro/outro`
`intro(local)` 调用都是通过 `transition_in(block, local)` 触发的，`outro` 同理

---

那么 local 从哪来呢
`transition_in` 最初发生在 `init / update_keyed_each` 之类的调用里
此时直接创建元素，会调用 `transition_in(block, 1)`
之后调用子元素的动画，会是 `transition_in(block)`
`local=1 / local=undefined` 发生在这个时候
