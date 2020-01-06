# pipe heredoc

---

http://stackoverflow.com/questions/7046381/syntax-for-piping-a-heredoc-is-this-portable

---

偶然想要 heredoc 加上 pipe，结果发现不知道怎么写。
查了一下，有点扭曲啊

```
$ cat << EOF |
1
2
3
EOF
grep '2'

$ cat << EOF | grep '2'
1
2
3
EOF
```
