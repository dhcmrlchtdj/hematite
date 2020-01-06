# js object link

---

两次碰到这张情况，想要设计如下的 API

```js
var a = new A();
a.method0();
a.module1.method1();
a.module2.method2();
```

其中 `method1` 和 `method2` 的实现会用到 `method0`。
由于这些方法都是各实例共享的，所以就希望能把实现放在 `prototype` 上面。
理想情况就是 this 能直接引用到实例 `a`，可惜中间隔了 `moduleX`。

如果方法不放在 `prototype` 上，而是定义在 `constructor` 里面，
这时是可以拿到实例的，就什么问题都没有了。但感觉不够优雅……

也可以在构造函数里给每个 module 加上 context，但是 method 里面还是要绕圈子不能直接写 `this`。
