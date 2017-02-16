# url querystring

---

https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams
https://url.spec.whatwg.org/#urlsearchparams
https://url.spec.whatwg.org/#concept-urlencoded-byte-serializer
https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/encodeURIComponent

---

正好和人讨论到 querystring 里的 `+`
又跑去翻了下 MDN
才知道 `+` 是 `application/x-www-form-urlencoded` 规定的

---

```javascript
const qs = new URLSearchParams();
qs.append('tag', 1);
qs.append('tag', 2);
qs.append('tag', 3);
qs.toString(); // "tag=1&tag=2&tag=3"

qs.set('tag', 'a b c');
qs.toString(); // "tag=a+b+c"

qs.set('tag', 'a+b');
qs.toString(); // "tag=a%2Bb"

```

上面的例子可以看到

- 数组会序列化成多个 k-v 拼起来
- 空格会序列化成 `+` 而不是 `%20`
- 加号会序列化成 `%2B`

总之并不是简单 `encodeURIComponent` 就完事了

---

根据文档，在以 `application/x-www-form-urlencoded` 的方式进行序列化时

- 空格（0x20）会特殊处理，输出加号（0x2B）
- `[-._*0-9A-Za-z]` 不进行编码，直接输出
	（encodeURIComponent 也不会对这些字符进行编码
- 其余字符进行 percent encode

MDN 也提到，要进行 `application/x-www-form-urlencoded` 的话
需要将结果的 `%2b` 替换为 `+`
