# FRP SAC

---

https://quanttype.net/posts/2015-07-25-frp-and-sac.html

---

- functional reactive programming (FRP)
    - functional reactive programming is programming with values that change over time.
- self-adjusting computation (SAC)
    - Self-adjusting computation refers to a model of computing where computations can automatically respond to changes in their data.

- both FRP and SAC are about computations with changing inputs
- FRP is history-sensitive and SAC is not

---

https://cstheory.stackexchange.com/questions/9307/what-are-the-relationships-between-functional-reactive-programming-automatic-di/9308#9308

---

they all are ways of making functional programs deal with inputs that change over time.

- functional reactive programming
- partial evaluation
- self-adjusting computation

---

# SAC

---

http://www.umut-acar.org/self-adjusting-computation
https://blog.janestreet.com/breaking-down-frp/
https://blog.janestreet.com/introducing-incremental/
https://blog.janestreet.com/incrementality-and-the-web/
https://blog.janestreet.com/self-adjusting-dom/
https://blog.janestreet.com/self-adjusting-dom-and-diffable-data/
https://blog.janestreet.com/seven-implementations-of-incremental/
https://github.com/janestreet/incremental_kernel/blob/master/src/incremental_intf.ml

---

- computations that can be updated efficiently when their inputs change
- The structure of the computational graph in an SAC can change at runtime, in response to the changing input data.
- what makes Incremental really useful is how it helps you build large and complex computations
- SAC allows you to create new cells over the course of the computation

---

与 FRP 区别

- SAC and FRP have different semantics
- FRP is mostly concerned with time-like computations
- SAC is mostly about optimizing DAG-structured computations
- but they are nonetheless closely related, especially at the implementation level

- an FRP system can be implemented as a reactive graph like an SAC system

---

- 为什么不使用原生 DOM，给了一个很有力的理由：重复写了两次展示逻辑
    - 一次是初始化，一次是更新
    - 很自然地会想到加入一个中间层

- VDOM 最被诟病的一点，就是任何修改都会触发整个 VDOM 重新计算
    - 不过，虽然这样性能可能稍差，但是非常直观、容易理解
    - 做增量，复杂之后很容易变得混乱。如何梳理增量的状态变化，也是看这些文章的主要目的了
    - react 避免全局渲染，靠组件层面的 `shouldComponentUpdate`

- D3 使用不同于 VDOM 的方式，实现了类似的目标
    - VDOM encourages you to think of your view calculation as an all at once affair
    - VDOM is level-triggered, meaning the view depends only on the current value of the state
    - D3 makes you think about incrementalization explicitly where it matters
    - D3 is edge-triggered, meaning that the display logic can depend on the precise transition that’s occurring

---

- ELM
    - an application = a model + a view + a set of actions
    - But this approach doesn’t scale to big, complex UIs.
        - Even though most actions change the model in only small ways, the full vdom tree has to be created every time.
        - If the vdom is large and complicated, this is a serious problem.
        - 即使如此，大部分时候，其实挺好呀


