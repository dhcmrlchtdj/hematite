# match utf8

---

+ http://swtch.com/~rsc/regexp/regexp3.html

---

输入是 utf8 编码的 bytes，匹配字符的时候，一个个 byte 地匹配。

```
[00-7F]                // code points 0000-007F
[C2-DF][80-BF]         // code points 0080-07FF
[E0][A0-BF][80-BF]     // code points 0800-0FFF
[E1-EF][80-BF][80-BF]  // code points 1000-FFFF
```

把上面这种形式拓展一下，可以匹配 `U+0` 到 `U+10ffff`。
