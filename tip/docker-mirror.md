# docker mirror

---

http://blog.daocloud.io/how-to-master-docker-image/
https://servers.ustclug.org/2015/05/new-docker-hub-registry-mirror/

---

update:

`--registry-mirror=https://docker.mirrors.ustc.edu.cn`

原来 ustc 也有 docker 源呀

---

对 docker 没研究，看不懂。
只是国内速度太慢太慢，有个镜像用一下，还是很赞的。

文档在 https://dashboard.daocloud.io/mirror。
2.0 要在机器上装东西，所以还是按照 1.0 的方法来吧。

mac 下面，ssh 到虚拟机上，修改 `/var/lib/boot2docker/profile`。
在 `EXTRA_ARGS` 里加上 `--registry-mirror=http://<id>.m.daocloud.io`。

linux 下面，修改 `/etc/default/docker`。
在 `DOCKER_OPTS` 后面加上 `--registry-mirror=http://<id>.m.daocloud.io`。

只在 mac 下测试了下，速度快了幸福感马上上去了……
