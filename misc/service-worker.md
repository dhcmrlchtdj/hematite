# service-worker

---

https://developers.google.com/web/fundamentals/primers/service-worker/

---

serviceWorker 要求页面必须是 HTTPS。
为了方便开发，也允许 localhost。
这个比较容易满足，所以倒也没什么。

---

```
if ('serviceWorker' in navigator) {
    navigator.serviceWorker.register('/sw.js')
        .then(function(registration) {
            console.log('ServiceWorker registration successful with scope: ', registration.scope);
        }).catch(function(err) {
            console.log('ServiceWorker registration failed: ', err);
        });
}
```

+ 这段代码可以测试是否支持 serviceWorker。
+ 不会重复 register，所以重复执行也没关系。
+ serviceWorker 的脚本看需求要不要放在根目录，脚本的 scope 是固定的。

---

debug 异常困难？
