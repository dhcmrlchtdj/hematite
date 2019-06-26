# dependency injection

---

https://fsharpforfunandprofit.com/posts/dependency-injection-1/

---

## why

---

- 减少功能间的耦合
    - 靠接口保证模块功能
    - 不主动 `import` 其他功能模块
    - 通过构造函数等方式，获得功能模块
- 因为是外部传入的功能，所以测试时 mock 更容易

---

```typescript
/// file_A
import N from 'N';
export default class A {
    constructor() {
        this.n = new N();
    }
}
/// file_root
import A from 'A';
new A();
```

```typescript
/// file_A
export default class A {
    constructor(n_DI) {
        this.n = n_DI;
    }
}
/// file_root
import A from 'A';
import N from 'N';
new A(new N());
```

在上面的例子里也可以看到，始终是要有一个地方要 import N 的。

---

上面是个 OO 的例子。
constructor 是个函数，返回一个闭包。
怎么变都还是函数和闭包嘛，FP 里也是很自然的事情。
