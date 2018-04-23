recovery clockwork
===================

::

    $ # 临时进入
    $ adb reboot bootloader
    $ fastboot boot /path/to/cwm.img

    $ # 安装
    $ adb reboot bootloader
    $ fastboot flash recovery /path/to/cwm.img
