# transducers

---

http://jlongster.com/Transducers.js--A-JavaScript-Library-for-Transformation-of-Data
http://phuu.net/2014/08/31/csp-and-transducers.html
https://speakerdeck.com/othree/transducer

---

`reduce` 是最基础的 `transformation`

其他的 `transformation` 都可以用 `reduce` 实现

比如下面的 map 和 filter

```js
function MAP(array, transform) {
    return REDUCE(array, function REDUCING(result, value) {
        return CONCAT(result, transform(value));
    }, []);
}

function FILTER(array, predicate) {
    return REDUCE(array, function REDUCING(result, value) {
        if (predicate(value)) {
            return CONCAT(result, value);
        } else {
            return result;
        }
    }, []);
}
```

---

`reduce` 的转换函数称为 `reducing function`

其他 `transformation` 就是实现了不同的 `reducing function`

```
function REDUCING(result, value) {
    return CONCAT(result, transform(value));
}

function REDUCING(result, value) {
    if (predicate(value)) {
        return CONCAT(result, value);
    } else {
        return result;
    }
}
```

---

+ transformation 可以 compose
+ reducing function 没办法 compose

---

reducing function transform function, aka transducer
将 reducing function 转换成另一个 reducing function

transducer 可以 compose

---

插入一下 compose 的逻辑

```
f: X -> Y   | y = f(x)
g: Y -> Z   | z = g(y)
g.f: X -> Z | z = g(f(x))
```

compose(g, f)(x) = g(f(x))

到这里，一切都很符合逻辑

但是从程序角度想想，`g` 是第一个参数，却是最后一个执行，感觉就很奇怪了……

---

回到主题，如果对 reducing function 抽出来，就会得到

```

function MAP(array, transform) {
    function MAP_REDUCING(result, value) {
        return CONCAT(result, transform(value));
    }
    return REDUCE(array, MAP_REDUCING, []);
}

function MAP(array, transform) {
    return function(reducing) {
        return REDUCE(array, reducing, []);
    }
}

