合并多个 commit
================

.. code::

    $ git reset --soft [hash]
    $ git ci


删除 dangling blob
===================

.. code::

    $ git fsck --full
    $ git gc --aggressive --prune=now


work with dropbox
==================

.. code::

    $ cd /path/to/dropbox/git/directory
    $ git init --bare project.git

    $ cd /path/to/project
    $ git remote add origin /path/to/dropbox/git/directory
    $ git push -u origin master


multiple remote
================

.. code::

    $ git remote add github git@github.com:user/porject.git
    $ git remote add dropbox /path/to/project.git

    $ git config -e
    # [remote "origin"]
    #   url = git@github.com:user/project.git
    #   url = /path/to/project.git

    $ git push -u origin master
    $ git remote -v update
