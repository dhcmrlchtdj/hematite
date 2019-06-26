# postgresql

---

https://hub.docker.com/_/postgres/

---

```sh
$ docker pull postgres
$ docker run \
    -p 5432:5432 \
    --name pg \
    -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres \
    -d postgres:latest


$ docker logs pg
$ docker rm pg

$ pgcli -h $(docker-machine ip <machine>) -U postgres -W
```
