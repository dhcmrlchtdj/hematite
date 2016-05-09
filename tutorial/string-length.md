# string length

---

本文讨论一个问题，`"🐱 meow"` 的长度是多少。

+ `🐱`（`U+1F431`）是个非 BMP 的符号
+ 从 unicode 的角度看，是由 6 个符号组成，长度应该是 6。
+ 从 utf8 的角度看，一共需要 9 bytes 才能表示这 6 个符号，长度说是 9 也对。

---

## javascript

```js
var s = "🐱 meow"; // "\u{1F431} meow"
console.log(s.length); // 7

var ss = unescape(encodeURIComponent(s));
console.log(ss.length); // 9

var len = 0;
for (var c of s) len++;
console.log(len); // 6
```

+ 关于 js，之前讲过多次。
+ js 返回的 length 是 byte 的数量
+ js 内部使用 utf16 对字符串进行编码
+ `🐱` 在 utf16 下需要 2 个 byte 来表示，所以默认长度为 7
+ 通过 encode 再 escape 这种小技巧，可以获取 utf8 编码下需要的 byte 数量，虽然通常没什么用……
+ es6 新增的 `for...of` 循环，能够遍历 unicode 符号

---

## python3

```py
# coding=utf8

s = "🐱 meow" # "\U0001F431 meow"
print(len(s)) # 6
print(len(s.encode('utf8'))) # 9, \xf0\x9f\x90\xb1 meow

print(type(s), type(s.encode('utf8'))) # <class 'str'> <class 'bytes'>

import sys
print(sys.getsizeof(" ")) # 50
print(sys.getsizeof("  ")) # 51
print(sys.getsizeof("🐱")) # 80
print(sys.getsizeof("🐱🐱")) # 84
print(sys.getsizeof("🐱 ")) # 84
```

+ 这是 python3
+ 计算长度时，默认返回的是 unicode 符号的数量
+ 对字符串进行 utf8 编码后，可以得到 byte 的数量
+ 编码前后，两者的类型是不同的
+ python 在存储 unicode 的时候，会根据内容调整内部编码的方式，
	选择使用 `latin1 / UCS-2 / UTF-32` 中的某一种来编码。
	上面的例子也能看出来一点，出现 🐱 后，空格的长度也增加到了 4 bytes
+ http://lucumr.pocoo.org/2014/1/9/ucs-vs-utf8/

---

## python2

```py
# coding=utf-8

import sys

s = "🐱 meow"
print(len(s)) # 9
print(type(s)) # <type 'str'>

print(sys.getsizeof("🐱")) # 41
print(sys.getsizeof("🐱🐱")) # 45
print(sys.getsizeof("🐱 ")) # 42
print(sys.getsizeof(" ")) # 38
print(sys.getsizeof("  ")) # 39


ss = s.decode("utf8"); # u"🐱 meow"
print(len(ss)) # 7
print(type(ss)) # <type 'unicode'>

print(sys.getsizeof(u"🐱")) # 54
print(sys.getsizeof(u"🐱🐱")) # 58
print(sys.getsizeof(u"🐱 ")) # 56
print(sys.getsizeof(u" ")) # 52
print(sys.getsizeof(u"  ")) # 54
```

+ 这是 python2
+ 默认 str 其实是 byte，这里给出了 byte 数量，所以是 9
+ unicode 返回的长度居然是 7 我也是相当震惊的……
	从 getsizeof 的结果来看，内部是使用 ucs2 来编码的。
	网上搜了一下，编译时可以选择 ucs2 或者 ucs4。
+ 情况类似 js es5，要得到正确的长度，需要借助外部的库去处理
+ http://stackoverflow.com/questions/35404144/correctly-extract-emojis-from-a-unicode-string/35462951

---

## c

```c
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <wchar.h>

unsigned long utf8len(char *s) {
	unsigned long len = 0;
	while (*s) len += (*s++ & 0xc0) != 0x80;
	return len;
}

int main() {
	char s[] = "🐱 meow";
	printf("%lu\n", strlen(s)); // 9
	printf("%lu\n", utf8len(s)); // 6

	wchar_t ss[] = L"🐱 meow";
	printf("%lu\n", wcslen(ss)); // 6

	return 0;
}
```

+ strlen 返回 char 的个数，utf8 下 9 bytes
+ wchar_t 看着还行，实际没啥用。http://www.gnu.org/software/libunistring/manual/libunistring.html#The-wchar_005ft-mess
+ 只是简单计算下长度，可以用上面的 utf8len。复杂的需求，上 ICU？

---

## lua

```lua
local s = "🐱 meow"
print(string.len(s)) -- 9
print(utf8.len(s)) -- 6
```

+ http://lua-users.org/wiki/LuaUnicode
+ 默认是 byte 的数量，所以是 9
+ 5.3 增加了 utf8 的支持，可以用 `utf8.len(s)` 得到 utf8 编码下的字符数量

---

## swift

```swift
let s = "🐱 meow" // "\u{1F431} meow"
print(s.characters.count) // 6
print(s.unicodeScalars.count) // 6
print(s.utf8.count) // 9
```

+ https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/StringsAndCharacters.html
+ https://github.com/apple/swift/tree/swift-2.2-branch/stdlib/public/core
+ swift 作为本文列举的语言中最新的一个，字符串 api 也算最简明吧
+ 源码一眼扫过去，大量 utf16，内部编码是 utf16 吗

---

## 小结

今天看 swift，不知道内部用什么方式编码字符串，所以有了这篇文章。

个人是感觉合理的做法
+ 字符串用 byte 数组表示，使用 utf8 作为字符编码
+ 提供针对 unicode 的处理函数，用于遍历、获取长度等
