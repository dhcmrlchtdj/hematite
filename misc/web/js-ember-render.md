# ember render

---

https://emberjs.com/blog/2017/10/10/glimmer-progress-report.html
https://engineering.linkedin.com/blog/2017/03/glimmer--blazing-fast-rendering-for-ember-js--part-1
https://engineering.linkedin.com/blog/2017/06/glimmer--blazing-fast-rendering-for-ember-js--part-2
https://www.linkedin.com/pulse/glimmers-optimizing-compiler-chad-hietala/
https://thefeedbackloop.xyz/designing-and-implementing-glimmer-like-a-programming-language/

---

- 以 react 为代表的框架，流程上是 `template -> (data -> HTML)`
- 模版会以 component 的粒度编译成函数（即 JS 代码）
- runtime 会将 data 转化成 HTML，更新页面
- 需要在客户端加载的是 runtime 和 component 对应的函数

---

- ember 现在的玩法是 `template -> bytecode`
- runtime 里有个 VM，即 `bytecode -> data -> unit`
    - 这里应该是不输出 HTML 了，VM 会直接更新页面
- 需要在客户端加载的是 runtime 和 bytecode
    - 按描述，bytecode 的体积会比 JS 代码要小
    - 实现成 VM，那么很多 VM 那边的成熟经验都可以用在这里，instruction 的可玩性很高。

---

- 比较好奇 glimmer 的 VM 在初次渲染页面后，怎么做更新的

---

> running Glimmer in a Web Worker
> porting the core VM to WebAssembly

wow

---

http://yehudakatz.com/2017/04/05/the-glimmer-vm-boots-fast-and-stays-fast/
https://news.ycombinator.com/item?id=14050625

---

- initial render performance (vs Virtual DOM)
- updating performance (vs Key-Value Observing)

- static optimizations
    - compile templates into "append-time" opcodes for a bytecode VM
    - the process of running the "append-time program" produces the "updating program"
    - run (update) every time the inputs change
- dynamic optimizations
    - reduce the portion of the updating program

---

- the Glimmer VM is built on top of References and Tags
- every reference has an associated tag

- 处理模版的时候，为每个变量生成一个 reference
- 修改页面、数据的时候，将 tag 标记为 dirty
- 检查整个模版，看哪些部分需要更新

---

https://github.com/glimmerjs/glimmer-vm/tree/master/guides

---

guide 里讲得还挺清晰的。

最主要的两个结构，ref 和 tag。
ref 就是一个容器，里面内容可变。
tag 是 ref 是否发生变化的标记，如果 tag 变化就重新计算 ref。

ref 和 tag 都是 pull 的模式，需要时才重新计算，这就要求有外部代码进行驱动。
ember 里的做法是，要求数据要使用 `set` 进行修改。
`set` 则会更新 tag 并触发数据状态检查，然后重新渲染更新的部分。
