# y combinator

---

看完了 little schemer 里关于 y combinator 的内容
目标两个

- 试着自己再推导一次
- 试着扩展到互相调用的情况

---

```javascript
const add1 = (x) => (x + 1);
const empty = (l) => (l.length === 0);
const cdr = (l) => (l.slice(1));

var length0 = function(list) {
	if (empty(list)) return 0;
	return add1(length0(cdr(list)));
};
```

这是直接递归的版本

---

```javascript
var length1 = (function(length) {
	return function(list) {
		if (empty(list)) return 0;
		return add1(length(cdr(list)));
	};
})(...);
```

`length` 不再定义在全局，而是作为一个参数传递进来。
所以，参数应该也需要一个 `length`

---

```javascript
var length1 = (function(length) {
	return function(list) {
		if (empty(list)) return 0;
		return add1(length(cdr(list)));
	};
})(function(list) {
	if (empty(list)) return 0;
	return add1(length(cdr(list)));
});
```

可以看到，上面这样肯定不行
传入的这个函数，本身也需要一个 `length` 的实现
既然要，那就给

---

```javascript
var length1 = (function(length) {
	return function(list) {
		if (empty(list)) return 0;
		return add1(length(cdr(list)));
	};
})(function(length) {
	return function(list) {
		if (empty(list)) return 0;
		return add1(length(cdr(list)));
	};
});
```

可以看到，这么修改之后，调用 `length` 的地方都要再修改一下才行。

---

```javascript
var length1 = (function(length) {
	return function(list) {
		if (empty(list)) return 0;
		return add1(length(length)(cdr(list)));
	};
})(function(length) {
	return function(list) {
		if (empty(list)) return 0;
		return add1(length(length)(cdr(list)));
	};
});
```

到这里，`length1` 已经可以按预期工作了。

可以看到上下结构完全相同，可以做点优化，把共同部分提取一下

---

```javascript
var length2 = (function(l) {
	return l(l);
})(function(length) {
	return function(list) {
		if (empty(list)) return 0;
		return add1(length(length)(cdr(list)));
	};
});
```

对于 length 这个函数本身来说，这样其实就已经比较简洁了
只是对于其他的递归函数，没什么帮助

---

下面这步简化，比较不容易想到

```javascript
var length3 = (function(l) {
	return l(l);
})(function(length) {
	return function(list) {
		if (empty(list)) return 0;
		return add1(
		((x) => length(length)(x))
		(cdr(list)));
	};
});
```

把原来的 `length(length)` 改成了 `(x) => length(length)(x)`
也就是变成了一个 thunk?

---

前面那步奇怪的改写
主要是为了能把整个变量提取出来
看下面
（顺便调整了下变量名

```javascript
var length3 = (function(l) {
	return l(l);
})(function(l) {
	return (function(length) {
		return function(list) {
			if (empty(list)) return 0;
			return add1(length(cdr(list)));
		};
	})((x) => l(l)(x));
});
```

如果没有这个改写，提取出来作为参数时，就被直接调用了
调用的顺序与提取前不同，同时造成了死循环

---

上面的代码，已经分离的比较好了

```javascript
var length3 = (function(l) {
	return l(l);
})(function(l) {
	return (...)((x) => l(l)(x));
});

function(length) {
	return function(list) {
		if (empty(list)) return 0;
		return add1(length(cdr(list)));
	};
}
```

下面是函数的功能，上面是递归的实现，也就是 y-combinator 了

```javascript
var Y = function(F) {
	return ((f) => f(f))((g) => F((x) => g(g)(x)));
};
```

---

下面这个是 SICP 里的习题

```javascript
var f = function(x) {
	var isEven = function(n) {
		return (n === 0 ? true : (isOdd(n - 1)));
	};
	var isOdd = function(n) {
		return (n === 0 ? false : (isEven(n - 1)));
	};
	return isEven(x);
};
```

isEven 和 isOdd 互相调用
前面也说过思路了，递归函数都当作参数来传递。

---

```javascript
var ff = function(x) {
	return (function(isEven, isOdd) {
		return isEven(isEven, isOdd);
	})(
        function(isEven, isOdd) {
            return (n) => (n === 0 ? true : (isOdd(isEven, isOdd)(n - 1)));
        },
		function(isEven, isOdd) {
            return (n) => (n === 0 ? false : (isEven(isEven, isOdd)(n - 1)));
		}
	)(x);
};
```

套一层 `function(isEven, isOdd)` 就可以啦

---

像之前一样提取一个 thunk 就可以转化成

```javascript
var fff = function(x) {
	return (function(isEven, isOdd) {
		return isEven(isEven, isOdd);
	})(
		function(isEven, isOdd) {
			return ((f) => {
				return (n) => (n === 0 ? true : f(n - 1));
			})((x) => (isOdd(isEven, isOdd)(x)));
		},
		function(isEven, isOdd) {
			return ((f) => {
				return (n) => (n === 0 ? false : f(n - 1));
			})((x) => (isEven(isEven, isOdd)(x)));
		}
	)(x);
};
```

---

再提取一下，就有下面的了

```javascript

var Y = function(h1, h2) {
	return (function(f1, f2) {
		return f1(f1, f2);
	})(function(f1, f2) {
		return h1(x => f2(f1, f2)(x));
	}, function(f1, f2) {
		return h2(x => f1(f1, f2)(x));
	});
};

var ffff = Y(
	function(isOdd) {
		return (n) => (n === 0 ? true : isOdd(n - 1));
	},
	function(isEven) {
		return (n) => (n === 0 ? false : isEven(n - 1));
	}
);
```

---

最后加两链接

https://rosettacode.org/wiki/Y_combinator
https://gist.github.com/wardenlym/61f98b6e6e95be3f0e5ff8966da1439b
