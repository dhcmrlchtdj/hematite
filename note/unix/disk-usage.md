# disk usage

---

最近遇到 jenkins 空间不足的问题，提示 `No space left on device`。
但是在机器上一看，还有 40% 的剩余空间。

```
$ df -h
Filesystem  Size  Used  Avail   Use%    Mounted on
/dev/vda1   99G   55G   39G     59%     /jenkins
```

网上搜索了一下，说可能是文件数量太多，inode 不够用了。
一看还真是，npm 黑洞的说法，算是领教到了。

```
$ df -i
Filesystem  Inodes      IUsed       IFree   IUse%   Mounted on
/dev/vdc1   6553600     6553600     0       100%    /jenkins
```

使用的是 ext4 的系统，查了下数据。
不过都是默认值，没什么特别的。

```
$ dumpe2fs -h /dev/vda1
...
Block count:                26214368
Inode count:                6553600
Block size:                 4096
Inode size:                 256
Inodes per group:           8192
Inode blocks per group:     512
...
```

---

解决方案。
- 加硬盘
- 重新格式化，分配更多更多 inode （`mkfs.ext4 -i 8192 /dev/vdc1`
