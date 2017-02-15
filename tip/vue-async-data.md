# vue async data

---

https://vuejs.org/guide/plugins.html
https://github.com/vuejs/vue-async-data

---

本来还想写写……看了下太水了……

```js
Vue.use(VueAsyncData);
```

最核心的点是，Vue.use 的时候，会调用 VueAsyncData.install。
vue-async-data 在 install 里面更新了 `Vue.options`。
注册了 `created` 和 `compiled` 这两个 `lifecycle hook` 并提供了一个方法 `reloadAsyncData`。

---

值得深入分析的其实是 `Vue.util.mergeOptions`，这里先不展开，了解下 vue 注册插件的方法就好。
