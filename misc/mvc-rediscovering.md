# rediscovering MVC

---

https://github.com/ciscoheat/mithril-hx/wiki/Rediscovering-MVC

下面总结的，大都是针对 web 开发的。

---

+ MVC 是一个 pattern language 而不仅仅是个 pattern

---

+ 一个对象可以是 MVC 的任意组合
    + MVC 可以在一个对象内，比如一个滚动条
    + VC 可以紧密耦合，比如一个菜单栏
    + MVC 可以完全分离
+ 事实上，MVC 这种程度的抽象根本不具备复用性（reusable）。
    + 不同项目的 Model 设计不同
    + 不同项目的 Controller 逻辑不同
    + 不同项目的 View 展示不同
    + 只有里面使用的一些工具函数会比较通用
    + 可以认为 MVC 之间是否发生耦合，对复用性根本没任何影响
+ View 自然也可以是个对象
    + View 很多时候指的是模版，被引擎渲染成 html
    + 开始只是用 key-value 来填充 View，后来 View Model 的概念被提了出来
    + 实际上，可以直接把 Model 填充到 View 中，不需要那么多其他概念

---

下面讨论一些 MVC 的职责

（插一句，浏览器端的 MVC 和服务端的 MVC 还是有不少区别的，下面说是浏览器端的 MVC）

## Model

+ Model 发生变化时，主动通知相关的 View
+ 从 View 收到指令时，更新 Model 中的相应数据

## View

+ 从 Model 获取必要的数据，以特定的形式展示给用户

## Controller

+ 生成、管理 View，传入正确的 Model
