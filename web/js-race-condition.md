# race condition

---

https://tc39.github.io/ecma262/#sec-assignment-operators-runtime-semantics-evaluation
https://twitter.com/jaffathecake/status/999269332889763840

---

```javascript
let x = 0;

async function test() {
    x += await 2;
    console.log(x);
}

test();
x += 1;
console.log(x);
```

一般认为，js 单线程所以不会发生竞态。
今天这个例子刷新三观。

过程，规范里是有表述的。
例子里的 `x += await 2`
参与加法的两个值，先求左值，再求右值。
左值的结果被保存了，右值移步交出控制权。相当于形成了闭包。

取值再计算的过程，不是原子化的。导致了竞态。

结论的话，应该是避免让 await 表达式参与运算。
