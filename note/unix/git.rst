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






修改以前的某个分支
===================

修改刚刚提交的分支，可以直接用 ``git commit --amend`` ，
如果要修改更早的分支，需要 ``git rebase`` 出马。

::

    $ # 选择要修改的分支
    $ git rebase -i <commit>

把要修改的分支标记为 edit，保存退出，接着就会进入需要修改的分支。
使用 ``git commit --amend`` 保持修改，这点是一样的。
之后要使用 ``git rebase --continue`` 继续剩余的衍合。





删除子模块
===========
::

    $ git sm deinit path/to/sub_module
    $ # remove module info in `.gitmodules`
    $ git rm --cached path/to/sub_module


::

    $ # remove module info in `.gitmodules`
    $ # remove module info in `.git/config`
    $ git rm --cached path/to/sub_module
    $ rm -r .git/modules/sub_module
    $ git ad
    $ git ci
    $ rm path/to/sub_module





查找修改记录
=============
在网上问 tornado 比较 Etag 的问题，结果人家让我自己用 ``git blame`` 去查记录。

::

    $ git blame -L 1100,+100 web.py

用 ``git blame`` 可以查找是谁修改了代码，还有那次修改的分支编号。
之后可以用 ``git show`` 查看详细信息。

默认是整个文件，可以用 ``-L`` 参数指定位置，用法和 ``sed`` 差不多。





删除远程已删除的分支
======================

::

    $ git fetch -p
    $ #git pull -p

``--prune`` 的缩写。




单独的工作配置
================

::

    $ cat ~/.zshrc
    ...
    zstyle ':chpwd:profiles:/path/to/directory(|/|/*)' profile myprofile
    chpwd_profile_default() {
      [[ ${profile} == ${CHPWD_PROFILE} ]] && return 1
      unset GIT_AUTHOR_NAME
      unset GIT_AUTHOR_EMAIL
      unset GIT_COMMITTER_NAME
      unset GIT_COMMITTER_EMAIL
    }
    chpwd_profile_myprofile() {
      [[ ${profile} == ${CHPWD_PROFILE} ]] && return 1
      export GIT_AUTHOR_NAME="NAME"
      export GIT_AUTHOR_EMAIL="EMAIL"
      export GIT_COMMITTER_NAME="NAME"
      export GIT_COMMITTER_EMAIL="EMAIL"
    }
    chpwd_profiles
    ...

需要 grml 支持，mac 下有大小写的坑。


caret && tilde
================
+ ``^`` 是广度优先
+ ``~`` 是深度优先



pacth
======

::

    $ git format-patch -2 # pick 2 commit
    $ git am -i /path/to/patch
