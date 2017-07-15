# ocaml prof

---

https://ocaml.org/learn/tutorials/performance_and_profiling.html#Profiling

---

```
$ perf record --call-graph=dwarf -- ./foo.native a b c d
$ perf report
$ perf script  | stackcollapse-perf.pl | flamegraph.pl > flame.svg
```

---

```
$ ./foo.native
$ gprof ./foo.native
```
