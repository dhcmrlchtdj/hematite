# archlinux

---

https://wiki.archlinux.org/index.php/Install_from_existing_Linux#From_a_host_running_another_Linux_distribution

---

```
$ curl -O https://mirrors.ustc.edu.cn/archlinux/iso/2015.10.01/archlinux-bootstrap-2015.10.01-x86_64.tar.gz
$ tar xvzf archlinux-bootstrap-2015.10.01-x86_64.tar.gz
$ sed -i.bak '/https.*ustc/s/^#//' root.x86_64/etc/pacman.d/mirrorlist
```

```
$ aptitude install haveged
$ root.x86_64/bin/arch-root root.x86_64
$ pacman-key --init
$ pacman-key --populate archlinux
$ cdisk /dev/xxx
$ mkfs.ext4 /dev/xxxy
$ mount /dev/xxxy /mnt
$ mkdir /run/shm
$ pacstrap -i /mnt base base-devel
```
