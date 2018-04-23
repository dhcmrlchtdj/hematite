# docker

---

```
$ docker info
```

```
# container
$ docker ps -a
$ docker rm
```

```
# image
$ docker images -a
$ docker rmi
```

```
# get image
$ docker pull base/archlinux
```

```
# run container
$ docker run --rm -it base/archlinux /bin/bash

# login running container
$ docker exec <container-hash> /bin/bash
```

```
# remove everything
$ docker rm $(docker ps -a -q)
$ docker rmi $(docker images --filter "dangling=true" -q)
```
