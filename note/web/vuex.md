# some about vuex

---

首先是来自文档的介绍

http://vuex.vuejs.org/en/data-flow.html

> You will also notice the data flow is unidirectional, as it should be in Flux:
> 1. User input in the component triggers action calls;
> 2. Actions dispatch mutations that change the state;
> 3. Changes in state flow from the store back into the component via getters.

只是看这个数据流，其实是非常符合个人期望的。
以前记录 MVC 相关内容时就提到应该是 action + model -> new model。

但是方向正确，实践起来却不一定舒服。

---

http://vuex.vuejs.org/en/state.html

> It's important to remember that components should never directly mutate Vuex
> store state. Because we want every state mutation to be explicit and
> trackable, all vuex store state mutations must be conducted inside the
> store's mutation handlers.

vuex 在 state 和 component 之间做了隔离。
所有读取，都要经过 getter 而不是直接读取 state。
所有修改，都要经过 mutation 而不能直接在 action 里进行。

这就导致整个过程变得非常繁琐。

也许，在复杂单页应用中，这种额外的复杂度是可以接受的（我没经验，这里不提）。
但是，在普通的单个页面中，这样的开发方式其实是在大量编写无意义的中间层代码。
在 state 里增加一个属性，就要配套地写上 getter 和 mutation。

不要说什么单页面不需要 vuex 这类工具，任何稍微复杂的页面，都需要一套机制来控制页面数据。
没有统一管理，混乱的数据修改、穿插其间的事件传播，根本就是个地狱。
但是完全按照 vuex 来写，就像前面说的，重复劳动太多。
重复性的工作都自动完成，这才是程序的意义。
为了解决某一个问题，给自己带来大量重复劳动，这在方向上就是错误的。

---

https://github.com/vuejs/vuex/issues/42

> The difference between actions and mutations is that:
> + Actions can contain async operations and dispatch multiple mutations.
> + Mutations only care about actually changing the state and are always sync.
> 	So you can always compare the before/after states of a mutation once it's called.

> The whole point of a system like vuex is so that
> **every state mutation is trackable**.
> This is why mutations have to be sync.

> Actions vs. mutations is all about separating asynchronicity from actual
> mutations. When you see a sync mutation in the log, you know all the side
> effects it can ever produce is the different between the before state and
> after state. But for actions, there's no such guarantee.

作者解释为什么需要 mutation，隔离 mutation 和 action 只是结果。
关键是分离同步和和异步操作，便于监控数据变化的来源。
不过对于这里，个人还是有疑问啊，这里的 trackable 是为什么服务的呢。

---

就像 vue 用 get/set 来监听对象变化简化了使用。
这套数据流，也应该有一个更加简化的使用方式。
否则，这就只是一套理想却不可行的方案。

component 直接读取 state，通过 action 直接修改 state，是否可行呢。
