# docker-machine

---

https://github.com/docker/machine

---

创建 docker 的时候也是 `virtualbox` + `boot2docker.ios`
不过不仅可以控制本地的 docker，还可以连接远程的 docker

```sh
# install
$ brew cask install virtualbox
$ brew install docker docker-machine
$ alias dm="docker-machine --native-ssh"

# create
$ dm create -d virtualbox dev

# ls/start/stop
$ dm ls
$ dm start dev
$ dm stop dev

# use
$ eval $(dm env dev)
```
