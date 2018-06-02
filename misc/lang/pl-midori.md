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

- 通过 type, memory, concurrency safety 实现 security
- 使用 capabilities 实现 security (access control
- 依靠编程语言及其类型系统，约束 capabilities

---

在 unix 下面，通过判断 user/group 的权限实现访问控制。
（比如 `open("filename", O_RDONLY)` 这样的调用
这样的权限检查属于运行时行为，带有不确定性。

个人想法。没想明白。
希望把验证放到编译期，意味着把信息放到类型中（？）。
这要怎么放进去呢？确实是运行时的信息吧。
但话也不能说绝对，idris 那样的类型系统，确实能持有更多类型信息。
只是我自己懂得不够多。

想在文件系统实现 capability，需要从系统设计层面提供支持。
比如 Linux Capabilities。

---

- capability 被实现成一个 object（可以复用 OO 中关于 security / authority 的实践经验
- 关于 Distributed Capabilities，没看懂。大意是 unforgeable token 可传递？
    - 是不是有点像 ownership 的传递？或者是类似于消息传递，传递了实体？

---

## Asynchronous Everything

---



