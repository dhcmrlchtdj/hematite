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
