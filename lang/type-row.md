# row polymorphism and structural subtyping

---

## structural subtyping

https://news.ycombinator.com/item?id=13047934
> the subtyping relation (subsumption) can lead to information loss

```
let f = fun {x : real, y : real} -> {x = 2 * x, y = 2 * y};
(* f : {x : real, y : real} -> {x : real, y : real} *)

f {x = 2.0, y = 3.0, z = 4.0};
(* it = {x = 4.0, y = 6.0}; *)
```

参数里的 z 丢失了

---

## row polymorphism

```
let f = fun {x : real, y : real, R} -> {x = 2 * x, y = 2 * y, R};
(* f : {x : real, y : real, _ : ..a} -> {x : real, y : real, _ : ..a} *)

f {x = 2.0, y = 3.0, z = 4.0};
(* it = {x = 4.0, y = 6.0, z = 4.0}; *)
```

参数里的 z 可以保留下来

https://news.ycombinator.com/item?id=13047934
> row polymorphism enables many of the same programming
> patterns/techniques/abstractions in typed languages
> that are enabled by duck "typing" in untyped ones

https://dev.realworldocaml.org/objects.html#scrollNav-5-5
> row polymorphism is usually preferred over subtyping because
> it does not require explicit coercions, and it preserves more type information
