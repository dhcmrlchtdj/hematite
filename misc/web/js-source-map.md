# source map

---

https://blogs.msdn.microsoft.com/davidni/2016/03/14/source-maps-under-the-hood-vlq-base64-and-yoda/
https://github.com/mozilla/source-map

---

source map 想解决什么问题，怎么工作的，为什么这么工作

---

> Input ⇒ Preprocessor ⇒ Output

好像主要还是玩转译的前端需要 source map

---

source map 可以非常暴力

`"feel the force" ⇒  "the force feel"` 对应的 source map 是 `1|0|input_filename.txt|1|5,...`
输出的每个字符都输出一个 `output_line|output_column|input_filename|input_line|input_column`
显然，体积会爆炸

---

优化
- 不输出 output_line
    - 输出变成 `output_column|input_filename|input_line|input_column`
    - 每次换行的时候，使用 `;` 代替 `,`
- 提取常量，换成引用
    - 把 input_filename 提取出来，有了 `index => filename` 的映射
    - 把字符串提取出来，有了 `index => name` 的映射
        - 原来都是字符，现在变成字符串，所以输出的数量减少了
    - 输出变成 `output_column|input_index|input_line|input_column|name_index`
- 使用相对偏移量
    - 主要是拿来配合 VLQ 使用的，让数字尽可能小，VLQ 的效果会更好
    - VLQ encoding - Variable length Quantities
- 使用 VLQ + base64 压缩
    - base64 是 6-byte 的，这里用的 VLQ 最小也是 6-byte 的
    - VLQ 保留一位的符号位，保留一位标志位
        - 比如 `0_0000_0` 第一个是标志位，0 即没有后续了；最后是符号位，0 是正数；中间 0000 即数字 0
        - 比如 `1_1000_0;0_11100` 符号为正；标志说明后面还有一个 group；从后往前连起来是 111001000，即数字 456
    - 这里 VLQ 的特性，数字越小占用空间越小，所以前面会选择计算偏移量

---

就这样了
