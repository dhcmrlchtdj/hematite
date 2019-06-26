# against call/cc

http://okmij.org/ftp/continuations/against-callcc.html

---

> The primitive call/cc is a bad abstraction and its capture of the continuation
> of the whole program is not practically useful.

- inexpressive
- lack of composability
- memory leaks
- performance
- not practice
- dynamic-wind

---

> `shift` can be implemented with `call/cc` and a single mutable cell.
