=======
 shell
=======

trim space
===========

.. code::

    var=" test  ";
    echo ${var// };




替换
=====

.. code::

    $ for i in *; do echo ${i/old/new}; done
