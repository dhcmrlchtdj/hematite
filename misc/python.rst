.. contents::


EAFP & LBYL
==============

+ https://docs.python.org/3/glossary.html#term-eafp
+ https://docs.python.org/3/glossary.html#term-lbyl
+ https://docs.python.org/3/c-api/intro.html#exceptions
+ http://stackoverflow.com/questions/598157/cheap-exception-handling-in-python

Easier to Ask for Forgiveness than Permission

.. code:: python

    try:
        return mapping[key]
    except KeyError:
        pass

Look Before You Leap

.. code:: python

    if key in mapping:
        return mapping[key]
    else:
        pass

python 更推荐 EAFP 的写法。

+ python 处理 try-except 结构的开销不大。
+ LBYL 的写法不是原子操作。

感觉好像不是很有说服力。用 dict 做了下测试。

+ try-except 出现错误时的开销是没错误时的两倍。
+ EAFP 在没错误时性能比 LBYL 好，不过优势很小。

感觉 EAFP 在性能上没有什么问题，更多的是编码习惯上的事情。




argparse
=============

.. code:: python

    ARGS = argparse.ArgumentParser(description="Web crawler")
    ARGS.add_argument(
        '--max_redirect', type=int, metavar='N', dest="redirect",
        default=10, help='Limit redirection chains (for 301, 302 etc.)')
    args = ARGS.parse_args()
    print(args) # Namespace(redirect=10)

上面的代码会输出如下信息：

::

    optional arguments:
        --max_redirect N  Limit redirection chains (for 301, 302 etc.)

``dest`` 是读取参数时的变量名（没有的话使用 ``max_redirect`` ），
``metavar`` 是输出帮助时显示的参数名（没有的话显示 ``dest`` ），
``type`` 可以用于类型转换，检查输入之类的事情。

在读取 args 的时候，直接使用 ``args.redirect`` 读取，这个不是 ``dict`` ，
不过可以用 ``vars(args)`` 转换成一个 ``dict`` 。




has_ipv6
=========

关于 :code:`socket.has_ipv6` ，可以直接看这个链接
http://stackoverflow.com/questions/2075383/python-2-and-ipv6




unicode normalize
==================

.. code:: python

    from unicodedata import normalize

    s1 = '\u00f1'
    s2 = 'n\u0303'

    s1.encode() # b'\xc3\xb1'
    s2.encode() # b'n\xcc\x83'

    normalize("NFC", s1).encode() # b'\xc3\xb1'
    normalize("NFC", s2).encode() # b'\xc3\xb1'

    normalize("NFD", s1).encode() # b'n\xcc\x83'
    normalize("NFD", s2).encode() # b'n\xcc\x83'




从命令行读取输入
=================

通过管道和 py 交互

.. code:: python

    import fileinput
    with fileinput.input() as f_input:
        for line in f_input:
            print(line, end='')




iter in loop
=============

.. code:: python

    # while loop version
    while True:
        data = sock.recv(8192)
        if data == b'':
            break
        do(data)

    # for loop version, use lambda
    for data in iter(lambda: sock.recv(8192), b''):
        do(data)

    # for looop version, use partial
    from functools import partial
    for data in iter(partial(sock.recv, 8192), b''):
        do(data)

    # example
    q = (i for i in range(10))
    [i for i in q] # [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

    q = (i for i in range(10))
    [i for i in iter(lambda: next(q), 5)] # [0, 1, 2, 3, 4]
    # stop while `lambda: next(q)` return 5




keyword-only arguments
=======================

.. code:: python

    def t(a, *, b, c=3):
        print(a, b, c)

    t(1, b=2) # 1 2 3
    t(1, b=2, c=3) # 1 2 3
    t(1, 2, b=2, c=3)
    # TypeError: t() takes 1 positional argument but 2 positional arguments

    tt = lambda *a, b, **c: print(a, b, c)
    tt(1, b=2) # (1,) 2 {}
    tt(1, b=2, c=3) # (1,) 2 {'c': 3}




import
=======

.. code:: python

    # load by name
    import importlib
    namespace = importlib.import_module("pkgname")
    # reload
    import importlib
    importlib.reload("pkgname") # py3.4
    import imp
    imp.reload("pkgname") # py3.3




raise
======

.. code:: python

    raise Exception
    # equal to
    raise Exception()




create instances without init
==============================

.. code:: python

    class Example:
        def __init__(self):
            print("initial")

    e1 = Example() # call __init__
    e2 = Example.__new__(Example) # not call __init__




dynamic create class
=========================

.. code:: python

    import types
    cls_body = {
        "__init__": lambda self: print(self),
    }
    CLS = types.new_class(
        "class name",
        (base_class,),
        {"metaclass": type}, # namespace
        lambda ns: ns.update(cls_body)
    )




wraps
======

使用 ``functools.wraps`` 来包裹函数，可以在需要时使用未包裹的函数。

.. code:: python

    from functools import wraps

    def blah(f):
        @wraps(f)
        def wrapper(*args, **kwargs):
            print("blahblah")
        return wrapper

    @blah
    def example():
        print("example")


    example() # blahblah
    example.__wrapped__() # example




获取对象的内存大小
===================

.. code:: python

    import sys
    print(sys.getsizeof(lambda x: x))




timestamp
==========

.. code:: python

    import time
    int(time.time()) # integer

    import datetime
    datetime.datetime.now().strftime("%s") # string
    str(int(time.time())) # faster way




替换
=====
最简单的替换用 ``str.replace`` 就可以搞定了。

以前看 tornado 的代码，看到一个能对付更复杂情况的方法：

.. code:: python

    import re
    re_escape = re.compile("""[<>"'&]""")
    map_escape = {
        "<": "&#x3C;",
        ">": "&#x3E;",
        '"': "&#x22;",
        "'": "&#x27;",
        "&": "&#x26;",
    }
    re_escape.sub(lambda m: map_escape[m.group(0)], DATA_HERE)

使用正则来替换，关键是这里这个匿名函数。

今天翻标准库，看到 http://hg.python.org/cpython/file/3.3/Lib/html/__init__.py
里是这么替换的：

.. code:: python

    map_escape = str.maketrans({
        "<": "&#x3C;",
        ">": "&#x3E;",
        '"': "&#x22;",
        "'": "&#x27;",
        "&": "&#x26;",
    })
    DATA_HERE.translate(map_escape)

虽然没有正则灵活，但也基本够用了。
