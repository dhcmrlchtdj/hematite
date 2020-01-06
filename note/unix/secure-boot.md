# secure boot

---

http://www.rodsbooks.com/efi-bootloaders/secureboot.html
http://www.rodsbooks.com/efi-bootloaders/controlling-sb.html
https://wiki.archlinux.org/index.php/Secure_Boot

---

> With Secure Boot active, the firmware checks for the presence of a
> cryptographic signature on any EFI program that it executes.

在启动前，会检查 EFI 程序的签名，只有验证通过了，才能正常启动。

这在理论上能大大增强系统的安全性

---

M$ 要求机器都要开启 secure boot 并预装上 M$ 的的 key
（然后你可以花 $99 去 Verisign 那搞个签名，可以通过 M$ 的验证

要让自己的 linux 正常启动
可以禁用 secure boot
可以使用签名过的 boot loader
可以使用自己的 key（需要设备支持

---

> Linux has historically not been plagued by viruses,
> so it's unclear that Secure Boot will be a benefit for Linux-only computers.
> ...
> disabling Secure Boot is the easiest way to deal with it.

咦咦咦咦，还是有好一些吧
