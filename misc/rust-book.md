
## cargo

```
$ cargo new <project> --bin

$ cd <project>
$ cargo build
$ cargo run

$ cargo run --release
```

---

static method

`let s = String::new();`

---

`Result` type
- `Ok` value
- `Err` value
	- `except` method, crash and display message

---

external dependancy

```
extern crate rand;
use rand::Rng;
```

(why `extern crate` and `use`

---

`cargo doc --open` 查看文档

---

```
let mut x = 10;
let x = "s";
```

is shadow evil?

---
