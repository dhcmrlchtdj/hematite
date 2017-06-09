# js unicode

---

+ https://mathiasbynens.be/notes/javascript-encoding

---

## BMP

+ 每个字符都有一个独立的 `code point`
+ 17 个平面，每个平面有 2^16 个字符，编号从 000000 到 10FFFF。（16进制）
+ 000000-00FFFF 称为 `BMP(Basic Multilingual Plane)`
+ 剩下的 16 个统称为 `supplementary planes / astral planes`

---

## UCS-2 && UTF-16

+ UCS-2 的编码长度固定，一个字符使用一个 `16-bit code unit` 表示
+ UTF-16 的编码长度可变，一个字符可能使用一个到两个 `16-bit code unit` 表示
+ 在 BMP，两者完全相同。
+ 超出 BMP 的部分，UTF-16 使用两个 `16-bit code unit`，称为 `surrogate pair`。
+ `surrogate pair` 的高位称为 `high surrogate / lead surrogate`，范围为 `0xD800-0xDBFF`
+ `surrogate pair` 的低位称为 `low surrogate / trail surrogate`，范围为 `0xDC00-0xDFFF`

### 转换

```
// C => <H, L>
H = Math.floor((C - 0x10000) / 0x400) + 0xD800
L = (C - 0x10000) % 0x400 + 0xDC00

// <H, L> => C
C = (H - 0xD800) * 0x400 + L - 0xDC00 + 0x10000
```

---

## js

+ 规范要求 js 引擎在 UCS-2 和 UTF-16 中选择一个，作为内部编码。据说大部分引擎使用了 UTF-16。
+ js 将每个 `code unit` 视为一个字符。在语言层面，这个表现更接近 UCS-2。
+ 换言之，每个 `surrogate pair` 被视为两个字符，只是在浏览器输出时，看起来是一个。
