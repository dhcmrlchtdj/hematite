数据类型
=========

+ 布尔值

    #t, #f

+ 数字

    1, 1/2, 0.5, 1+1i

+ 字符

    #\h, #\e, #\l, #\l, #\o

    语法有点奇葩，感觉不怎么用就是了。

+ 字符串

    "hello", (string #\h #\e #\l #\l #\o)

    和单引号是不一样的，不一样。

+ 符号 symbol

    基本类型。除了其他类型，剩下的都可以作为符号。当成是变量名也差不多吧。

+ 过程 procedure

    (lambda (var) body)

    就是函数啦。

+ 向量 vector

    (vector 1 2 3)

    感觉用列表用的要多些啊。

+ 列表 list

    '(1 2), (quote (1 2)), (list 1 2)

+ 点对 dotted pair

    '(1 . 2)

    和列表的区别在于点对最后没有结束符号。

    (cons 1 2) 和 (cons 1 (cons 2 '())) 的区别。

    http://stackoverflow.com/questions/6006671/are-pair-and-list-different-in-scheme



变量名
=======

变量名里除了字母数字，还可以有 ``?!.+-*/<=>:$%^&_~@`` 。
限制包括不能是 ``@`` 或数字开头，这个数字包括可以构成数字的 ``+-.`` ，
但是单个的 ``+-`` 或者 ``...`` 是可以的。

命名的时候有这么几个约定：

+ 判断用 ``?`` 结尾，比如 ``eq?`` ``null?`` 。
+ 类型转换在中间加上 ``->`` ，比如 ``vector->list`` 。
+ 带副作用的用 ``!`` 结尾，比如 ``set!`` 。
+ 用于某个类型的函数加上前缀，比如 ``string-append`` 。



常见操作
=========

绑定变量

+ (\ **let** ((var expr) ...) body ...)
+ (\ **let*** ((var expr) ...) body ...)
+ (\ **letrec** ((var expr) ...) body ...)

+ (let name ((var expr) ...) body ...)
  = ((letrec ((name (lambda (var ...) body ...))) name) expr ...)
  = (letrec ((name (lambda (var ,,,) body ,,,))) (name expr ...))

定义函数

+ (\ **lambda** (var ...) body ...)

    (\ **let** ((var expr) ...) body ...)
    = ((\ **lambda** (var ...) body ...) expr ...)

修改和赋值

+ (\ **set!** var expr)
+ (\ **define** var expr)

    (\ **define** v0 (\ **lambda** (v1 v2 ...) e1 e2 ...))
    = (\ **define** (v0 v1 v2 ...) e1 e2 ...)

控制语句

+ (\ **if** test then else)
+ (\ **cond** (test expr) ... (\ **else** expr))
+ (\ **when** test expr ...)
+ (\ **unless** test expr ...)
