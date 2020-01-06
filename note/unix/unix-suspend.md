# suspend

---

https://wiki.archlinux.org/index.php/Power_management/Suspend_and_hibernate
http://apple.stackexchange.com/questions/126669/how-to-add-hibernate-mode-to-macbook-pro

---

+ suspend to RAM (usually called just suspend)
    当前状态保存在内存中，其他大部分硬件都都断电了

+ suspend to disk (usually known as hibernate)
    当前状态存储到硬盘，然后关机

+ hybrid suspend (sometimes aptly called suspend to both)
    状态同时保存早内存和硬盘

---

在 linux 下面可以用 `systemctl`
在 mac 下面可以用 `pmset`
