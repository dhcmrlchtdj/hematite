# unicode

---

+ http://unicode.org/faq/utf_bom.html
+ http://www.cl.cam.ac.uk/~mgk25/unicode.html
+ http://lucumr.pocoo.org/2014/1/9/ucs-vs-utf8/
+ http://port70.net/~nsz/42_utf8.html

---

unicode 每个字符有个 `code point`，是个数字，范围从 `U+0000` 到 `U+10FFFF`

---

utf8, utf16, utf32 的简单比较

| Name                       | UTF-8  | UTF-16  | UTF-16BE   | UTF-16LE      | UTF-32  | UTF-32BE   | UTF-32LE      |
| Smallest code point        | 0000   | 0000    | 0000       | 0000          | 0000    | 0000       | 0000          |
| Largest code point         | 10FFFF | 10FFFF  | 10FFFF     | 10FFFF        | 10FFFF  | 10FFFF     | 10FFFF        |
| Code unit size             | 8 bits | 16 bits | 16 bits    | 16 bits       | 32 bits | 32 bits    | 32 bits       |
| Byte order                 | N/A    | BOM     | big-endian | little-endian | BOM     | big-endian | little-endian |
| Fewest bytes per character | 1      | 2       | 2          | 2             | 4       | 4          | 4             |
| Most bytes per character   | 4      | 4       | 4          | 4             | 4       | 4          | 4             |

---

byte order mark

| Bytes       | Encoding Form         |
| 00 00 FE FF | UTF-32, big-endian    |
| FF FE 00 00 | UTF-32, little-endian |
| FE FF       | UTF-16, big-endian    |
| FF FE       | UTF-16, little-endian |
| EF BB BF    | UTF-8                 |

utf8 的 BOM 完全是多余的

---

utf8 到 code point

| U-00000000 - U-0000007F | 0xxxxxxx                                              |
| U-00000080 - U-000007FF | 110xxxxx 10xxxxxx                                     |
| U-00000800 - U-0000FFFF | 1110xxxx 10xxxxxx 10xxxxxx                            |
| U-00010000 - U-001FFFFF | 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx                   |
| U-00200000 - U-03FFFFFF | 111110xx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx          |
| U-04000000 - U-7FFFFFFF | 1111110x 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx |

由于 unicode 最大只到 `10ffff`，所以最多只用到 4 bytes。

---

utf8 到 unicode 的换算

1. byte 前面几个 1，代表这个 code point 一共占用多少 byte，以一个 0 和后面分割
2. 后续的 byte 都以 `10` 开头
3. 把剩下的 XXX 连起来，就得到 code point

---

+ utf16 的优势在于 BMP
+ bmp 内的符号只要 2byte，比 utf8 小
+ 字符串长度只要计算 byte 数量，不用关心 byte 的内容
+ 不过计算长度时完全不管 surrogate pair 就不能忍了
