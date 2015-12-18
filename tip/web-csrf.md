# CSRF

---

https://github.com/pillarjs/understanding-csrf
<https://www.owasp.org/index.php/Cross-Site_Request_Forgery_(CSRF)>

---

控制好 CORS
GET 不要有副作用

---

form 的 enctype 不支持 application/json
所以使用 json 接口，控制好跨域请求，可以防止 CSRF

---

form 的 method 只支持 get 和 post
所以使用 put delete 等方法，也能防止 CSRF

---

token

渲染页面时插入一个 token，提交数据时发送该 token。
需要前后端协作。
