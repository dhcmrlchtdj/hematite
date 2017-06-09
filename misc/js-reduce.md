# reduce

---

+ http://clojure.com/blog/2012/05/15/anatomy-of-reducer.html
+ https://github.com/Gozala/reducers/wiki/IO-Coordination

---

之前介绍过 transducer，用于转换 reducing function
能够将数据操作给组合起来

想要发挥更多的价值，就要在 reduce 上下功夫

---

```
var reduce = function(reducing_function, initial, arr) {
    var result = initial;
    for (var i = 0, ii = arr.length; i < ii; i++) {
        result = reducing_function(result, arr[i]);
    }
    return result;
};
```

---

reducing function 只是在处理数据

如果想要并行处理，就将循环并行化

如果想要延迟求值，就在取值时执行下一个循环
