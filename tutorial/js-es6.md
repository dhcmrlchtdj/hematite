# es6

---

落后时代很久了

---

https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects

## Symbol

## Proxy

## Reflect

---

https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators

## spread
- `const a = [1, 2, 3]; const b = [...a];`
- 只适用于 iterable 的对象，比如 Map 可以但是 Object 是不可以的
- 和 rest parameter 是不一样的

## destructuring assignment
- http://exploringjs.com/es6/ch_destructuring.html
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

---

https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes
http://exploringjs.com/es6/ch_classes.html

## class

---

https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Iteration_protocols

## iterator


---

## summary

- spread / rest / destructuring
	- 默认值的处理方式
- new.target / super / class
	- super 的处理方式
- expression / statement / object
	- class, function, function*, async function 都是这样的，分为表达式、语句、对象
