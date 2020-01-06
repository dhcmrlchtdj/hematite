# execute command from commandline

---

http://stackoverflow.com/questions/12834370/run-vim-command-from-commandline

---

```sh
$ vim -c ":call dein#update()" -c ":qall"
$ vim +"call dein#update()" +qall
```
