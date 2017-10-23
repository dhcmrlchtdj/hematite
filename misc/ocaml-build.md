# ocaml build

---

https://github.com/ocaml/ocamlbuild/blob/master/manual/manual.adoc

---

简单的场景用 ocamlbuild 挺方便的

```
$ ocamlbuild \
    -tag debug \
    -tag profile \
    -tag 'color(always)' \
    -tags 'warn(+a),warn_error(-a+31)' \
    -tags safe_string,strict_sequence,strict_formats,short_paths,keep_locs \
    -use-menhir -tag explain \
    -use-ocamlfind -pkgs 'str'
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
FLG -w +a -warn-error -a+31 -keep-locs -safe-string -short-paths -strict-formats -strict-sequence
```

```makefile
OCB_FLAGS := \
	-tag 'color(always)' \
	-tags 'warn(+a),warn_error(-a+31)' \
	-tags safe_string,strict_sequence,strict_formats,short_paths,keep_locs \
	-use-menhir -tag explain \
	-use-ocamlfind -pkgs 'str'
OCB := ocamlbuild $(OCB_FLAGS)

mlis := $(patsubst %.ml,%,$(wildcard src/*.ml))

main: $(mlis)
	@$(OCB) src/main.byte

$(mlis):
	@$(OCB) $@.inferred.mli

clean:
	@ocamlbuild -clean

.PHONY: main clean $(mlis)
```
