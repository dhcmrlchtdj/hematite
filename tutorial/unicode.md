# unicode

---

+ http://unicode.org/faq/utf_bom.html
+ http://lucumr.pocoo.org/2014/1/9/ucs-vs-utf8/

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
