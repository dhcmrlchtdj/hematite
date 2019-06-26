# JavaScript Application Architecture On The Road To 2015

https://medium.com/google-developers/javascript-application-architecture-on-the-road-to-2015-d8125811101b

---

2014 年底的老文了
老说前端更新快，但这篇老文还是很有价值啊。

---

> We may argue about the frameworks and libraries surrounding these different
> flavours of component, but not that composition is inherently a bad thing.

组件化，是为了实现组合

---

> For events you’re going to fire-and-forget, the global event system model
> works relatively well but it becomes hairy once you start to need stateful
> events or chaining.

stateful events or chaining 说的很好呀
事件机制在处理复杂逻辑上，其实是不方便的

如果是一个全局的事件系统，那么也缺乏隔离性

---

> As complexity grows, you may find that events interweave communication
> and flow control.

逻辑复杂后，事件机制容易在使通信和流程控制混杂。
这个观点之前倒是没考虑过。

---

> What might be better than a global event system is CSP.

不知道能实现不

---

> We don’t really have a true mobile web experience if our applications
> don’t work offline.

那时候就已经在喊 service worker 了 😂

---

> Immutable data structures (for some use-cases) make it easier to avoid
> thinking about the side-effects of your code.

关于不可变数据

---

# Generators Are Like Arrays

https://gist.github.com/jkrems/04a2b34fb9893e4c2b5c

---

> People keep putting generators, callbacks, co, thunks, control flow
> libraries, and promises into one bucket.

😂

---

- Models/Abstractions of async behavior
	- thunks+callbacks, promises
- Control flow management:
	- co, async, spawn/ES7 async functions, Promise.all
- Data structures
	- arrays, generators, objects/maps

需要异步时使用第一类设施。
第二类工具让异步看起来更漂亮。
第二类通常会用到第三类的数据结构。
