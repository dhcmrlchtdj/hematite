# SRP

---

http://srp.stanford.edu/
https://en.wikipedia.org/wiki/Secure_Remote_Password_protocol
https://iovxw.net/p/srp.html
https://protonmail.com/blog/encrypted_email_authentication/
https://github.com/mozilla/node-srp

---

常见密码方案

- Weak Authentication，比如 HTTP 传递密码
- Multifactor Authentication，比如密码再加上 OTP
- Strong Password Authentication，比如 SRP
- Pseudo-Strong Authentication，比如 SSH / TLS

---

> SRP is a secure password-based authentication and key-exchange protocol
> SRP is an augmented password-authenticated key agreement (PAKE) protocol

SRP 即 Secure Remote Password protocol，是一种 PAKE 协议
基于密码
用于认证、密钥交换协议

---

密码交换协议，通常会遇到这些问题

- 攻击者知道协议细节
- 攻击者手中有常用密码字典
- 攻击者能够窃听、伪造用户与服务器间的通信
- 没有可以信赖的第三方验证服务

---

> strong security can be obtained using weak passwords
即使使用弱密码，还是能够获得较高的安全性

> server does not store password-equivalent data
服务器不存储密码

> conveys a zero-knowledge password proof from the user to the server
用户向服务器提供了关于密码的零知识证明

> both the user and server while never sending any password-equivalent data over the network
通信过程不会涉及到用户密码

> client side having the user password
> server side having a cryptographic verifier derived from the password
服务端是一个验证工具？

---

- 注册的时候
	用户端用 `id,password,salt` 生成 `verifier`
	然后把 `id,salt,verifier` 发送给服务端
- 登录的时候
	用户端把 `id` 发到服务器，获取 `salt`

认证过程

```
Client:                             Server:
 p = params["2048"]                  p = params["2048"]
 s1 = genKey()                       s2 = genKey()
 c = new Client(p,salt,id,pw,s1)     s = new Server(p,verifier,s2)
 A = c.computeA()            A---->  s.setA(A)
 c.setB(B)                <-----B    B = s.computeB()
 M1 = c.computeM1()         M1---->  s.checkM1(M1) // may throw error
 K = c.computeK()                    K = s.computeK()
```

> server check M1 to determine whether or not the client really knew the password

M1 正确说明用户知道密码
由于 AB 都是随机的，所以 M1 是一次性的

最后得到的 K 是个 strong random string，可以在后续通信中用于数据验证
而 K 本身不需要在网络间传输
