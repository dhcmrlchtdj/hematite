qunit
======

.. code:: html

    <!DOCTYPE html>
    <html>
        <head>
            <meta charset="utf-8" />
            <title>Test</title>
            <link rel="stylesheet" href="/path/to/qunit.css" />
        </head>
        <body>
            <div id="qunit"></div>
            <div id="qunit-fixture"></div>
            <script src="/path/to/qunit.js"></script>

            <script src="/path/to/test.js"></script>
        </body>
    </html>

把要测试代码引入这个页面就可以了，上手毫无难度。

页面上有三个选项

Hide passed tests
    隐藏通过的测试。

Check for Globals
    检查是否修改了全局变量。如果修改了全局变量会报错。

No try-catch
    不选则捕获错误，显示出来。选中则抛出错误，测试停止。
    （错误和测试失败是不一样的，不一样。）

每个后面还有单独的 ``Rerun`` ，就是执行单个测试





api
====

断言
-----

ok(expr, msg)
    ``expr`` 为真则通过测试。

equal(obj, expected, msg)
    用 ``==`` 比较 ``obj`` 和 ``expected`` ，为真则通过测试。
    ``notEqual`` 用 ``==`` ，
    ``strictEqual`` 用 ``===`` ，
    ``notStrictEqual`` 用 ``!==`` 。

deepEqual(obj, expected, msg)
    比较基本类型使用的是 ``===`` ，碰到对象和数组会展开比较。
    还有 ``notDeepEqual`` 。

throws(fn, expected, msg)
    ``fn`` 抛出的错误满足 ``expected`` ，则通过测试。
    可以是错误的类型满足，也可以是错误信息满足。

expect(amount)
    类似于测试函数的第二个参数。用于表明该测试中有几个断言。


测试
-----

断言都是放在测试的 ``fn`` 里面的。

test(testName [, num], fn)
    测试。

    ``num`` 是内部断言的数量。

    代码里可以使用 ``stop`` 和 ``start`` 这两个函数对异步函数进行测试，
    比如回调前调用下 ``stop`` ，在回调函数最后加上 ``start`` 。
    注意两者要成对出现。在有多对的时候，可以使用数字作为参数，
    表明配对关系。

asyncTest(testName [, num], fn)
    异步测试。
    无需调用 ``stop`` ，但必须调用 ``start`` 。


分组
-----

测试可以分组放到模块里面。

module(moduleName [, option])
    模块划分，范围是到下个 module 调用为止。

    ::

        module('moduleName', {
            setup: function() { /* called before each test */ },
            teardown: function() { /* called after each test */ }
        });

    ``setup`` ``teardown`` 和测试的 ``fn`` 会绑定到相同的作用域，
    所以可以通过 ``this`` 来共享变量。


控制
-----
可以通过 ``Qunit.config`` 来自定义配置。

可以在整个测试前后，每个模块前后，每个测试前后，每个断言之后，注册回调函数。
