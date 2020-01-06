# rust string

---

要说 string，我觉得 swift 是最好的。
utf8everywhere 里有个例子，`Приве́т नमस्ते שָׁלוֹם`的长度是多少？
swift 输出的是 16，同时能够算出有 22 个 unicode 字符、用 utf8 表示是 48 个字符。
其他语言应该都没有这么方便的 API。

而 rust 相比之下更恶劣一些，官方文档自己都知道 `String` 和 `&str` 让人头晕。

---

https://doc.rust-lang.org/std/primitive.str.html
https://doc.rust-lang.org/std/string/struct.String.html
https://doc.rust-lang.org/rust-by-example/std/str.html
https://doc.rust-lang.org/book/ch04-03-slices.html

- `str` is part of core language
- string literal is `&'static str`, `let s: &'static str = "Hello";`
- `&str` is borrowed string slice (`&[u8]`)
- `str` is always valid UTF8

- `String` is part of standard library
- `String` is a vector of bytes (`Vec<u8>`)
- `String` is always valid UTF8
- `.bytes` 是 byte，`.chars` 是 codepoint，标准库里没有 grapheme

---

怎么选择 `&str` 和 `String` 呢？

http://www.ameyalokare.com/rust/2017/10/12/rust-str-vs-String.html

google 搜出来第一条这么说的

- function parameter, `&str`
- read-only string, `&str`
- ownership or mutable, `String`

https://doc.rust-lang.org/book/ch04-03-slices.html#string-slices-as-parameters

文档说应该用 `&str` 做参数

> If we have a string slice, we can pass that directly.
> If we have a String, we can pass a slice of the entire String

```rust
fn pass(s: &str) -> &str { s }
fn pass(s: &String) -> &str { s }
```

