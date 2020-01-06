# vuex namespace

---

关于 component 如何读取 state。

直接在 getter 暴露 state。
不可取。
感觉会很方便，感觉跟直接访问一样。
但是嵌套模块时不可控，依赖太多。

在 component 里使用命名空间，所有数据都经由这个命名空间暴露给 component。
getter 里有了这个 namespace 就可以支持这个 component 的调用。
底层的 state 结构，简单的封装起来。

---

继 action 没有 namespace 后，又遇到其他问题。
store 里只能是纯数据，computed 必须拿到 getter 里，导致了数据逻辑的分离啊。

---

目前的结构划分见 https://gist.github.com/dhcmrlchtdj/ad09bf344206317ea209917f8cab380a

主要想法是一个 component 对应一个 vuex 模块。
vuex 模块里，包含 component 需要的全部信息。
包括 `state / getters / mutations / actions`。
模块的数据、操作都一起，一目了然。
当 vuex 模块变得非常复杂，可以对模块里的代码进行分割，然后统一暴露出来。

为了方便使用，目前 component 里的写法比较粗暴。
所有 component 都使用相同的 getters / actions。
靠 component 自己约束自己，只读只写自己命名空间下的数据。

跨模块的通信要怎么做，还没想好。
有时候会在模块里 dispatch 其他模块的 mutations，
有时候会在模块里主动 watch 了其他模块的数据变化。
这块的做法还要继续优化。
