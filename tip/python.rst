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
