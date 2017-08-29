# mvc state

---

数据状态的管理，在应用开发中算是最麻烦的环节之一了。
虽然很赞同 data->view 这种渲染逻辑，但是 flux 的写法过于繁琐。
所有数据都靠 prop 向下传递的理念相当好，不过小型应用和非公用组件，还是偏向简单粗暴解决问题。
single source of truth 这样统一状态管理听着很有道理，但组件自带部分状态对于封装来说是必要的，两者如何整合是个问题。

---

## focal

https://github.com/grammarly/focal

Type safe, expressive and composable state management for React applications.

---

- represent application state as immutable single source of truth
    - observable
- use lenses to decompose the application state into smaller parts

---

- how lens works？
- how the component observes the data?
    - An `F`-component will `.subscribe` to all of its `Atom<T>` props and render every time a prop value has changed.

---

```javascript
const state = Atom.create({ count: 0 })
const subState = state.lens(x => x.count)
const App = (props) => <F.div>{props.state.count}</F.div>
ReactDOM.render(<App state={state} />, document.getElementById('app'))
```

- 通过 `lens` 来创建新的 state。（如果 lens 里面的函数很复杂会怎么样呢
- `Atom` 创建的 state 是个 observable，可以跟踪 state 的修改。（ 但修改是怎么周知到 react 的呢

---

https://github.com/grammarly/focal/blob/a4fed7cfcbd7c3965e6ceeca2db00c47ba1a8780/src/react/react.ts#L39-L118

F 的相关实现，在代码里看到 calmm。
（按 readme 自己的说法，focal 在整体设计上和 calmm 是一致的，最初是 calmm 的一个 folk
（https://github.com/calmm-js/documentation/blob/master/introduction-to-calmm.md

实现本身，就是依靠 react 的几个生命周期函数，subscribe 了 observable。

---

lens 没有说得很清楚，表面看就是 getter/setter，具体还需要研究下。

---

## onionify

https://github.com/staltz/cycle-onionify

Fractal state management for Cycle.js apps

---

- all state lives in one place only
    - 这点也算是深入人心了
- use the same pattern to build any component
    - 这点其实是从 api 使用的角度说的，分型这种结构个人是很赞同的
- you can move any component to any other codebase using onionify
    - 关键是这点，如何整合组件的 state

---

- how to split different datas from one stream?

---

> With onion-layered state, there is no distinction between props and state
> because both are encoded in the large state tree.

所有状态都通过 state 来修改

> there is no global entity in the onion state architecture.
> all components are written in the same way without expecting any global entity to exist.

虽然没有全局数据，但对外层传入数据的结构还是有要求的吧。
不过全部用 props 传递，一样对数据结构有要求就是了。

---

```javascript
function main(sources) {
  const state$ = sources.onion.state$;
  const reducer$ = xs.of(/*...*/);
  const sinks = { onion: reducer$ };
  return sinks;
}
const wrappedMain = onionify(main);
Cycle.run(wrappedMain, drivers);
```

从 onion 获取数据，返回一个新的 onion，`state$ -> reducer$`。
（感觉就是 state-passing style 了。那么是不是可以扯到 monad……

`reducer$` 是个函数，`oldState=>newState`。
这里的 oldState 和 source.onion.state$ 应该是一样的，都是由外部传递进来的。
可以在 reducer$ 里面去调用内部其他组件的 reducer$。

关于与子组件的交互，子组件被 import 然后返回的是个 sinks。
子组件的 .onion 就是 reducer$ 了。

---

后面文档里也提到了 lens，看来确实需要去了解一下。

---

和前面的 focal 比较一下的话，还是很相似的，主要差异其实是数据拆分整合的写法。
- 拆分
    - focal 是通过 .lens 生成新的数据对象，然后作为 props 传递
    - onionify 是直接生成新的数据对象，然后通过 childSinks.onion 传递
- 整合
    - focal 可以手写 setter
    - onionify 是手写 reducer$
- 在自动更新 dom 这件事情上，都是通过 observable 来实现

---

## mobx-state-tree

https://github.com/mobxjs/mobx-state-tree

Opinionated, transactional, MobX powered state container

---

a state container that combines
- the simplicity and ease of mutable data
- the traceability of immutable data
- the reactiveness and performance of observable data

这大杂烩……

- immutability
    - transactionality
    - traceability
    - composition
- mutability
    - discoverability
    - co-location
    - encapsulation

---

living tree 本身是可变的，框架自动生成不可变的 snapshot
看了一圈，暂时没明白……
