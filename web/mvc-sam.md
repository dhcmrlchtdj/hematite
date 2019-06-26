# SAM pattern

---

http://sam.js.org

State-Action-Model

Model-View-Controller

简单理解成对 react 数据模型实践的一种解读吧。

---

+ reactive / functional pattern
+ 分离 view 和业务逻辑；前端与后端 API 解耦

React 的特点

+ 可组合，Composition
+ 单向数据流，Undirectional data flow
+ DSL 无关，Freedom from DSLs
+ 明确修改，Explicit mutation
+ 静态内在模型，Static mental model

---

SAM 与 MVC 的区别

+ MVC 的实现大都是 interactive 的，而 SAM 是 reactive 的。
+ SAM 引入了 State 的概念，对 View 和 Model 进行解耦，View 作为 State 的展示。

State --- View
View --user action--> Action
State --next action--> Action
Action --present--> Model
Model --render--> State

+ State 被渲染成 View
+ 用户操作 View，生成 Action
+ Action 修改 Model
+ Model 生成 State

---

+ `View = f (Model)`，View 是 Model 的一种映射结果
+ 这里的函数映射与模版的区别在于：函数是代码生成器，而模版引擎是解释器。
    模版的表达能力受限于模版引擎，而函数的表达能力是完整的。


---

+ SAM 中，业务逻辑分成了三个部分，Actions / Modle / State
+ Actions 是 dataset 到 dataset 的映射，pure function。
    Actions 里只处理特定的数据（context specific data）。
+ Model 包含了完整的应用状态，决定如何响应 Action 处理后的数据。
    Model 才能修改应用状态，而 Actions 接触不到状态（application state）。
+ State 将 Model 的数据映射到 View 展示使用的数据。
