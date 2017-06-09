# debugger chrome network

---

```
window.addEventListener("beforeunload", function() { debugger; }, false);
```

chrome 在页面跳转的时候，network 面板不会记录完整的 xhr 请求信息。
可以在页面上加一个 beforeunload 监听，让页面跳转停下来，就能看到 response 了。
