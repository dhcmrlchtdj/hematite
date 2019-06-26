# d3 vs vdom

https://blogs.janestreet.com/introducing-incremental/

---

https://blogs.janestreet.com/incrementality-and-the-web/

---

- virtual DOM is level-triggered
    - view depends only on the current value of the state
- D3 is edge-triggered
    - display logic can depend on the precise transition that's occurring

（在 epoll 里面，我们一般用 level trigger 吧

---

https://blogs.janestreet.com/self-adjusting-dom/
https://blogs.janestreet.com/self-adjusting-dom-and-diffable-data/

---

- model
    - 数据
- actions
    - 页面上需要处理的事件
- view
    - 页面

```ocaml
module type App_intf = sig
    module Model : sig
        type t
    end

    module Action : sig
        type t
        val apply : t -> Model.t -> Model.t
    end

    val view : Model.t -> (Action.t -> unit) -> Vdom.t
end

val start_app
    : (module App_intf with type Model.t = 'model)
    -> init:'model
    -> unit
```

---

作者认为 vdom 不适合变化较多的场景。
每次变化都要生成 vdom，从理论角度就输了。
（实际来看，还算够用？

后面还没仔细看，不过 Incremental 应该是双向绑定？
说的 SAC 应该是类似于 SICP 里面那种自动触发吧？

---

> use Incremental to optimize generation of the vdom

打脸太快，Incremental 还是作用于 vdom 的

---

看了一圈还是不太懂……
