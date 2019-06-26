# vm.runInNewContext

https://blog.cloudflare.com/cloud-computing-without-containers/
https://nodejs.org/api/vm.html#vm_vm_runinnewcontext_code_sandbox_options

---

出于对 cloudflare worker 的兴趣，重新看了下 node 的 vm.runInNewContext。

---

cloudflare 的背景

- lua 没有在容器里运行，不能让用户执行任意代码
- kubernetes 等容器技术，每次调用都新建容器，开销太大

最后 cloudflare 选择依靠 V8 的 isolates 实现隔离。

比新建 node 进程更轻量。
启动速度上，新建一个 isolates 只需要 5ms。
内存占用上，一个 isolates 只需要 3MB，而完整的 node 进程需要 35MB。

---

https://github.com/nodejs/node/blob/v10.13.0/src/node_contextify.cc#L793

不太清楚 cloudflare 直接使用了 V8 还是使用了 node
跟了下 node `vm.runInNewContext` 的代码，也是 isolate 实现的。

```javascript
const vm = require("vm");
let m1, m2, s1, s2, delta;

[m1, s1] = process.hrtime();
(() => {
    const fib = n => {
        if (n <= 2) {
            return 1;
        } else {
            return fib(n - 1) + fib(n - 2);
        }
    };
    fib(40);
})();
[m2, s2] = process.hrtime();

delta = ((m2 - m1) * 1e9 + (s2 - s1)) / 1e6;
console.log(delta);

[m1, s1] = process.hrtime();
vm.runInNewContext(`
(() => {
    const fib = n => {
        if (n <= 2) {
            return 1;
        } else {
            return fib(n - 1) + fib(n - 2);
        }
    };
    fib(40);
})();
`);
[m2, s2] = process.hrtime();
delta = ((m2 - m1) * 1e9 + (s2 - s1)) / 1e6;
console.log(delta);
```

测试了几次，确实差异不大。
