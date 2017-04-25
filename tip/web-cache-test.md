# browser http cache

---

https://www.mnot.net/blog/2017/03/16/browser-caching

---

- `Cache-Control: no-store` 不会缓存
- `Cache-Control: no-cache` 总是会请求验证
- `Expires` 如果是不标准的，就直接视为过期的
- 否则 `Cache-Control: max-age` 的优先级比 `Expires` 要高

max-age/no-store/no-cache 在各浏览器中表现都很符合预期。

没有指明 age 的情况下，浏览器还是会缓存 200 的请求

---

- `Vary` 在所有浏览器下都有效

---

## status code

状态与缓存的关系，之前都没留意过。

> any status code with a freshness lifetime can be cached

理论上，明确指定了过期时间的情况下，任何状态码应该都可以缓存。
但只有 chrome 这么做了，其他浏览器都有一些不缓存的状态码。

---

## method

不安全的方法，比如 POST/PUT/DELETE，即使成功也不会被缓存。
