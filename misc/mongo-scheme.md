# mongo scheme

---

https://coderwall.com/p/px3c7g/mongodb-schema-design-embedded-vs-references

---

Embedded vs References

一对多的关系数据。
mysql 中，可以做一张关系表。
mongo 中，可以使用内嵌的方式，也可以选择引用的方式。

---

+ 如何查询数据。
    - 如果关系数据经常是一起读取的，就直接嵌套
    - 如果经常单独读取被嵌套的数据，应该使用引用的方式
+ 数据生命周期。如果其中一个删除，另一个也要删除，就直接嵌套
+ 如果数据属于快照（snapshot），使用嵌套的方式
+ 嵌套数据的数量大小。mongo 有 16MB 的限制，超过就不能嵌套了
