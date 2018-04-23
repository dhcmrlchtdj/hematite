.. contents::

+ http://semver.org
+ http://en.wikipedia.org/wiki/Software_versioning
+ http://en.wikipedia.org/wiki/Linux_kernel#Version_numbering
+ https://docs.python.org/3/faq/general.html#how-does-the-python-version-numbering-scheme-work

version number
===================

``major.minor.micro[.build]``

+ major 表示 API 发生改变，不兼容旧版本。
+ minor 表示添加了新功能，兼容旧版本。
+ micro 表示修复了某些 BUG。
+ build 表示 alpha、beta、rc 之类的信息。


来自 semver 的例子：

1.0.0-alpha < 1.0.0-alpha.1 < 1.0.0-alpha.beta
< 1.0.0-beta < 1.0.0-beta.2 < 1.0.0-beta.11
< 1.0.0-rc.1 < 1.0.0

odd-even system
===================

使用 ``minor`` 区分开发版和稳定版，
如 ``2.3.0`` 是开发版， ``2.4.0`` 是稳定版。
