.. contents::




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
  = (letrec ([name (lambda (var ...) body ...)]) (name expr ...))

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
+ http://www.scheme.com/tspl4/further.html#SECTGFCONTINUATIONS
+ http://www.scheme.com/tspl4/further.html#SECTGFCPS
+ http://www.scheme.com/tspl4/answers.html
+ http://www.scheme.com/tspl4/examples.html#SECTEXENGINES

CPS 可以理解成函数没有返回值的编程风格。
没有返回值，所以就将原来用于处理返回值的函数直接作为参数来传递。

所以说，要玩 CPS，至少要能把函数当作参数来用。
这个被传递的函数就称为 ``continuation`` 。



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

感觉上， ``k`` 的作用就类似于 ``return`` 语句。

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
所以 ``p2`` 输出 ``"hey"`` 也就是件理所当然的事情了。

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

因为没有调用 ``k`` ，所以返回的是 ``1`` ，基本上就是个随处可见的阶乘。

但是这里还把 ``k`` 当成 ``return`` 的话， ``retry`` 就不好理解了。
应该理解成一个闭包。

执行 ``(call/cc (lambda (k) k))`` 来获取 ``k`` ，
可以知道 ``k`` 是个函数（procedure），
也就是说捕获到的 ``continuation`` 其实是个函数。
（也可以这么获取 ``(call/cc (lambda (k) (k k)))`` 。
函数的内容嘛，差不多就是返回其参数吧。 ``(lambda (x) x)`` 的感觉。）
结合例子，我们可以知道，
函数 ``k`` 能够访问到创建该函数（也就是捕获 ``continuation`` ）时的环境，
叫上下文也一样啦。总之，就是构成了个闭包。

``retry`` 被调用的时候， ``call/cc`` 返回值就不再是 ``1`` ，
而是我们传递给 ``retry`` 的值。
随 ``call/cc`` 的返回， ``factorial`` 继续进行求值，然后返回。
于是整个阶乘（最后乘的不是 ``1`` ，所以也不是阶乘了。）的计算结果也随之改变。

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
    ;;(lwp (lambda () (define f (lambda () (pause) (display "\n") (f))) (f)))
    ;;(lwp (lambda () (letrec ([f (lambda () (pause) (display "\n") (f))]) (f))))
    (start)

这里的 ``pause`` 起到了 ``yield`` 语句的效果。

要注意，在 ``pause`` 里，传递的 ``continuation`` （也就是 ``k`` ），
并没有直接调用。也就是说， ``pause`` 调用的时候，执行了 ``lwp`` 和 ``start`` 。

再按照执行的顺序看一次。

1. 调用 ``lwp`` ，把函数（也就是协程要执行的代码）加入队列。
2. 调用 ``start`` ，开始执行最初的协程。
3. 协程里调用了 ``pause`` ，
   把当前的执行环境加入到了队列中（这里没有执行 ``k`` ），
4. 协程里调用了 ``start`` ，开始执行下一个协程。
   注意， ``pause`` 没有返回，这个时候还没有进行输出。
5. （经过一轮的执行， ``lwp-list`` 中的协程全都变成了 ``pause`` 加入的函数。
   因为还在继续调用 ``start`` ，所以 ``(lambda () (k #f))`` 开始执行。）
6. 协程里调用了 ``k`` ，所以 ``pause`` 返回了 ``#f`` 。
   注意，没有执行 ``start`` 。
7. ``pause`` 返回，原来的协程开始继续执行，进行输出。
8. 原协程进行了递归调用，再次执行了 ``pause`` ，回到了过程 3。
9. （其实这就结束了，就是这样的无限循环。）

最后附上一个 js 的 ``call/cc`` ，
来自 http://matt.might.net/articles/by-example-continuation-passing-style/

.. code:: javascript

    function callcc(f, cc) {
        f(function (x, k) {
            cc(x);
        }, cc);
    }


cps
----
我们已经看到了， ``call/cc`` 很牛。可以说，虽不明，但觉厉。

接下来要讲的是 ``call/cc`` 和 ``cps`` 的关系。
实际上呢，用 ``call/cc`` 写的程序，都可以用 ``cps`` 进行改写。

先看两个简单的例子，
第一个是用 ``cps`` 的方式改写一般程序，
第二个是对 ``call/cc`` 程序进行改写。

.. code:: scheme

    (define reciprocal
        (lambda (n)
            (if (= n 0)
                "oops!"
                (/ 1 n))))
    ;; (reciprocal 10) => 1/10

    (define cps-reciprocal
        (lambda (n success failure)
            (if (= n 0)
                (failure "oops!")
                (success (/ 1 n)))))
    ;; (cps-reciprocal 10 (lambda (x) x) (lambda (x) x)) => 1/10


    (define product
        (lambda (ls)
            (call/cc
                (lambda (break)
                    (let f ([ls ls])
                        (cond
                            [(null? ls) 1]
                            [(= (car ls) 0) (break 0)]
                            [else (* (car ls) (f (cdr ls)))]))))))
    ;; (product '(1 2 3 4 0)) => 0

    (define cps-product
        (lambda (ls k)
            (let ([break k])
                (let f ([ls ls] [k k])
                    (cond
                        [(null? ls) (k 1)]
                        [(= (car ls) 0) (break 0)]
                        [else (f (cdr ls)
                            (lambda (x)
                                (k (* (car ls) x))))])))))
    ;; (cps-product '(1 2 3 4 0) (lambda (x) x)) => 0


第一个好理解。
第二个， 知道 ``let f`` 起个递归的作用，也能理解，就是递归的时候，
``k`` 比较绕。

用上面提过的阶乘做例子：

.. code:: scheme

    (define retry #f)
    (define factorial
        (lambda (x)
            (if (= x 0)
                (call/cc (lambda (k) (set! retry k) 1))
                (* x (factorial (- x 1))))))
    ;; (factorial 3) => 6

    (define cps-retry #f)
    (define cps-factorial
        (lambda (x k)
            (let f ([x x] [k k])
                (if (= x 0)
                    (begin (set! cps-retry k) (k 1))
                    (f (- x 1) (lambda (y) (k (* x y))))))))
    ;; (cps-factorial 3 (lambda (x) x)) => 6

这里使用传递的函数，来保存最后一步的计算状态，起到了和 ``call/cc`` 相同的效果。

最后 ``cps-retry`` 的里保存的，是 ``(lambda (y) (k (* x y)))`` ，
形成了一个闭包。
在 ``cps-factorial`` 里，以 ``1`` 为参数，执行了该函数。

改写一个 js 版本出来：

.. code:: javascript

    var retry;
    var factorial = function(x, k) {
        if (x === 0) {
            retry = k;
            k(1);
        } else {
            factorial(x - 1, function(y) { k(x * y); });
        }
    };
    // factorial(3, console.log) === 6

只能说，这个逻辑看着确实难受……



engine
-------
协程在调度的时候，是非抢占式的。而 ``engine`` 能够抢占式调度。
