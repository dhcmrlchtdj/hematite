# cookie

---

https://raw.githubusercontent.com/knownsec/KCon/master/KCon%202015/Cookie%20%E4%B9%8B%E5%9B%B0.pdf

---

+ `(name, domain, path)` 决定 cookie 的值
+ 同源限制为 `(domain, path)`，对比 web 的限制 `(protocol, domain, port)`，不区分 http/https，不区分端口
+ `Secure` 可以限制只能 `https` 读取，但是可以被服务端覆盖
