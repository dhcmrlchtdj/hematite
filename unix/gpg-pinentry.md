# GnuPG entropy

---

https://wiki.archlinux.org/index.php/GnuPG
https://wiki.archlinux.org/index.php/Random_number_generation#Faster_alternatives
https://www.gnupg.org/documentation/manuals/gnupg/Common-Problems.html
http://serverfault.com/questions/214605/gpg-not-enough-entropy

---

一开始，遇到这种错误

```
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.

gpg: agent_genkey failed: No pinentry
Key generation failed: No pinentry
```

需要修改一下 pinetry 的设置

```
$ echo "pinentry-program /usr/bin/pinentry-curses" >> ~/.gnupg/gpg-agent.conf
$ gpg-connect-agent reloadagent /bye
```

---

之后，遇到一直卡着没反应

```
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
```

甚至出现

```
Not enough random bytes available.
Please do some other work to give the OS a chance to collect more entropy!
```

是因为 `cat /proc/sys/kernel/random/entropy_avail` 比较小。
可以试着在机器上做点其他事情，或者，用 rngd 临时处理下。

```
$ rngd -r /dev/urandom
```

---

本地使用 gpg 的时候，会出现这种错误。

```
gpg: signing failed: Inappropriate ioctl for device
```

可以靠设置 `GPG_TTY` 解决

```
$ export GPG_TTY=$(tty)
```
