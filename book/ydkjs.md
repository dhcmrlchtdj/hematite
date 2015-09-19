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

https://github.com/getify/You-Dont-Know-JS/blob/master/this%20&%20object%20prototypes/ch5.md

对于原型链上同名属性的写入，之前一直忽视了。

1. 如果该属性可写，那么会在当前对象上写入
2. 如果该属性只读，那么当前对象无法写入同名属性
3. 如果该属性是个 `descriptor`， 写入时会调用 `setter` 而不会在当前对象写入，
如果 `setter` 不存在则无法写入

不过 2/3 两点也不是绝对的，还是可以用 `Object.defineProperty` 直接定义在当前对象上。

---

https://github.com/getify/You-Dont-Know-JS/blob/master/types%20&%20grammar/ch2.md

`===` 并不一定准确，有两个例外， `-0` 和 `NaN`。

+ `Object.is(0, -0) === false` 但 `(0 === -0) === true`
+ `Object.is(NaN, NaN) === true` 但 `(NaN === NaN) === false`

---

https://github.com/getify/You-Dont-Know-JS/blob/master/types%20&%20grammar/ch3.md

> You'll note that there are no Null() or Undefined() native constructors,
> but nevertheless the "Null" and "Undefined" are the internal [[Class]] values exposed.

这个似乎有点问题，`null` 和 `undefined` 是没有 `[[Class]]` 的。
另外，es6 的 `Object#toString` 也不在使用 `[[Class]]` 了。

---

https://github.com/getify/You-Dont-Know-JS/blob/master/types%20&%20grammar/ch4.md

> JavaScript coercions always result in one of the scalar primitive values,
> like `string`, `number`, or `boolean`. There is no coercion that results in
> a complex value like `object` or `function`.

+ 运行时类型转化叫 _type coercion_
+ 编译时的类型转换叫 _type casting_

---

https://github.com/getify/You-Dont-Know-JS/blob/master/types%20&%20grammar/ch4.md

`parseInt(1 / 0, 19) === 18`，居然还有这种玩法。

---

https://github.com/getify/You-Dont-Know-JS/blob/master/types%20&%20grammar/ch4.md

> The coercion between `null` and `undefined` is safe and predictable, and no
> other values can give false positives in such a check.

`if (a == null) {}` 这种写法其实是很明确的。

---

https://github.com/getify/You-Dont-Know-JS/blob/master/types%20&%20grammar/ch5.md

> In other words, the completion value of a block is like an implicit return
> of the last statement value in the block.

`statement` 是有返回值的。
如果用 `eval` 执行语句，可以拿到语句的返回值。

---

https://github.com/getify/You-Dont-Know-JS/blob/master/types%20&%20grammar/ch5.md

> JSON is truly a subset of JS syntax, but JSON is not valid JS grammar by itself

因为 `labeled statements` 中的 `label` 是标示符而不是字符串。

---

https://github.com/getify/You-Dont-Know-JS/blob/master/types%20&%20grammar/ch5.md

> ASI is (formally speaking) a syntactic error correction procedure.

还是感觉是否加 `;` 属于个人习惯。

---

https://github.com/getify/You-Dont-Know-JS/blob/master/types%20&%20grammar/ch5.md

> You can also mix named parameters with the arguments array and be safe, as
> long as you follow one simple rule: **never refer to a named parameter and its
> corresponding arguments slot at the same time**.

---

https://github.com/getify/You-Dont-Know-JS/blob/master/types%20&%20grammar/ch5.md

> The code in the `finally` clause always runs (no matter what), and it always
> runs right after the `try` (and `catch` if present) finish, before any other
> code runs.

即使 `try` 语句中 `return` 了，还是可以在 `finally` 里面抛出异常或者修改 return 的值。

---
