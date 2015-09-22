# globstar

---

http://wiki.bash-hackers.org/internals/shell_options#globstar

要在 bash 下面开启 `**`，可以 `$ shopt -s globstar` 一下。

---

如果需要匹配 `dotfiles`，bash 可以 `shopt -s dotglob`，zsh 可以 `setopt dotglob`。
