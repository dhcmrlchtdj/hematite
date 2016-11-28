# es6

---

https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference
http://exploringjs.com/es6/index.html

---

从 JS 高级程序设计入门后，再也没仔细翻看 JS 的基础教程。
结果就是很多 ES6 的细节掌握并不好……
这次算是补课了

---

https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects

## Proxy

## Reflect
- 感觉没啥用处，只是一些写法……
	- `Reflect.apply(Math.floor, undefined, [1.75])`
	- `Math.floor.apply(undefined, [1.75])`

## Symbol
- 用于对象的属性（好像也没其他卵用了……
- Symbol.for 和 Symbol.keyFor 是全局的
	- Symbol.for() 在全局搜索对象并返回，没找到就创建一个再返回
	- 而 Symbal() 总是创建新的
	- Symbol.keyFor() 在全局查找对象的 key 并返回，没找到就 undefined
	- well-known symbols 是没有 key 的 `Symbol.keyFor(Symbol.iterator) === undefined`
- for...in 遍历时，不会遍历到 Symbol
	- JSON.stringify 时也会忽略掉

---

https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators

## spread
- `const a = [1, 2, 3]; const b = [...a];`
- 只适用于 iterable 的对象，比如 Map 可以但是 Object 是不可以的
- 和 rest parameter 是不一样的

## destructuring assignment
- 以 Array 或 Object 的形式进行解构
- 不声明变量，默认是 let？ TODO
- 默认值是按需计算的
- Array
	- 没有被赋值的部分直接丢弃 `let [x] = [1, 2, 3];`
	- 解构时可以带上默认值 `let [x=1, y=2, z=3] = [10, 9];`
	- 对于 iterable 的对象，解构时直接遍历 `let [z] = new Map([['x', 1], ['y', 2]]);`
- Object
	- 没有被赋值的部分直接丢弃 `let {x} = {x: 10, y: 20};`
	- 可以带上默认值 `let {p=1, q=2} = {p: 30};`
	- 可以对其他变量进行赋值 `let {p: foo, q: bar=20} = {p: 30};`
	- 可以嵌套解构 `let {key: [{prop}]} = {key: [{prop: 10}]};`
	- 对象的计算属性 `let key = 'z'; let {[key]: foo} = {z: 10};`

## super
- 调用父级构造函数 `super()`
- 调用父级方法 `super.method()`
	- 可以是实例上的，也可以是是类的静态方法
- 动态绑定的
- 可以修改父级的属性

## new.target
- 普通调用时为 `undefined`
- `new` 的时候指向构造函数
- 箭头函数里执行词法作用域的 `new.target`

## await
- 后面的对象不是 Promise 就转换成 Promise
- 根据 Promise 的状态，resolve 回返回，reject 就异常

## yield*
- 返回值是 iterator close 时的返回值
- 遍历后面的 iterator

## yield
- 返回值是个 IteratorResult

---

https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements

## let / const
- let/const 有变量提升，但是在声明的语句之前，还是不能使用（ReferenceError
	- Temporal Dead Zone
	- 变量在声明后，初始化之前，不能使用
- let/const 不能重复声明（SyntaxError
- const 是 read-only 但不是 immutable

## for...in / for...of
- `for...in` 是遍历对象的 enumerable properties
- `for...of` 则根据 [Symbol.iterator] 进行遍历

## class
- 和 function 一样分成表达式和语句
- 不像 function，没有 hoisted
- 不管是 class expression 还是 class statement，内部语句都是在 strict 模式下执行的

## async function
- 语句本身返回一个 AsyncFunction 对象
- 调用时返回 promise，正常返回就 resolve，抛出异常就 reject

## function*
- 即 generator function，会返回一个 Generator
- 调用后返回一个 iterator

---

https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions

## rest parameter
- `function(a, b, ...c) {}`
- `arguments` 是 Array-like，而 `...c` 是 Array 实例
- 可以和解构赋值一起用 `function(...[a, b, c]) {}`

## arrow function
- this, arguments, super, new.target 都不是自己的，而是外层的
- 无视 call / apply / bind 的 context 参数
- 不能和 new / yield 一起使用 

## default parameter
- 在没有参数或者参数为 undefined 时，都会使用函数定义的默认参数 `((a, b=1) => (a + b))(1)`
- 每次调用的时候会重新执行，所以数组、对象之类的每次都会是新的（和 python 不一样
	- 和 destructuring 的默认值应该都是相同的逻辑
- 后声明的变量能看到先声明的变量 `((a=1, b=a) => (a + b))(2)`
	- 理解为执行有序就好

## shorthand syntax / getter / setter

## block-level functions
- es6 + strict 的情况下，函数语句的作用域被限制在 block 里了，和 ES5 不一样!
	- 不要用函数语句基本也就安全了
	- 个人习惯一致是函数语句做 class，函数定义都用函数表达式
	- 有了 class 之后，只用函数表达式就好了……

---

https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes

## static
- static 语句定义的是类的类方法
- super 可以访问到父类的 static 方法

## extends
- 甚至可以 extends null

## boxing
- class 内定义的所有方法，当 this 没有明确指向一个对象的时候，都是 undefined
	`class Animal{static speak(){return this;}};let s=Animal.speak;console.log(s());`

## mixin
- 可以借助类似高阶函数的方式实现
	`class Bar extends AMixin(BMinin(Foo)) {}`

---

https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Iteration_protocols

## iterable protocol
- 自定义 for...of 时如何进行遍历
- 实现 `Symbol.iterator`(`@@iterator`) 方法
	- `Array.prototype[Symbol.iterator]`
	- `Array.prototype[@@iterator]`
- 自定义的 `@@iterator` 方法调用是无参数，需要返回一个 iterator

## iterator protocol
- 实现了 `next()` 语义的对象，都算是 iterator
- next 没有参数，返回对象 `{done,value}`
	- 返回值不对的时会抛出异常
	- done=true 时表示循环结束，此时 value 的值会作为 next 函数的返回值
	- done=false 即后面还有未读取的值
	- 读取的值都在 value 里
- 可以实现无限的序列

## generator
- generator object 同时满足 iterable 和 iterator 的定义

---

## summary

- expression / statement / object
	- class, function, function*, async function 都分为表达式、语句、对象
- spread / rest / destructuring
	- 默认值的处理方式
- new.target / super / class
	- super 的处理方式
- yield / yield*
	- yield 返回的 IteratorResult
