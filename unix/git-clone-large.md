# clone large repo

https://stackoverflow.com/a/37232969

```
$ mkdir repo
$ cd repo

$ git init
$ git config core.compression 0
$ git remote add origin repo.git

$ git fetch --depth=1
$ git fetch --unshallow
$ git fetch --unshallow
$ git fetch --unshallow
$ git pull --all
```
