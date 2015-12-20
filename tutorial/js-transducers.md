# transducers

---

+ http://phuu.net/2014/08/31/csp-and-transducers.html
+ https://speakerdeck.com/othree/transducer
+ http://jlongster.com/Transducers.js--A-JavaScript-Library-for-Transformation-of-Data
+ http://clojure.org/transducers

---

transducers are composable algorithmic transformations

+ reducing function transformers
+ 与输入、输出解耦，只关注核心的转换过程
+ 独立于输入输出，可以用于各种不同的数据结构
+ 只进行转换，可以轻易的组合起来

---

```
array.reduce(reducing_function, initial);
```

```
// reducing function signature
whatever, input -> whatever
```

```
transducer signature
(whatever, input -> whatever) -> (whatever, input -> whatever)
```

`transducer` 是 `reducing function` 到 `reducing function` 的转换

---

首先，reduce 是最核心的转换函数

以 map 为例

```
var inc = function(input) {
    return (input + 1);
};
[1,2,3,4].map(inc); // [2,3,4,5]
```

用 reduce 可以改写成

```
var concat = function(arr, input) {
    arr.push(input);
    return arr;
};
[1,2,3,4].reduce(function(result, input) {
    return concat(result, inc(input));
}, []); // [2,3,4,5]
```

看起来繁琐很多，稍加改造，可以得到

```
var map = function(transform, arr) {
    return arr.reduce(function(result, input) {
        return concat(result, inc(input));
    }, []);
};
map(inc, [1,2,3,4]); // [2,3,4,5]
```

---

再一样分析下 filter

```
var isEven = function(input) {
    return (input % 2 === 0);
};
[1,2,3,4].filter(isEven); // [2,4]
```

用 reduce 改写

```
[1,2,3,4].reduce(function(result, input) {
    if (isEven(input)) {
        return concat(result, input);
    } else {
        return result;
    }
}, []); // [2,4]
```

再简化成

```
var filter = function(predicate, arr) {
    return arr.reduce(function(result, input) {
        if (predicate(input)) {
            return concat(result, input);
        } else {
            return result;
        }
    }, []);
};
filter(isEven, [1,2,3,4]); // [2,4]
```

---

下面我们要做的，是对 map/filter/reduce 这些转换进行组合

```
[1,2,3,4].filter(isEven).map(inc); // [3, 5]
map(inc, filter(isEven, [1,2,3,4])); // [3,5]
```

如果想要把过程抽象出来，可以

```
var incEven = function(arr) {
    return arr.filter(isEven).map(inc);
};
incEven([1,2,3,4]);

var incEven = function(arr) {
    retrun map(inc, filter(isEven, arr));
};
incEven([1,2,3,4]);
```

再进一步，把 `incEven` 的构造抽象出来

```
var compose = function(f, g) {
    return function(arr) {
        return f(g(arr));
    };
};
var incEven = compose(
    map.bind(null, inc),
    filter.bind(null, isEven)
);
incEven([1,2,3,4]);

// compose(['map', inc], ['filter', isEven]);
```

原生写法，在一次性使用时，可能更简单些。
但是在组合、复用的时候，写法就变得繁琐了。

---

稍微回到主题，transducer 是真对 reducing function 的转换
那么，其结果肯定是用于 reduce 的

我们再对上面的 map/filter 进行一些研究
期待的形式，应该是类似于这样的

```
arr.reduce(mapping(inc), []);
arr.reduce(filtering(isEven), []);
arr.reduce(compose(
    mapping(inc),
    filtering(isEven)
), []);
```

动手改造一下

```
var map = function(transform, arr) {
    return arr.reduce(function(result, input) {
        return concat(result, inc(input));
    }, []);
};

var mapping = function(transform) {
    return function(result, input) {
        return concat(result, transform(input);
    };
};
```

```
var filter = function(predicate, arr) {
    return arr.reduce(function(result, input) {
        if (predicate(input)) {
            return concat(result, input);
        } else {
            return result;
        }
    }, []);
};

var filtering = function(predicate) {
    return function(result, input) {
        if (predicate(input)) {
            return concat(result, input);
        } else {
            return result;
        }
    };
};
```

前后对比一下可以看到，我们把 arr.reduce 和 [] 去掉了，隔离了输入输出
不过，埋了一个小坑，我们要知道如何将输入转换成输出，也就是 concat

```
var mapping = function(transform) {
    return function(update) {
        return function(result, input) {
            return update(result, transform(input));
        };
    };
};

var filtering = function(predicate) {
    return function(update) {
        return function(result, input) {
            if (predicate(input)) {
                return update(result, input);
            } else {
                return result;
            }
        };
    };
};

// arr.reduce(mapping(inc)(concat), []);
// arr.reduce(filtering(isEven)(concat), []);
```

到这里，我们再仔细看一下两段代码

```
var concat = function(arr, input) {
    arr.push(input);
    return arr;
};

var mapping = function(transform) {
    return function(update) {
        return function(result, input) {
            return update(result, transform(input));
        };
    };
};

mapping(inc)(concat)
```

这里，我们得到了一个 (whatever, input -> whatever) -> (whatever, input -> whatever) 的转换
也就是我们前面说的 transducer

---

```
var compose = function(f, g) {
    return function transducer(reducing) {
        return g(f(reducing));
    };
};

var incEven = compose(mapping(inc), filtering(isEven));

arr.reduce(incEven(concat), []);
```

compose 就是我们前面说的可组合的具体体现
并且组合是针对 reducing function 进行的，数据处理一步到位，没有中间分配的过程

不过 compose 的顺序确实很容易让人迷惑
不喜欢的话，改造 API 变成链式调用也是可以的

```
var incEven = filtering(isEven).mapping(inc);
arr.reduce(incEven(concat), []);
```

---

transducer 很纯粹，只是帮我们构造 reducing function

JS 原生的只有 Array#reduce
想要用在其他地方，其实还是需要我们构建自己的 reduce 函数
同时，构建自己的 reduce 函数，还能带来许多其他特性，比如延迟求值等
