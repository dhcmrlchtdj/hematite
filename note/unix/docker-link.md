# docker link

---

```
$ docker run --name db app/my-db
$ docker run -p 8000:80 --link db:database app/my-app
```
