# usb stick

---

+ https://wiki.archlinux.org/index.php/USB_flash_installation_media

---

### linux

```
$ lsblk # 查看挂载情况
$ dd bs=4M if=/path/to/archlinux.iso of=/dev/sdx && sync
```

### osx

```
$ diskutil list
$ diskutil unmountDisk /dev/disk1
$ dd if=image.iso of=/dev/rdisk1 bs=1m
$ diskutil eject /dev/disk1
```

### restore

```
$ dd count=1 bs=512 if=/dev/zero of=/dev/sdx && sync
```
