# key exchange

---

https://www.crypto101.io/

---

key exchange 要解决的问题是：如何在明文通信的情况下，构造出一个加密通道。
这里的明文通信，意味着构造加密通道的过程是公开的，其他人能够获得完整通信内容。
需要注意，这里解决的是信息被人窃听的问题，没有解决信息被人替换的问题。
（对于 MITM，HTTPS 的做法是客户端内置 CA，SSH 的做法是自己验证服务端指纹，这里不展开了）

---

下面要介绍的方法是 `Diffie-Hellman`。
有基于 discrete logarithm 和基于 elliptic curve 这两种常见的实现方式。

其中的想法，大概是这样的。

寻找这样一种函数 `f(g(x, a), b) = f(h(x, b), a)`。
先是公开交换 x。
然后，A 生成一个 a 和 G=g(x, a)，B 生成一个 b 和 H=h(x, b)，然后交换 G 和 H。
最后，A 可以生成 F=f(H, a)，B 可以生成 F=f(G, b)，两边就有了私有的 F。

整个过程中，x/G/H 都是公开交换的，包括计算用的 f/g/h 这三个函数也是公开的，
只有 a/b 是私有的。
其他人想要破解出 F，要么直接从 G/H 计算出 F，要么从 G/H 破解出 a/b。
这个破解难度，就是靠前面提到的 discrete logarithm / elliptic curve 保证的。
