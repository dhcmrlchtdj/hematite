# ssd or hdd

---

http://unix.stackexchange.com/questions/65595/how-to-know-if-a-disk-is-an-ssd-or-an-hdd

---

怎么判断是不是 SSD

```
$ cat /sys/block/sda/queue/rotational
0 # SSD
1 # HDD
```

直接 lsblk 也能把 rotational 打出来

```
$ lsblk -d -o name,rota
```

或者用 smartctl

```
$ smartctl -a /dev/sdb
```
