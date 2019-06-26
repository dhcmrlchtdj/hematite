# single-dispatch generic functions

---

https://www.python.org/dev/peps/pep-0443/

---

generic function 为不同类型的对象实现相同的操作。
由 dispatch algorithm 决定在调用时使用哪个具体实现。
根据一个参数来选择实现的分派算法也被叫做 single dispatch。

---

pep-0443 想要解决的问题

- 缺少创建泛型函数的简单途径
- 缺少为现有泛型函数添加新方法的标准方式
- 在 py 中，检查参数类型再决定执行什么操作是 anti pattern（扩展性、稳定性都比较差
- Abstract Base Classes 简化了检查现有行为，但对添加新的行为没什么帮助

pep-0443 的方案

使用 decorator 来提供一个统一的动态重载 API

---

用户接口

- 用户最初的实现被添加给 object
- 可以为具体类型添加方法
- 调用时根据参数类型选择方法
- 没有匹配的类型时，查找父类
- 查找方式就是 class 用的 MRO，结果就是最后会查找到 object

---

为什么是 single-dispatch

- 实现起来简单
- 使用起来清晰（根据一个复杂的状态进行分派是 anti pattern
- 与面向对象的想法更接近
	- 区别只是这个方法是和数据绑定在一起，还是和算法绑定在一起
	- 数据的话就属于 object-oriented methods
	- 算法的话就属于 single-dispatch overloading
