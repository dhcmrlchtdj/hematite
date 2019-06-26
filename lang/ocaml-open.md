# ocaml open / include / require / require

---

https://stackoverflow.com/questions/42631912/whats-the-difference-between-include-require-and-open-in-ocaml

---

- `#require` is a Topfind command that finds a library and loads it, making its modules accessible to you.
- `#use` behave as if copying a full file directly into your toplevel.
- http://caml.inria.fr/pub/docs/manual-ocaml/toplevel.html#sec275

---

- `open` makes the components of the module directly accessible in the typing environment.
    - Instead of typing `Core.Std.element` you can just type `element`.
    - http://caml.inria.fr/pub/docs/manual-ocaml/modules.html#sec209
        - It simply affects the parsing of the following items of the structure

- `include` re-exports the components of the module in the current structure: the module you are in will contain all definitions that are in `Ppx_core`.
    - The definitions will be included roughly as they were copy-pasted.
    - http://caml.inria.fr/pub/docs/manual-ocaml/modules.html#sec210

---

The difference between `open` and `include` is that
`open` simply provides short names for the components of the opened structure, without defining any components of the current structure,
while `include` also adds definitions for the components of the included structure.

---

- include 直接把代码复制到了当前位置。
- open 只是提供了对其他代码的引用。

---

https://dev.realworldocaml.org/04-files-modules-and-programs.html#opening-modules

---

> If you do need to do an open, it's better to do a local open.
> An alternative to local opens is to locally rebind the name of a module.

- `let open Int64 in add (of_int 1) (of_int 2);;`
- `Int64.(add (of_int 1) (of_int 2));;`
- `let module I = Int64 in I.add (I.of_int 1) (I.of_int 2);;`

---

> While *opening* a module affects the environment used to search for identifiers,
> *including* a module is a way of actually adding new identifiers to a module proper.

> The difference between include and open is that we've done more than change
> how identifiers are searched for: we've changed what's in the module.
