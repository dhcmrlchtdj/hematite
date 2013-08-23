jasmine
========

.. code:: html

    <!DOCTYPE html>
    <html>
        <head>
            <meta charset="utf-8" />
            <title>Jasmine 2.0.0rc2</title>
            <link rel="stylesheet" href="/path/to/jasmine.css" />
            <script src="/path/to/jasmine.js"></script>
            <script src="/path/to/jasmine-html.js"></script>
            <script src="/path/to/boot.js"></script>
        </head>
        <body>
            <script src="/path/to/test.js"></script>
        </body>
    </html>

也是简单到不行，引入样式表和脚本就可以了。


api
====

划分范围
---------

describe(str, fn)
    第一个参数用于描述测试，第二个参数是实现。

    可以嵌套。


测试函数
---------

it(str, fn)
    第一个参数用于描述测试，第二个参数是实现。

beforeEach(fn)
    在每个 ``it`` 之前，会调用该函数进行初始化。

afterEach(fn)
    在每个 ``it`` 之后，会调用该函数进行清理。

断言
-----

expect(x)
    包裹需要测试的值，进行下一步测试。

内置的测试方法有：

toEqual(y)
    x y 相等。会展开对象和数组。

toBe(y)
    ``===`` 。

toMatch(pattern)
    x 符合 pattern。可以是个字符串或者正则表达式。
    （大概是调用 ``new RegExp`` 后用 ``test`` 来测试。）

toBeDefined(), toBeUndefined(), toBeNull(), toBeTruthy(), toBeFalsy()
    很好懂。

toContain(y)
    x 必须是字符串或者数组，测试 x 中是否包含 y。
    使用 ``indexOf`` 来实现。

toBeLessThan(y), toBeGreatThan(y)
    比较大小。

toThrow(e)
    x 必须为函数，测试该函数是否会抛出错误。

not
    反转上述测试。


自定义断言
-----------

.. code:: javascript

    beforeEach(function() {
        this.addMatchers({
            matcherName: function(expected) {
                // implementent
            }
        });
    });
