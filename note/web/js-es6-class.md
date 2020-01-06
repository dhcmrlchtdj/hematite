# es6 class

---

越试越觉得 class 很奇怪啊

---

```js
class A {}
const a = new A();
a.__proto__ === A.prototype;

class B extends A {}
B.__proto__ === A;
B.prototype.__proto__ === A.prototype;
const b = new B();
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

---

https://github.com/Microsoft/TypeScript/blob/master/doc/spec.md#4.9.2
Bob 菊苣提供了 typescript 的规范，规定是比较明确的
但果然还是很奇怪啊……
默认的 es3 模式下，由于把父类的方法 copy 到子类了，导致 super.x 修改了父类，子类却没变
在开启 es6 模式下，由于直接使用 es6 class，导致运行结果和 es3 下不一致，坑啊

babel 的 loose 模式下
继承上是没错的，super.x 赋值时直接修改了父类，然后继承到了子类。
区别也就在这里了，浏览器是修改了子类，父类没变。

babel 的普通模式下
大部分逻辑其实和 loose 一样的，不过用了 `Object.getOwnPropertyDescriptor` 来获取父类的方法
逻辑上也是在修改父类，所以肯定和浏览器直接执行的结果不同。
不过有个其他问题，Object.getOwnPropertyDescriptor 每次返回的都是新对象，而且不影响原对象
所以修改这个对象，原对象根本不发生修改啊

试了下 g 家的 traceur
居然需要自己的 runtime 才能跑起来……
赋值时进入了 https://github.com/google/traceur-compiler/blob/master/src/runtime/modules/superSet.js
看了下代码，也是用 getOwnPropertyDescriptor 获取父类的方法
然后因为父类的方法没有定义 `set`，抛出了异常
所以，还是和浏览器的行为有些许不一致。

所以，es6 到底是怎么定义的呢
浏览器是怎么实现的呢？

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
