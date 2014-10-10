.. contents::



python package
===============
brew 更新 python，会导致依赖 python 的包出问题，pip 的包也都找不到解释器。

pip 的问题可以用重新安装解决

::

    $ pip3 freeze -l | grep -v '^\-e' | cut -d = -f 1  | xargs pip3 install --force-reinstall -U


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




iterm2 && macvim
=================

刷新 chrome 或者 redo 的时候，经常不小心在 vim  里按了 cmd-r，然后就悲剧了。

可以在个人设置里面添加快捷键，把 cmd-r 忽略掉。


chrome
=======

+ http://peter.sh/experiments/chromium-command-line-switches/

开启某些选项

::

    $ open -a Google\ Chrome --args --allow-file-access-from-files
    $ open -a Google\ Chrome --args --disable-web-security



$PATH
========

系统自带的在 ``/etc/paths``



idea
=======

http://blog.jetbrains.com/idea/2013/09/jdk7_compatibility/

::

    $ vim ~/Applications/IntelliJ\ IDEA\ 13\ CE.app/Contents/Info.plist
    $ # search `JVMVersion`




java
=====

查看 JVM 位置

::

    $ /usr/libexec/java_home -V


设置 JAVA_HOME

::

    export JAVA_HOME=$(/usr/libexec/java_home)


如果运行 java 程序时出现 ``LSOpenURLsWithRole() failed with error -10810`` ，
可能是缺少了 ``libserver.dylib`` ，
详细看 http://apple.stackexchange.com/questions/136975/lsopenurlswithrole-failed-with-error-10810 。
简单讲就是做个软链， ``bundle/Libraries/libserver.dylib -> jre/lib/server/libjvm.dylib`` 。
