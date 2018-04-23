# system backup

---

https://wiki.archlinux.org/index.php/full_system_backup_with_rsync
https://wiki.archlinux.org/index.php/Full_System_Backup_with_tar

---

直接 rsync 整个系统到其它地方

```
$ rsync -avihPAX --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} / /path/to/backup/folder
```

---

生成备份文件

```
$ tar --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} --xattrs -czpvf /path/to/backup.tar /
```
