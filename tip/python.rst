========
 python
========

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

    # for loop version
    for data in iter(lambda: sock.recv(8192), b''):
        do(data)

    # another for looop version
    from functools import partial
    for data in iter(partial(sock.recv, 8192), b''):
        do(data)

    # example
    q = (i for i in range(10))
    [i for i in q] # [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

    q = (i for i in range(10))
    [i for i in iter(lambda: next(q), 5)] # [0, 1, 2, 3, 4]
    # iter stop while ``next(q) == 5``



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
