# ECH

https://blog.cloudflare.com/encrypted-client-hello/

---

ESNI 出师未捷身先死

---

问题，即使使用 TLS 加密通信，还是要 SNI 里明文告知服务器使用哪个服务。
ESNI 的解决方案是对 SNI 字段加密。

blog 里拿 ALPN 举例，TLS 连接时还携带了其它明文信息。
ECH，顾名思义，对整个 client hello 加密。

---

> A necessary ingredient for addressing all of these privacy leaks is handshake encryption
> how do the client and server pick an encryption key if the handshake is itself a means of exchanging a key

要对 handshake 加密，但是怎么加密？
handshake 本身就是用来决定后续如何加密的。

> In general, ensuring confidentiality of handshake parameters used for
> authentication is only possible if the client and server already share an
> encryption key.
> But where might this key come from?

> The main problem these mechanisms must solve is key distribution.

> DoH provides an authenticated channel for transmitting the ESNI public key
> from the DoH server to the client.

> the ESNI server aborts the connection if decryption fails

通过 DoH 分发 key 的一大问题是对 CDN 支持有限。
比如多个供应商，各自有不同的 key。

---

> (ECH) Similar to ESNI, the protocol uses a public key, distributed via DNS
> and obtained using DoH, for encryption during the client's first flight.
ECH 也是用 DoH 分发 key。

> the ECH protocol actually involves two ClientHello messages:
> the ClientHelloOuter, which is sent in the clear, as usual;
> and the ClientHelloInner, which is encrypted and sent as an extension of the ClientHelloOuter.
这个是为了解决分发的 key 不对的情况。
如果服务器能解密 ClientHelloInner，直接连接 inner。
如果 key 不对，server 会使用明文的 ClientHelloOuter 和建立连接再返回正确的 key，之后 client 重新开始 handshake。

> the ClientHelloOuter contains an SNI value
虽然 ClientHelloInner 是加密的，但 ClientHelloOuter 是明文。
如果 inner/outer 是一样的，其实就没多大意义的。使用 CF 之类的服务套个壳才有隐藏服务的效果。
（有网友说，“其实就是域前置的正式版”
