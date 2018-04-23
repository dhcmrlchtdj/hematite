# cross origin

---

https://developer.mozilla.org/en-US/docs/Web/HTML/CORS_settings_attributes
https://github.com/getsentry/raven-js/blob/master/docs/usage.rst#cors
https://stackoverflow.com/questions/5913978/cryptic-script-error-reported-in-javascript-in-chrome-and-firefox#answer-11118927

---

CDN 通常会单独设置一个域名，因为跨域的关系，会导致无法获取异常信息。

解决方法就是加上 `crossorigin="anonymous"`，比如 `<script src="https://cdn.ravenjs.com/3.17.0/raven.min.js" crossorigin="anonymous"></script>`。
这样浏览器在 script 的请求里加上相关的 header，就能捕捉到了。
