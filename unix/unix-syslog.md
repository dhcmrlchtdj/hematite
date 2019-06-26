# syslog

---

一直感觉 systemd 自带的 journalctl 不好用……

所有日志都在一起，搜索时需要指定各种条件。
有搜索的优势，同时让人感觉有点麻烦。

对于一个普通用户，普普通通的文本日志就很够用了。

---

https://wiki.archlinux.org/index.php/Syslog-ng

日常使用，不在乎日志大小的话，安装后什么都不用管。
`syslog-ng` 会自己从 journalctl 里面读取日志。
