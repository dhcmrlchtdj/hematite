# service worker

---

https://developers.google.com/web/fundamentals/primers/service-workers/
https://developers.google.com/web/fundamentals/primers/service-workers/lifecycle
https://developers.google.com/web/fundamentals/instant-and-offline/offline-cookbook/

---

关于 service worker 的文章都好乱，各种找不到重点
google 的几篇质量算好的了

---

先是加载 service worker 配置

```javascript
navigator.serviceWorker.register('/sw.js')
    .then(reg => console.log('SW registered!', reg))
    .catch(err => console.log('Boo!', err));
```

---

然后主要是 `install / activate / fetch` 三个事件
顺序上来说，先 `install`，然后被 `activate`，接下来可以处理 `fetch`

---

`fetch` 在 cookbook 那篇文章里讲的比较多。
主要是缓存和网络这两种请求方式的选择、组合。

```javascript
self.addEventListener("fetch", event => {
    const done = caches
        .match(event.request)
        .then(resp => resp || fetch(event.request));
    event.respondWith(done);
});
```

---

`install` 用来初始化，确定要缓存哪些东西。

```javascript
self.addEventListener("install", event => {
    const done = caches
        .open('CACHE_VERSION')
        .then(cache => cache.addAll(['/']));
    event.waitUntil(done);
});
```

---

`activate` 这里被用来清理过期缓存

```javascript
self.addEventListener("activate", event => {
    const done = caches.keys().then(keyList => {
        const cs = keyList
            .filter(key => key !== 'CACHE_VERSION')
            .map(key => caches.delete(key));
        return Promise.all(cs);
    });
    event.waitUntil(done);
});
```

---

一开始的时候，愣是没搞懂怎么更新 `sw.js`
感觉修改后刷新页面没生效

发现还能手动强制刷新

```javascript
navigator.serviceWorker.register('/sw.js').then(reg => reg.update())
```
