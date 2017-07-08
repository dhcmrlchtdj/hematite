# Lwt

---

https://stackoverflow.com/questions/15611972

https://mirage.io/wiki/tutorial-lwt
https://github.com/dkim/rwo-lwt/blob/master/README.md
https://ocsigen.org/lwt/3.0.0/api/Ppx_lwt

http://rwo.ocamllabs.io:8080/18-concurrent-programming.html
https://github.com/janestreet/ppx_let

---

> avoiding the performance compromises and synchronization woes of preemptive
> threads without the confusing inversion of control that usually comes with
> event-driven systems.

lwt 和 async 都使用 event loop / promise 来实现异步。
同时使用 monad 来避开 callback 造成的代码碎片化和 IOC。

---

```ocaml
val return : 'a -> 'a Lwt.t
val bind : 'a Lwt.t -> ('a -> 'b Lwt.t) -> 'b Lwt.t

val map : ('a -> 'b) -> 'a Lwt.t -> 'b Lwt.t
```

就是 monad 的接口啦。
另外这个 map 在实际编写中确实很实用，也正好符合 haskell 里面 monad 继承 functor。

---

```ocaml
let x =
    let a = get_input "Enter a" in
    let b = get_input "Enter b" in
    a + b

let x =
    get_input "Enter a" >>= fun a ->
    get_input "Enter b" >>= fun b ->
    return (a + b)

let x =
    let%lwt a = get_input "Enter a" in
    let%lwt b = get_input "Enter b" in
    return a + b
```

虽然靠着语法糖，可以把异步代码写得很漂亮，但是传染性的问题似乎都一样？

另外，感觉就异步编程这个场景，可能 ppx 还是没有 async/await 来得甜？
因为像异常之类的，都要用 ppx 改写。

---

https://blogs.janestreet.com/announcing-async/
http://rgrinberg.com/posts/abandoning-async/
http://lists.ocaml.org/pipermail/wg-parallel/2013-April/000000.html

---

opam 上 lwt 和 async 的下载量，说明 ocaml 社区小得可怜……

---

> They are currently two big semantic divergences in the kernel of both
> libraries: execution order and error handling.

- Semantic of bind

在执行 `x >>= f` 的时候。
如果 x 已经有结果了，lwt 会立刻执行。
而 async 始终会等到下一轮循环再执行。

- Error handling

Lwt.t 包括正常值和异常，而 Deferred.t 只包含正常值。
所以两边在编码时，异常处理方式会不一样。

- Local storage

- Scheduler
- Portability

lwt 的核心不包括调度器，是只依赖了标准库的纯 ocaml 的实现。
async 则自带调度器，依赖一些 unix 和 c 的实现。

- General experience

async 和 core 都建议使用 open，对代码侵入性更高？
lwt 显得更独立一些。

---

前面列举的这些区别
- bind 语义应该是最关键的？
- t 具体类型更多是编码使用上的差异
- 其他则是具体实现了，无所谓
