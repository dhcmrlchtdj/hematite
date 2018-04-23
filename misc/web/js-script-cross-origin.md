# script cross origin

---

https://blog.sentry.io/2016/05/17/what-is-script-error

---

几年前搞错误收集，就知道有这个问题
一直没在意

---

## 问题

`window.onerror` 收集不到具体错误信息，只知道 `script error`

```
"Script error.", "", 0, 0, undefined
```

---

## 解决方案

页面设置

```
<script src="https://another-domain.com/src.js" crossorigin="anonymous"></script>
```

服务端返回

```
Access-Control-Allow-Origin: https://another-domain.com
```

就可以得到

```
"ReferenceError: bar is not defined", "http://another-domain.com/src.js", 2, 1, [Object Error]
```

---

另一个方案是用 `try...catch` 包括问题代码
不过对于自执行的就没效果了吧
