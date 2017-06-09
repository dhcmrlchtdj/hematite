# make show target

+ https://gist.github.com/pvdb/777954

```
$ make -nprR | gsed -n -e "/^$/{n; /^[^.#].*:/{s/:.*//; p}}" | sort
```
