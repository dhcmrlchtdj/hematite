# es6 class

---

越试越觉得 class 很奇怪啊

---

```js
class A {}
const a = new A();

class B extends A {}
const b = new B();

a.__proto__ === A.prototype;

B.__proto__ === A;
B.prototype.__proto__ === A.prototype;
b.__proto__ === B.prototype;
```

唯一多出来的应该就 `B.__proto__ === A` 了
所以 A 的静态方法也都会被 B 本身继承。

---

```js
class A {
	constructor() {}
}
class B extends A {
	constructor() {
		console.log(this); // ReferenceError: this is not defined
		super();
	}
}
```

上面这样是不行的，`this` 必须在 `super` 之后调用
其他还有 `super()` 只能在构造函数里调用

---

```js
class A {
	static x() {
		console.log('from A.x');
	}
}
class B extends A {
	static y() {
		super.x();
		super.x = () => console.log('from B.x');
		console.log(super.x.toString());
	}
}
B.y();
B.y();
B.x();
```

这段代码，babel/typescript 的编译结果都和浏览器不一致。
浏览器在赋值时，实际上 `this.x = ...` 的效果，并且 `super.x` 始终引用不到 `this.x`。
看 es6 规范也没看明白是谁错了……

Bob 菊苣提供了 typescript 的规范，规定是比较明确的
https://github.com/Microsoft/TypeScript/blob/master/doc/spec.md#4.9.2
问题是 es6 到底是怎么定义的啊啊啊

---

## LHS && RHS

LHS look-up is find the variable container
RHS look-up is, not left-hand side

"who's the target of the assignment (LHS)"
"who's the source of the assignment (RHS)"

上面是来自 https://github.com/getify/You-Dont-Know-JS/blob/master/scope%20%26%20closures/ch1.md 解释

`super.prop` 的赋值是个 LHS，而直接调用应该是个 `RHS`
不过在 es 规范里，super 是归类在了 left-hand-side expressions 里，https://tc39.github.io/ecma262/#prod-SuperProperty
看不明白啊
