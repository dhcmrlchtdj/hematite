1.1.5
======
函数在求值的时候，有两种策略。

+ 应用序求值（applicative-order evaluation）

    先对参数进行求值，再执行函数。

+ 正则序求值（normal-order evaluation）

    先将函数展开，再进行归约（reduce）。


书里给了个例子来测试程序使用哪种方式求值：

.. code:: scheme

    (define (p) (p))
    (define (test x y) (if (= x 0) 0 y))
    (test 0 p)
