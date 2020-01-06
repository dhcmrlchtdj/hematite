# git server

---

https://git-scm.com/book/it/v2/Git-on-the-Server-Setting-Up-the-Server
https://git-scm.com/book/it/v2/Git-on-the-Server-The-Protocols
https://www.digitalocean.com/community/tutorials/how-to-set-up-a-private-git-server-on-a-vps

---

本地建仓库以前玩过。
上次想搭个远程的，结果 HTTP 模式完全玩不转。
居然没想到平常一直用的 SSH 模式。

---

SSH 和本地基本一样，或者说和 scp 差不多。

```
$ # server
$ mkdir ~/repo.git
$ cd ~/repo.git
$ git init --bare
```

```
$ # client
$ git clone user@server:repo.git
$ cd repo
```
