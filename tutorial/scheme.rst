数据类型
=========

+ 布尔值

    ``#t``, ``#f``

+ 数字

    ``1``, ``1/2``, ``0.5``, ``1+1i``

+ 字符

    ``#\h``, ``#\e``, ``#\l``, ``#\l``, ``#\o``

    语法有点奇葩，感觉不怎么用就是了。

+ 字符串

    ``"hello"``, ``(string #\h #\e #\l #\l #\o)``

    和单引号是不一样的，不一样。

+ 符号 symbol

    基本类型。除了其他类型，剩下的都可以作为符号。当成是变量名也差不多吧。

+ 过程 procedure

    ``(lambda (var) body)``

    就是函数啦。

+ 向量 vector

    ``(vector 1 2 3)``

    感觉用列表用的要多些啊。

+ 列表 list

    ``'(1 2)``, ``(quote (1 2))``, ``(list 1 2)``

+ 点对 dotted pair

    ``'(1 . 2)``

    和列表的区别在于点对最后没有结束符号。

    ``(cons 1 2)`` 和 ``(cons 1 (cons 2 '()))`` 的区别。

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




Continuation Passing Style
===========================
+ http://c2.com/cgi/wiki?ContinuationPassingStyle
+ http://www.scheme.com/tspl4/further.html#./further:h3

CPS 可以理解成函数没有返回值的编程风格。
没有返回值，所以就将原来用于处理返回值的函数直接作为参数来传递。

所以说，要玩 CPS，至少要能把函数当作参数来用。
这个被传递的函数就称为 ``continuation`` 。

下面的内容都整理自 tspl4。

call/cc
--------
scheme 在处理一个表达式的时候要考虑两个问题：

1. 计算什么（what to evaluate）
2. 怎么处理结果（what to do with the value）

以 ``(if (null? x) (quote ()) (cdr x))`` 为例，
首先要计算 ``(null? x)`` 的值（即上面的计算什么），
再根据这个值来判断要执行 ``(quote ())`` 还是 ``(cdr x)`` （即怎么处理结果）。

这个 *怎么处理结果* ，就是 ``continuation`` 。

在 scheme 中，可以使用 ``call/cc`` 来捕获当前的 ``continuation`` 。

``(call/cc (lambda (k) body ...))``

``call/cc`` 把当前的 ``continuation`` 作为参数传递给一个函数（procedure），
这里就随便起个名字叫 ``p`` 。
表示 ``continuation`` 的参数 ``k`` 自身也是个函数。
在 ``p`` 中调用 ``k`` ，整个 ``call/cc`` 就会返回。
不在 ``p`` 中调用 ``k`` ，那么 ``p`` 的返回值就作为 ``call/cc`` 的返回值。

下面给点例子：

.. code:: scheme

    (call/cc
        (lambda (k)
            (* 5 4))) ;; 没有调用 k，所以返回 p 的执行结果，20。

    (call/cc
        (lambda (k)
            (* 5 (k 4)))) ;; 调用了 k，直接返回 k 的结果，4。

    (+ 2
        (call/cc
            (lambda (k)
                (* 5 (k 4))))) ;; 调用了 k，返回了 4，再继续参与外部计算，6。

感觉 ``k`` 的作用就类似于 ``return`` 语句。
来看下面的例子：

.. code:: scheme

    (((call/cc (lambda (k) k)) (lambda (x) x)) "hey")

    ;; 对上面的分解
    (let*
        ([p1 (call/cc (lambda(k) k))]
         [p2 (p1 (lambda (x) x))])
        (p2 "hey"))

例子中， ``call/cc`` 返回了捕获的 ``continuation`` ，将其应用到另一个函数上。
用之前的 ``return`` 来理解的话，就成了 ``(return (lambda (x) x))`` ，
所以最后返回的是个函数，也就是上面的 ``p2`` 。

再看下面这个例子：

.. code:: scheme

    (define retry #f)

    (define factorial
        (lambda (x)
            (if (= x 0)
                (call/cc (lambda (k) (set! retry k) 1))
                (* x (factorial (- x 1))))))

    (factorial 5) ;; 120
    (retry 2) ;; 240

因为没有调用 ``k`` ，所以返回的是 ``1`` ，所以基本上就是个常见的阶乘。

但是这里还把 ``k`` 理解成 ``return`` 的话， ``retry`` 就不好理解了。
应该理解成一个闭包。

``(call/cc (lambda (k) k))`` 返回的是个函数（procedure），
也就是说捕获到的 ``continuation`` 其实是个函数。
（函数的内容嘛，差不多就是 ``return`` 其参数吧。）
结合例子，我们可以知道，
这个函数能够访问到创建该函数（也就是捕获 ``continuation`` ）时的环境，
叫上下文也一样啦。总之，就是构成了个闭包。

``retry`` 被调用的时候， ``call/cc`` 的返回值就改变了，
于是整个阶乘的计算结果也随之改变。

最后看一个复杂点的例子，
靠 ``call/cc`` 实现一个轻量级的非抢占式（nonpreemptive）线程，
也就是协程啦。

.. code:: scheme

    (define lwp-list '())
    (define lwp
        (lambda (thunk)
            (set! lwp-list (append lwp-list (list thunk)))))
    (define start
        (lambda ()
            (let ([p (car lwp-list)])
                (set! lwp-list (cdr lwp-list))
                (p))))
    (define pause
        (lambda ()
            (call/cc
                (lambda (k)
                    (lwp (lambda () (k #f)))
                    (start)))))

    (lwp (lambda () (let f () (pause) (display "h") (f))))
    (lwp (lambda () (let f () (pause) (display "e") (f))))
    (lwp (lambda () (let f () (pause) (display "y") (f))))
    (lwp (lambda () (let f () (pause) (display "!") (f))))
    (lwp (lambda () (let f () (pause) (display "\n") (f))))
    (start)

这里的 ``pause`` 起到了 ``yield`` 语句的效果。
