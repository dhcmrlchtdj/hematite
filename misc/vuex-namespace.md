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
