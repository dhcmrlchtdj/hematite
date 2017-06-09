# vim command in config

---

http://vi.stackexchange.com/questions/2973/setting-a-vim-option-from-the-command-line
http://stackoverflow.com/questions/2437777/with-vim-how-can-i-use-autocmds-for-files-in-subdirectories-of-a-specific-path

---

```
$ vim -c 'set et' <filename>
```

VIM 可以这样在命令里指定参数。
配合 zsh 的 `chpwd:profiles` 试了一下，发现并不好用，因为和执行目录绑定了。

---

```
$ vim -c 'au BufRead,BufNewFile */path/* setl et' <filename>
```

按说配合 autocmd，应该是可以解决问题的。
但是 zsh 的 `VIM_OPTIONS` 不知道怎么处理的，就是跑不起来。
