合并多个 commit
================

::

    $ git reset --soft [hash]
    $ git ci




删除 dangling blob
===================

::

    $ git fsck --full
    $ git gc --aggressive --prune=now




work with dropbox
==================

::

    $ cd /path/to/dropbox/git/directory
    $ git init --bare project.git

    $ cd /path/to/project
    $ git remote add origin /path/to/dropbox/git/directory
    $ git push -u origin master




multiple remote
================

::

    $ git remote add github git@github.com:user/porject.git
    $ git remote add dropbox /path/to/project.git

    $ git config -e
    # 添加如下设置
    $ cat .git/config
    ...
    [remote "origin"]
        url = git@github.com:user/project.git
        url = /path/to/project.git
    ...

    $ git push -u origin master
    $ git remote -v update





在分支间建立联系
=================

::

    $ git branch local_xxx origin/xxx

    # or
    $ git co origin/xxx
    $ git co -b local_xxx
    $ git branch -u origin/xxx


去除分支的联系
===============

::

    $ git branch --unset-upstream







和上游同步
===========

::

    # 首先下载自己的分支
    $ git clone 'git@github.com:dhcmrlchtdj/zsh-completions.git'

    $ cd zsh-completions

    # 然后添加上游分支
    $ git remote add upstream 'git@github.com:zsh-users/zsh-completions.git'

    # 最后同步
    $ git fetch upstream
    $ git merge --no-ff upstream/master




在远程创添加删除分支
=====================

::

    $ git push -u origin <new_branch_name>

加个 ``-u`` 方便以后提交。


::

    $ git push origin --delete <branch_to_delete>
    $ git push origin :<branch_to_delete>





查看暂存的内容
===============
偶尔会把一些修改丢到 ``stash`` 里面，后来就忘了内容……
找了下发现可以用 ``-p`` 来查看修改的详细内容。

::

    $ git stash show
    $ git stash show -p




查看某次的修改内容
===================

::

    $ git show <object>
