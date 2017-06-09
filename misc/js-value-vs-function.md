# js value / function

---

http://blog.vjeux.com/2015/javascript/140byt-es-curried-add-function.html

---

```
console.log(add(1, 2) == 3);
console.log(add(3)(4)() == 7);
console.log(add(3)(4)(5) == 12);
```

简单讲，`add` 的返回值是个函数，但是又可以直接当成某个值来操作。
（注意上面用的是 `==`，应该肯定是个函数，所以 `===` 的类型判断过不去）

---

直接把结果列一下，valueOf/toString 还能这么玩以前真没想到。

```
var add = (...args) => {
    var sum = args.reduce((a, b) => a + b);
    var fn = (...args) => add(sum, ...args);
    fn.valueOf = () => sum;
    return fn;
};
```

```
function add(){
    var s=[].reduce.call(arguments,function(a,b){return a+b});
    var f=function(){return add.apply(0,[s].concat([].slice.call(arguments)))};
    f.valueOf=function(){return s};
    return f;
}
```

```
function add(s,a){return(a=add.bind(0,s=[].join.call(arguments,'+'))).toString=eval.bind(0,s),a}
```
