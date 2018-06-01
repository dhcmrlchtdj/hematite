# midori

---

http://joeduffyblog.com/2015/11/03/blogging-about-midori/

---

## Blogging about Midori

---

> programming language, compilers, OS, services, applications, programming models
> language, compilers, core frameworks, concurrency models, and IDEs/tools

巨大的野心

> Most of my blog entries will focus on the key lessons that we're now trying to
> apply back to the products, like asynchrony everywhere, zero-copy IO,
> dispelling the false dichotomy between safety and performance,
> capability-based security, safe concurrency, establishing a culture of
> technical debate, and more.

复盘，对于成长有重要意义。

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

## Objects as Secure Capabilities

---


