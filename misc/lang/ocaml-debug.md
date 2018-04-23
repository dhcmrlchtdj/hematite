# ocaml debug

---

```
$ export OCAMLRUNPARAM=b
$ ocamlbuild -tag debug /path/to/program.byte

$ ./program.byte
Fatal error: exception Sys_error("Illegal seek")
Raised by primitive operation at unknown location (inlined)
Called from file "/path/to/program.ml", line 1, characters 1-3
```
