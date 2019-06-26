# vuex

大部分场景下，可以自动生成配套的 getter/mutation，能够很大程度降低 vuex 的使用成本
但在表单、表格的处理上，双向绑定加上 v-model 要方便很多

双向绑定，直接修改变量即可；mutation 需要定位到数据的位置，再对数据进行赋值
在数据嵌套比较多的情况下，差异就非常明显了

## 问题

比较复杂的表单，选项经常相互关联。使用双向绑定，必然要使用 watch 来触发修改
个人认为 watch 这样的自动触发机制是万恶之源
数据走入了 data -> watch -> data -> watch 的死循环

而在 vuex 的限制下，数据修改要经过 mutation
关联的修改，在 mutation 时触发其他 mutation 就可以了

就数据修改来说，我是支持 mutation -> state 反对 data -> watch 的

## 方案

要么在 getter/mutation 的基础上，优化对复杂表单、表格的支持
要么在双向绑定的基础上，解决 watch 的循环问题
目标还是优化 mutation，但是没想好要怎么做

---

ember 说 [data down, actions up](http://www.samselikoff.com/blog/data-down-actions-up/)
react 说 [smart and dumb components](https://medium.com/@dan_abramov/smart-and-dumb-components-7ca2f9a7c7d0)

这个数据传递方向，说是目前的最佳实践应该是没有什么疑问的。
不知道 redux 是怎么实现的。
假如能把数据拆开，每个表单的选项、表格的行列都有自己的 reducer。
应该能够很大程度上简化修改 state 的复杂度。
在 vuex 上，现在能否用 module 的方式实现出来呢？

另外，在 vue-rx 的模式下，可以如何实现呢？

---

单纯用 vue 来实现前面的 data down, action up，并不那么容易。
在页面划分成多个组件后，需要一层层向子组件传递数据、子组件的事件也要一层层冒泡。
对于多层嵌套的结构，这是异常繁琐的的一件事情。

虽然个人认为在权衡利弊之后，这里繁琐一些是可以妥协的
但如果有更好的实现方式，当然毫不犹豫选择更好的方案啊

[vuex](https://vuex.vuejs.org/en/intro.html) 作为官方的数据架构方案
对复杂结构给出的解决方案是全局共享状态

> any component can access the state or trigger actions,
> no matter where they are in the tree!

这与其他框架提倡的方式其实是相悖的。
这其实是个更接近业务层的解决方案，绝对不是适合组件的数据维护方式。
即使是在业务层，这种方式也给多页面共享组件造成了困难。
你需要在多个业务的数据层提供相同的数据结构和操作。
vuex 的模块化或许能缓解这种问题，但这始终是在打补丁。

---

在 Presentational and Container Components 的文章里

presentational，也就是 dumb，是不依赖于其他东西的。
数据也好，操作也好，都是从 props 进来的。

container，也就是 smart，与外部数据层相连接。
有从 props 传递进来的数据和操作，也有自己从数据层拿到的数据和操作。
将数据和操作通过 prop 传递给子组件。
没有 dom 和 style，只负责组装。

> presentational tend to be stateless pure functions
> containers tend to be stateful pure classes

值得一提，作者更新了文章，认为可以随意嵌套
dumb 里面可以嵌套 smart 和 dumb
smart 里面也可以嵌套 smart 和 dumb

对于嵌套数据传递的问题，作者给出了建议
先全部用 dumb 的方式开发，遇到传递问题的时候，就是该抽离出 smart 的时候。

> When you notice that some components don’t use the props they receive
> but merely forward them down and you have to rewire all those intermediate
> components any time the children need more data,
> it’s a good time to introduce some container components.

这么一来，好像又和 vuex 的说法契合了。
所有能够接触到 vuex 的组件，都是 smart 组件。
这样要大规模复用的时候，就是整个 smart 组件进行复用。
