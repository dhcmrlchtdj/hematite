# UNIDIRECTIONAL USER INTERFACE ARCHITECTURES

---

http://staltz.com/unidirectional-user-interface-architectures.html

---

> fractal architectures, the whole can be naively packaged as a component to be used in some larger application.
> In non-fractal architectures, the non-repeatable parts are said to be orchestrators over the parts that have hierarchical composition.

目前个人的感觉是，组件间的架构，应该是分形这张形式。

---

ELM 的定义

- Model: a type defining the structure of state data
- View: a pure function transforming state into rendering
- Actions: a type defining user events sent through mailboxes
- Update: a pure function from previous state and an action to new state

让人感觉比较理想的一个，细节再研究。

---

再想想，reduce 确实是很适合做更新的。

Model -> View 这个方向是很确定的。
View -> Action 没有问题。
Action + Model -> new Model 也没有问题。

在 Action + Model 这个地方，天然就适合 reduce 应用进去，是个嵌套的 reduce 过程。
