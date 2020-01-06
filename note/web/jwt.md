# JWT

---

https://jwt.io/introduction/

---

以前也记过一次 JWT，那个时候对加密相关的概念还非常模糊。
现在，应该能理解得更全面些。毕竟也不会是什么特别复杂的东西。

---

+ Header 指定算法，公开字段
+ Payload 保存具体信息，公开字段
+ Signature 对前面两者进行签名，结果也是公开字段

合并起来，就有了 `Header.Payload.Signature`

考虑 HMAC 签名的场景。
只要保证 secret 不被窃取，其他东西怎么公开都无所谓啦。
需要做的、能够做的，只是验证 payload 的正确性。

嗯，就这样，没了
