# y combinator

---

上一篇，已经完全乱了……
还是自己理解完全自己写一下

---

## y combinator 是什么

y combinator 是一个 fixed point combinator，不动点组合子
这并不是唯一一个，只是这个碰巧（？）被 Haskell Curry 遇上了

---

## y combinator 是什么

1. `x=F(x)` 时，x 称为 F 的不动点
2. 这里考察的都是函数，即 x 为函数的情况（高阶函数啦，泛函啦，functional 啦
3. 假设 F 存在不动点 `x=Y(F)`，则有 `Y(F)=F(Y(F))`
4. Curry 找到了这么一个满足上述条件的 Y，`Y = λf.(λx.f(x x))(λx.f(x x))`
5. 这个 Y 就被叫做 y combinator

```
Y = λf.(λx.f(x x))(λx.f(x x))
Yg = (λx.g(x x))(λx.g(x x))			# 定义
	= g((λx.g(x x)) (λx.g(x x)))	# 右边代入左边，x=(λx.g(x x))
	= g(Yg)							# 括号内根据定义替换
即
Yg = gYg
```

---

## y combinator 能干什么

lambda 演算中没有变量名，所以无法直接递归
Curry 用 y combinator 实现了递归

换句话说，可以用 y combinator 实现递归

既然语言本身已经提供了递归了，为什么还要绕个圈子用 y combinator 实现一遍？
前面王垠的文章里，是从递归中提炼出了 y combinator
可以认为 y combinator 是递归的本质属性之一？

---

## 前面哪有什么递归

先用代码定义一下 y combinator

```
(define Y
  (lambda (f)
    ((lambda (u) (u u))
     (lambda (x) (f (lambda (t) ((x x) t)))))))
```

```js
let Y = function(f) {
    let U = function(u) {
        return u(u);
    };
    return U(function(x) {
        return f(function(t) {
            let xx = x(x);
            return xx(t);
        });
    });
};
```

```py
Y = lambda f: (lambda u: u(u))(lambda x: f(lambda t: (x(x))(t)))
```

---

## 如何使用 y combinator

有了前面定义的 Y，再描述一下递归的过程
就可以得到会递归的函数了

```js
let f = Y(function(fact) {
    return function(n) {
        if (n <= 1) {
            return 1;
        } else {
            return n * fact(n - 1);
        }
    };
});
console.log(f(10));
```

```py
f = Y(lambda fact: (lambda n: 1 if n <= 1 else n * fact(n - 1)))
print(f(10))
```

怎么说呢……py 的 lambda 确实不好使
对于我们自己定义的函数来说，递归的调用本身变成了函数参数
让我有种被骗的感觉

不过，其实关键也就在这个地方了
把递归提取出来，作为参数传入

---

试了下，node 在 f(8000) 的时候，py 在 f(500) 的时候，都爆栈死掉了
（差好大呀，不过 js 在 f(200) 时就只输出 infinity 了……
直接递归，py 也在 fact(1000) 的时候爆炸了

---

## 优化改进

可以用来优化尾递归避免在 py/js 里爆栈
可以中间做一层 memoization

不过怎么说呢……
这些优化在递归也都能直接用，并不是 y combinator 带来

真正有点意思的，其实就是对递归的提取？
