# Cross-Origin Resource Sharing (CORS)

---

https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS#Requests_with_credentials

---

## simple request

+ method 为 `GET` / `HEAD` / `POST` 之一
+ `Content-Type` 为 `application/x-www-form-urlencoded` / `multipart/form-data` / `text/plain` 之一
+ 没有设置非标准的 header（比如 `X-Modified`）

满足上述条件的算是 `simple request`

> The `Access-Control-Allow-Origin` header should contain the value that was
> sent in the request's `Origin` header.

---

## preflighted request

如果不是一个 `simple request`，那么浏览器会先发生一个 `preflighted request`，
用于确认该请求是否安全。

浏览器会向请求的服务发起一个 `OPTIONS` 请求。
请求里的 `Access-Control-Request-Method` 是实际要发送的 `method`，比如 `POST`。
请求里的 `Access-Control-Request-Headers` 是请求会携带的 header，比如 `X-PINGOTHER`。

服务器需要返回
+ `Access-Control-Allow-Origin`，允许的域名
+ `Access-Control-Allow-Methods`，允许的方法
+ `Access-Control-Allow-Headers`，允许的头部
+ `Access-Control-Max-Age`，本次许可的有效期

---

## requests with credentials

XHR 请求设置 `withCredentials=true` 后，
需要服务端在头部返回 `Access-Control-Allow-Credentials: true`。
同时，`Access-Control-Allow-Origin: *` 这种通配符写法是不行的，
必须明确的包含 `Origin` 的值。
