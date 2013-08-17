基础
=====

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
