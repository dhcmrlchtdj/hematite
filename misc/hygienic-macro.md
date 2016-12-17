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
