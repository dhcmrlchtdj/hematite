# generator

---

https://leanpub.com/understandinges6/read#leanpub-auto-iterators-and-generators
https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Generator
https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/yield*
https://github.com/getify/You-Dont-Know-JS/blob/master/async%20%26%20performance/ch4.md

---

- yield cannot cross function boundaries

和 return 有点像，作用域只在当前函数里。
嵌套一个函数，然后调用 yield 是语法错误

---

- values() / keys() / entries()

有这些内置的 iterator

---

- generator#next()
	- 返回给 `yield`
- generator#throw()
	- 返回给 `yield`，可以被 `try...catch`
	- 效果同在 generator 里 throw
- generator#return()
	- 返回给调用 generator 者，同时结束 generator（`done: true`）
	- 效果同在 generator 里 return
	- `for...of` 会无视 return 的返回，因为 `done: true`

结束的 generator（`done: true`）
调用 next 只返回 undefined
调用 throw/return 还是会抛异常或返回

---

- `yield *` / delegate generator
- 会委托给下层的 generator，所以 throw() 和 return() 都作用于下层
- `yield *` 本身返回值为下层 generator 里 `return` 的值（或者 generator#return

---

https://github.com/tc39/ecmascript-asyncawait
https://tc39.github.io/ecmascript-asyncawait/#desugaring
https://github.com/tc39/proposal-async-iteration

---

- `async function <name>(<argument>) {<body>}`
- `function <name>(<argument>) { return spawn(function*() {<body>}, this); }`

```javascript
function spawn(genF, self) {
    return new Promise(function(resolve, reject) {
        var gen = genF.call(self);
        function step(nextF) {
            var next;
            try {
                next = nextF();
            } catch (e) {
                // finished with failure, reject the promise
                reject(e);
                return;
            }
            if (next.done) {
                // finished with success, resolve the promise
                resolve(next.value);
                return;
            }
            // not finished, chain off the yielded promise and `step` again
            Promise.resolve(next.value).then(function(v) {
                step(function() {
                    return gen.next(v);
                });
            }, function(e) {
                step(function() {
                    return gen.throw(e);
                });
            });
        }
        step(function() {
            return gen.next(undefined);
        });
    });
}
```

