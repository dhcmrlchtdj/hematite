.. contents::



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
