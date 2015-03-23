# encoding

---

+ 下文的关于编码的笔记
+ 下文的描述并不准确

---

## unicode

+ 简单讲，unicode 就是对所有符号，进行了编码。
+ 目前，unicode 的范围是 `U+0` 到 `U+10FFFF`。
+ 每个数字，都对应一个符号。一个符号，可能对应多个数字。
+ 数字叫做符号的 code point

---

## unicode

+ 10ffff = 0001 0000 1111 1111 1111 1111 (2)
+ 目前最少需要 21bit，才能完整表示 unicode
+ 10ffff = 111 4111 (10)
+ 就目前来说，很够用的样子
+ utf8/utf16/utf32 都是对 unicode 进行某种编码
+ 历史遗留的 ucs2
+ 没怎么碰到的 punycode

---

## utf32

+ 顾名思义，使用 32bit 表示，直接一对一都行，简单粗暴。
+ 问题是浪费空间
+ 24bit 还不如 32bit，不仅浪费空间，在机器上的效率还没 32bit 好

---

## bom

+ 一次 32bit，也就是 4byte
+ 所以出现了 byte order 的问题
+ 所以有 BOM 这个东西
+ utf16 有相同问题，所以需要 bom，但是 utf8 完全不需要

| Bytes       | Encoding Form         |
| --          | --                    |
| 00 00 FE FF | UTF-32, big-endian    |
| FF FE 00 00 | UTF-32, little-endian |
| FE FF       | UTF-16, big-endian    |
| FF FE       | UTF-16, little-endian |
| EF BB BF    | UTF-8                 |

---

## utf16

+ 最小单位是 16bit
+ 使用 16bit，只能表示从 `U+0000` 到 `U+ffff`
+ 使用两个 code unit 表示一个 code point，这种叫做 surrogate pair

---

## utf16

+ 高位 0xD800-0xDBFF，低位 0xDC00-0xDFFF
+ 也就是 0xd800 到 0xdfff 都被用于组合了
+ unicode 中这部分编码，特意为 utf16 保留了下来

---

## ucs2

+ ucs2 在 `U+0000` 到 `U+ffff` 这个范围内，和 utf16 的编码是完全相同的
+ ucs2 没有 surrogate pair 的概念
+ ucs2 不能完整表示 unicode

---

## utf8

+ 最小是 8bit，不够了就再来 8bit

| code point              | utf8                                                  |
| --                      | --                                                    |
| U+00000000 - U+0000007F | 0xxxxxxx                                              |
| U+00000080 - U+000007FF | 110xxxxx 10xxxxxx                                     |
| U+00000800 - U+0000FFFF | 1110xxxx 10xxxxxx 10xxxxxx                            |
| U+00010000 - U+001FFFFF | 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx                   |
| U+00200000 - U+03FFFFFF | 111110xx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx          |
| U+04000000 - U+7FFFFFFF | 1111110x 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx |

+ 后面的 xxx 拼起来，就是 unicode 的编码

---

## utf8

+ unicode 只编码到 `10ffff`，所以最多也就 4byte，不会比 utf16/utf32 更糟
+ 如果 utf8 都不够用了，utf16/utf32 什么的早就死了
+ 没有 byte order 问题，每次读取一个 byte，就知道下个符号多大
+ 0x800 到 0xffff 都需要 3byte，所以像汉字等符号需要的空间比 utf16 要大不少
+ 赢在 0x0 到 0x7f 只要 1byte，而且与 ascii 完全兼容

---

## punycode

+ 用 ascii 表示 unicode，没了

---

## unicode && javascript

---

### html encoding

+ html 的 character reference
+ `&#xhhhh;`
+ hhhh 是 unicode 的 code point，所以直接 `&#x10ffff` 是可以的
+ https://html.spec.whatwg.org/multipage/syntax.html#character-references

---

### url encoding

+ url 后面的 percent encoding
+ `%HH`
+ 针对的是 byte，也就说和编码没有直接联系，不过 whatwg 和 rfc 都要求使用 utf8
+ https://url.spec.whatwg.org/#percent-encoded-bytes

---

### js encoding

#### escape/unescape

+ 结果和 percent encoding 还是有点区别的
+ 小于 `0xff` 的部分转义为 `%hh`，大于 `0xff` 的部分转义成了 `%uhhhh`

#### encodeURIComponent/decodeURIComponent/encodeURI/decodeURI

+ 两者的区别在于，component，一个是为了对完整的 url 进行编码，一个是为了对 url 的某些部分进行编码
+ 字符编码会从 utf16 转换成 utf8，再将 byte 转义成 `%hh`
+ 也就说实现了 percent encoding

---

### js encoding

+ `unescape(encodeURIComponent("something"))` 会怎么样
+ 编码成 `%hh` 再解码的时候，少了 utf8 到 utf16 的过程

---

### js encoding

+ es5
+ js 处理代码时，内部使用的是 utf16 编码 (http://es5.github.io/x6.html#x6)
+ 字符串和正则和标示符都可以使用 `\uhhhh`
+ js 中的字符串是 utf16 的 code unit 组成的，而不是 unicode 的 code point (http://es5.github.io/x8.html#x8.4)
+ js 字符串的相关操作，也都是针对 utf16 的 code unit 的
+ 既然处理上完全无视了 surrogate pair，理解成 ucs2 也没多大问题吧……

---

### js encoding

+ es6
+ es6 的字符串，还是 utf16 的 code unit，和 es5 一样。 (https://people.mozilla.org/~jorendorff/es6-draft.html#sec-ecmascript-language-types-string-type)
+ 不过部分字符串操作会将字符串解码为 unicode 的 code point 后再执行，也就是说会处理 surrogate pair
+ 但是字符串字面量是 unicode 的 code point 组成的，之后会被 utf16 编码 (https://people.mozilla.org/~jorendorff/es6-draft.html#sec-literals-string-literals)

---

## link

+ http://speakingjs.com/es5/ch24.html
+ http://unicode.org/faq/utf_bom.html
+ http://lucumr.pocoo.org/2014/1/9/ucs-vs-utf8/
+ https://mathiasbynens.be/notes/javascript-encoding

---

EOF
