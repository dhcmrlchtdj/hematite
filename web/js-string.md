# js string

---

`\uXXXX` 是 unicode codepoint
`\xXX` 是 Latin-1 character

---

`String#codePointAt()`

可以获得某个字符的 code point

---

`String.fromCodePoint()`

根据 code point 生成字符

---

`String#charCodeAt()`

可以获得字符的 code point。
由于 js 内部编码的原因，surrogate pair 会被视为两个字符，所以结果可能和预期不同。

---

`String.fromCharCode()`

和 `charCodeAt` 有相同的问题，不支持 surrogate pair。
