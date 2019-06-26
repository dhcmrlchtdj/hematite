# acorn

---

之前对 acorn 怎么实现扩展很有兴趣。
翻了下代码，其实很简单……
通过类继承的方式，覆盖之前的方法，达成扩展。
简化一下，差不多是下面这样

```javascript
import Parser from 'acorn';
import dynamicImport from 'acorn-dynamic-import';
Parser.extend(dynamicImport).parse('import("something");');

// dynamic import
export default function dynamicImport(Parser) {
    return class extends Parser {
        parseStatement(context, topLevel, exports) {
            // do somethong
            return super.parseStatement(context, topLevel, exports);
        }
    };
}

// acorn
export class Parser {
    static extend(plugin) {
        return plugin(this);
    }
}
```

---

很难憋一篇文章出来呢……
