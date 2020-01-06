# oauth2

---

https://aaronparecki.com/oauth-2-simplified/
https://www.oauth.com/

---

- resource owner (user)
- resource server (api)
- authorization server (api, too)
- client (third-party application)

---

- register
    - 第三方应用向服务器注册
    - 注册时需要一个重定向地址，用户认证后返回该地址
    - 如果走 http，要求上 TLS
    - 服务器会分配 id 和 secret 给应用，其中 secret 应用自己藏好
- authorization
    - 协议规定了多种认证方式，grant types
        - authorization code
        - password
        - client credentials
    - authorization code
        - 一开始，从客户端跳转到服务器，携带 `response_type=code&client_id=&redirect_uri=&scope=&state=`
        - 用户在服务器确认后，带回 `code=&state=`，其中 state 就是刚才发送的 state
        - 客户端再用 code 去服务器做校验，`grant_type=authorization_code&code=&redirect_uri=&client_id=&client_secret=`
        - 服务端会返回 `access_token`
    - 得到 token 后，即可使用该 token 来请求服务器上的资源了
        - http header `Authorization: Bearer <token>`
