.. contents::


homebrew
==========

::

    $ # install `Xcode`
    $ ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
    $ brew tap caskroom/cask
    $ brew install brew-cask
    $ brew tap caskroom/versions



nginx
========

homebrew 安装 nginx，
配置文件在 ``/usr/local/etc/nginx/nginx.conf`` ，
log 和 pid 的位置可以看 ``$ nginx -V`` 。


pyenv
=======

pyenv 配置。

::

    PYENV_ROOT="$HOME/.pyenv"
    PATH="$PYENV_ROOT/shims:$PATH"
    export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
    eval "$(pyenv init -)"
    pyenv virtualenvwrapper_lazy



idea
=======

http://blog.jetbrains.com/idea/2013/09/jdk7_compatibility/

::

    $ vim ~/Applications/IntelliJ\ IDEA\ 13\ CE.app/Contents/Info.plist
    $ # search `JVMVersion`





jvm
=====

查看安装的多个 JVM 的位置。

::

    $ /usr/libexec/java_home -V




iterm2 && macvim
=================

刷新 chrome 或者 redo 的时候，经常不小心在 vim  里按了 cmd-r，然后就悲剧了。

可以在个人设置里面添加快捷键，把 cmd-r 忽略掉。
