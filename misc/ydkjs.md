# You Don't Know JS

https://github.com/getify/You-Dont-Know-JS

---

https://github.com/getify/You-Dont-Know-JS/blob/master/scope%20&%20closures/apB.md

> the `catch` clause has block-scoping to it

`catch` 会构造块级作用域，这点之前真没注意过。

---

https://github.com/getify/You-Dont-Know-JS/blob/master/scope%20&%20closures/apC.md

> arrow-functions are really just codifying into the language syntax a common
> mistake of developers, which is to confuse and conflate "this binding" rules
> with "lexical scope" rules.

个人观点，es6 的不少语法“糖”完全是在增加心智负担……

---

https://github.com/getify/You-Dont-Know-JS/blob/master/this%20&%20object%20prototypes/ch2.md

https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/bind

关于 `new` 和 `bind`，以前研究过一次。

1. `.` 的优先级高于 `new`。
2. `new` 会忽略 `.bind` 的 `this` 绑定，但参数绑定是生效的。

另外 es6 新增的箭头函数不能 `new`，所以倒也不存在优先级问题。

---
