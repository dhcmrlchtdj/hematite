# ocaml build

---

https://github.com/ocaml/ocamlbuild/blob/master/manual/manual.adoc

---

简单的场景用 ocamlbuild 挺方便的

```
$ ocamlbuild \
    -tag debug -tag profile \
    -tag safe_string -tag strict_sequence -tag strict_formats -tag short_paths -tag keep_locs \
    -tag 'color(always)' \
    -tag 'warn(@A-4-27-60)' \
    -use-ocamlfind -pkgs 'str,lwt' \
    filename.{byte,inferred.mli}

$ ocamlbuild clean
```

- 前面那些 tag，需要就加上
- 编译需要的加载依赖的时候，可以用 ocamlfind
- 最后会自动编译出 .native 或者 .byte

---

http://jbuilder.readthedocs.io/en/latest/quick-start.html

---

- jbuilder 能自动生成 merlin 的配置，这点比较好。
- 每个目录都要单独写一个配置文件感觉很麻烦。
- 编译完成后，不像 ocamlbuild 会做一个软链。
- jbuilder 和 ocamlbuild 都没提供 watch 的功能。

```
$ cat jbuild
(jbuild_version 1)

(executable (
  (name FILENAME)
  (flags (
    "-w" "@a-4"
    "-keep-locs"
    "-safe-string"
    "-short-paths"
    "-strict-formats"
    "-strict-sequence"
  ))
  (libraries (
    lwt
  ))
  (preprocess (
    pps (lwt.ppx)
  ))
))

$ jbuilder build filename.{bc,exe}
$ jbuilder clean
```

---

```merlin
S src/**
B _build/**
PKG lwt
FLG -w @A -keep-locs -safe-string -short-paths -strict-formats -strict-sequence
```

```makefile
targets := $(patsubst %.ml,%,$(wildcard *.ml))

all: $(targets)

clean:
	@ocamlbuild -clean

$(targets):
	@ocamlbuild \
		-tag 'color(always)' \
		-tag 'warn(@A)' \
		-tag safe_string \
		-tag strict_sequence \
		-tag strict_formats \
		-tag short_paths \
		-tag keep_locs \
		-use-ocamlfind -pkgs 'str' \
		$@.{byte,inferred.mli}

.PHONY: all clean $(targets)
```
