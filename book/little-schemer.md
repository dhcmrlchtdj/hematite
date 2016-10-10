# the little schemer, 4th

---

http://the-little-schemer.readthedocs.io/zh_CN/latest/index.html

---

## 8. lambda the ultimate

主要讲了两点

### 函数抽象

> What you have just seen is the power of abstraction.

> The Ninth Commandment
> Abstract common patterns with a new function.

保留公共部分，不同部分抽离成函数。
将函数作为参数传入，构造出真正需要的函数。

### CSP

> The Tenth Commandment
> Build functions to collect more than one value at a time.

没有赋值加上递归调用，所以用这种方式来整合返回值。
最外层给出的回调接收返回值
内层的递归调用中，会创建一个新的回调，回调里构造返回值，传递给外层的回调

---

## 9

+ partial function
+ total function

partial function 还是递归函数
但是并不保证在递归时，有逐步接近终止条件
最糟的情况就是出现无限循环了
