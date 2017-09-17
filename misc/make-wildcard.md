# make wildcard

---

https://www.gnu.org/software/make/manual/html_node/Wildcard-Function.html
https://www.gnu.org/software/make/manual/html_node/Text-Functions.html
https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html

---

```
$ tree
.
├── Makefile
├── a.ml
├── b.ml
├── c.ml
└── d.ml
```

```make
targets := $(patsubst %.ml,%,$(wildcard *.ml))

all: $(targets)

clean:
	-ocamlbuild -clean

$(targets):
	-ocamlbuild $@.native

.PHONY: all clean  $(targets)
```

---

- `wildcard` 获取文件
- `patsubst` 等来修改文件
- `$@` `$^` 等获取目标、依赖
