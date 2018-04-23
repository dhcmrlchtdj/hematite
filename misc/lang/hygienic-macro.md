# hygienic macro

---

https://en.wikipedia.org/wiki/Hygienic_macro
http://wiki.c2.com/?HygienicMacros
https://typeof.net/2015/m/samasa-01-about-macros.html

---

传统的宏展开，是动态作用域
使得宏内部的定义，会影响外部作用域，同时受外部作用域影响

---

比如

```
#define INCI(i) do { int a=0; ++i; } while(0)
int main(void) {
    int a = 4, b = 8;
    INCI(a);
    INCI(b);
    printf("a is now %d, b is now %d\n", a, b);
    return 0;
}
```

展开成了

```
int main(void) {
    int a = 4, b = 8;
    do { int a=0; ++a; } while(0);
    do { int a=0; ++b; } while(0);
    printf("a is now %d, b is now %d\n", a, b);
    return 0;
}
```

---

hygienic macro 就是解决这种命名冲突的方案

---

> 实现健康宏展开的思路并不算复杂：
> 我们只需要在展开宏的步骤里同时维护每个名字的作用域绑定就可以了。

macro 其实就是 new_ast = macro(old_ast)。
要被替换掉的语句会有绑定的 envA，要替换还需要一个 envMap。
在生成每一句 macro 的表达式时，先看 envMap 是否需要替换。
如果不需要再看 envA 是否有重名，有的话就生成一个新变量，塞进 envMap 就好了。

看了下文章，上面的想法还是有点 native，😂。
前面说的 envMap，其实就是实现了 shadow。

> 宏函数实际上不会去「触碰」文法闭包

be5 介绍的做法，给 macro 构建一个全新的 envB，
直接完成 shadow，不需要搞什么 envMap。
