合并多个 commit
================

.. code::

    % git reset --soft [hash]
    % git ci


删除 dangling blob
===================

.. code::

    % git fsck --full
    % git gc --aggressive --prune=now
