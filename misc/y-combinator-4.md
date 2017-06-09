# y combinator

---

http://sighingnow.github.io/%E7%BC%96%E7%A8%8B%E8%AF%AD%E8%A8%80/y_combinator.html

---

之前提过，不过没写
这次记一下 y combinator 的一些应用

---

先回顾一下 y combinator
后面用 js 来实现各种功能

```javascript
var Y = function(F) {
	return ((f) => f(f))((g) => F((x) => g(g)(x)));
};
```

```scheme
(define (Y F)
  ((lambda (f) (f f))
   (lambda (g) (F (lambda (x) ((g g) x))))))
```

---

## memoization

---

要对计算过程做处理，可以在 `g(g)(x)` 地方做点操作

---

```javascript
const U = f => f(f);
const Y = F => U(g => F(function(x) {
    const h = g(g);
    return h(x);
}));
```

这样拆开应该会看更清楚些
关注 `h = g(g)`

递归的时候，实际调用的就是这个 h
我们把 h 换成 `h = n => g(g)(n)` 对原来的过程是完全没影响的
但是这个 `n => ...` 里面却可以做很多文章

---

首先拿 fib 做个例子
可以打印每次的参数

```javascript
const U = f => f(f);
const Y = F => U(g => F(function(x) {
    const h = n => {
		console.log(n);
		return g(g)(n);
	};
    return h(x);
}));

const fib = Y(f => n => (n <= 2 ? 1 : (f(n - 1) + f(n - 2))));
```

那么要如何进行 memoization 简直再清晰不过了

---

```javascript
const m = {};
const U = f => f(f);
const Y = F => U(g => F(function(x) {
    const h = n => {
        if (!(n in m)) m[n] = g(g)(n);
        return m[n];
	};
    return h(x);
}));

const fib = Y(f => n => (n <= 2 ? 1 : (f(n - 1) + f(n - 2))));

console.log(fib(30));
```

---

## tail call optimization

---

说是 TCO，实际上是改成了 trampoline

---

先来一个 fact 的例子

```javascript
const U = f => f(f);
const Y = F => U(g => F(function(x) {
    const h = n => g(g)(n);
    return h(x);
}));

const fact = Y(f => n => (n === 1 ? 1 : (n * f(n - 1))));

console.log(fact(5555));
// RangeError: Maximum call stack size exceeded
```

在 5555 的时候就爆栈了

不过这个不是尾递归的写法
下面改一个尾递归的

---

```javascript
const U = f => f(f);
const Y = F => U(g => F(function(...x) {
    const h = (...n) => g(g)(...n);
    return h(...x);
}));

const fact = Y(f => (n, prod=1) => (n === 1 ? prod : (f(n - 1, n * prod))));

console.log(fact(5555));
// RangeError: Maximum call stack size exceeded
```

改成尾递归
不过该炸还是要炸

然后就该 y combinator 上场了

---

```javascript
const U = f => f(f);
const Y_LAZY = F => U(g => F(function(...x) {
    const h = (...n) => () => g(g)(...n);
    return h(...x);
}));
const Y = F => (...args) => {
    let out = Y_LAZY(F)(...args);
    while (typeof out === 'function') out = out();
    return out;
};

const fact = Y(f => (n, prod=1) => (n === 1 ? prod : (f(n - 1, n * prod))));

console.log(fact(5555));
// Infinity
```

看下关键点在哪
其实还是 `h`，不过这次不直接计算，而是返回了一个函数
然后在 Y 里面将调用变成了循环

这样就不爆栈了

而这一切都隐藏在了 Y 后面，对使用者是不可见的
