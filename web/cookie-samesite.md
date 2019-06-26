# SameSite cookie

---

https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies#SameSite_cookies
https://www.owasp.org/index.php/SameSite
https://hapijs.com/api/#-serverstatename-options

---

一直感觉自己很懂 cookie，没想到还是栽了跟头。
hapi 默认开启了 `SameSite` 这个属性，导致跨域请求带不上 cookie。😂
