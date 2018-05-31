# midori

---

http://joeduffyblog.com/2015/11/03/blogging-about-midori/

---

## A Tale of Three Safeties

---

- 三种不同类型的安全
    - memory safety
    - type safety
    - concurrenct safety

---

> The answer is surprisingly simple: layers.

> There was of course some unsafe code in the system.
> Each unsafe component was responsible for "encapsulating" its unsafety.

硬件、软件、网络，可能出问题的地方很多。
为了实现前面三种不同类型的安全，使用安全的语言编写重写整个系统。
只有少量的 OS 内核使用不安全的语言，把不安全的部分，限制在最少。

---

> we banned unsafe concurrency

至于并发，按我理解，这里提及了 erlang/go 的消息传递机制及 rust 的所有权机制。

---



