=========
 freebsd
=========

console mode
=============

.. code::

    % kldload vesa
    % vidcontrol -i mode
    % vidcontrol -i mode | 800x600x32
    323 (0x143) ...
    % vidcontrol MODE_323 # temporary
    % echo 'allscreens_flags="MODE_323"' >> /etc/rc.conf # permanent

-------------------------------------------------------------------------------

load module
============

.. code::

    # load module
    % kldload foo
    # list loaded module
    % kldstat

