# gentoo prefix

---

https://wiki.gentoo.org/wiki/Project:Prefix/Bootstrap
https://wiki.gentoo.org/wiki/Prefix/libc

---

```
$ export EPREFIX="$HOME/Gentoo"
$ export GENTOO_MIRRORS="http://mirrors4.tuna.tsinghua.edu.cn/gentoo"

$ curl -O "http://rsync.prefix.bitzolder.nl/scripts/bootstrap-prefix.sh"
$ chmod 755 bootstrap-prefix.sh
$ ./bootstrap-prefix.sh
```

大体上，就是这样了
有问题的话，照着提示也都能解决。
（不得不说，tuna 的镜像在安装的时候差不多就是摆设，基本都是 404 然后回源下载

---

中途遇到几个问题

+ `UNKNOWN ARCH: You need to set up a make.profile symlink to a profile in $HOME/Gentoo/usr/portage for your CHOST x86_64-apple-darwin16`
	用了 darwin15 的 make.profile，等 gentoo 把脚本更新了应该就没问题了

+ `ld/passes/bitcode_bundle.cpp:36:10: fatal error: 'llvm-c/lto.h' file not found`
	用了 6.x 的 xcode，详细见 https://archives.gentoo.org/gentoo-alt/message/fde4d388c286bbf47058ce29147146dc

+ `Package 'app-shells/bash-4.3_p39' NOT merged due to file collisions`
	`❯ export FEATURES="-collision-protect"`

+ ` * ERROR: net-misc/wget-1.18::gentoo_prefix failed (compile phase):`
	放弃了……

---

尝试了下 nix
安装非常方便，但是包并不全，而且包的质量比 homebrew 要差
比如 htop 跑不起来，mpv 播放效果不好之类的

---

在 arch 上有 rap 版本跑了一下，安装成功了。
（然后不知道怎么用……
