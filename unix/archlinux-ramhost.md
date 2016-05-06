# archlinux install

---

装好了很舒服，但确实每次安装都要折腾半天

这次主要是 GPT 和 GRUB 的问题没仔细看文档，花了半天时间

---

## system clock

```
$ timedatectl set-ntp true
```

## partition / format

```
$ lsblk
$ cgdisk /dev/sdx
$ mkfs.ext4 /dev/sdxY
$ # mkswap /dev/sdxY
$ # swapon /dev/sdxY
```

## config

```
$ mount /dev/sdxY /mnt

$ vim /etc/pacman.d/mirrorlist
$ pacstrap /mnt base base-devel vim grub os-prober

$ genfstab -U /mnt >> /mnt/etc/fstab

$ arch-chroot /mnt /bin/bash

$ echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
$ locale-gen
$ echo "LANG=en_US.UTF-8" >> /etc/locale.conf

$ echo "hostname" > /etc/hostname
$ # systemctl enable dhcpcd@interface.service

$ tzselect
$ ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
$ hwclock --systohc --utc

$ mkinitcpio -p linux

$ grub-install --target=i386-pc /dev/sdx
$ grub-mkconfig -o /boot/grub/grub.cfg

$ passwd

$ exit
$ umount -R /mnt
$ reboot
```
