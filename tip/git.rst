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
