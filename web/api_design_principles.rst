+ http://qt-project.org/wiki/API-Design-rinciples

随手记几点

+ be minimal
    要简单。

    不管是类还是类的方法，越少越好。
    方便理解、记忆、调试。以后要更改 API 也不至于牵涉太多东西。

+ be complete
    要完整。

    应该有就必须有。

+ have clear and simple semantics
    要有简单明确的语义。

+ be intuitive
    要符合直觉。

+ be easy to memorize
    要方便记忆。

    使用前后一致、容易理解的方式来命名，使用常见的模式和概念。
    不使用缩写。

+ lead to readable code
    要保证代码的可读性。


上面六点算是方法论。原文下面有 c++ 的例子，这里就不摘抄了。

后面有一些关于命名的具体建议。

+ 不使用缩写。
    比如 ``previous`` 而不是 ``prev`` 。

+ 使用名字进行归类。
    比如 ``QListView`` ``QTableView`` ``QTreeView`` 都使用相同的后缀。

+ 要能从函数名看出有没有副作用。


最后提到了一些常见问题。

+ 首先要考虑的是读代码的时候是否足够清晰。
  写代码的时间要远远小于维护代码的时间。

+ 用布尔值做参数，经常意义不明。
