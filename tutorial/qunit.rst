qunit
======

.. code:: html

    <!DOCTYPE html>
    <html>
        <head>
            <meta charset="utf-8" />
            <title>Test</title>
            <link rel="stylesheet" href="/path/to/qunit.css" />
            <script src="/path/to/qunit.js"></script>
        </head>
        <body>
            <h1 id="qunit-header">QUnit Test Suite</h1>
            <h2 id="qunit-banner"></h2>
            <div id="qunit-testrunner-toolbar"></div>
            <h2 id="qunit-userAgent"></h2>
            <ol id="qunit-tests"></ol>

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

ok(assert [, msg])
    ``assert`` 为真则通过测试。

equal(expr, expected [, msg])
    用 ``==`` 比较 ``expr`` 和 ``expected`` ，为真则通过测试。
    ``notEqual`` 用 ``==`` ，
    ``strictEqual`` 用 ``===`` ，
    ``notStrictEqual`` 用 ``!==`` 。

deepEqual(expr, expected [, msg])
    用于比较数组、对象。
    比较基本类型使用的是 ``===`` ，碰到对象数组继续展开比较。


测试
-----

断言都是放在测试的 ``fn`` 里面的。

test(testName [, num], fn)
    测试， ``num`` 是内部断言的数量。
    代码里可以使用 ``stop`` 和 ``start`` 这两个函数对异步函数进行测试，
    比如回调前调用下 ``stop`` ，在回调函数里加上 ``start`` 。
    注意两者要成对出现。

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
