# WordPress Nonces

---

https://codex.wordpress.org/WordPress_Nonces

---

nonce: Number used ONCE

---

- nonce is a hash made up of numbers and letters.
- nonce has a limited "lifetime" before expiring.
- nonce help protect against several types of attacks including CSRF.
- nonce do not protect against replay attacks because they aren't checked for one-time use.
- nonce should never be relied on for authentication or authorization, access control.

wp nonce 的特点以及不能用来干什么

---

发现没找到什么相关文章……
其实最早看到，是在 zhihu 上看有人说生成一个 token，一定时间內，生成的 token 是一致的。
当时怎么实现的，瞄了眼忘记了……

看到网上的一个 php 实现，直接 current_timestamp + 60 作为有效时间，觉得好粗暴……
再想想大概也就这样？

`Math.ceil(Date.now()/1000/10).toString(16)`，这样就能有个 10s 內不变的 token。
wp 的实现，估计是也在 hash 前的数据里加上时间戳？
