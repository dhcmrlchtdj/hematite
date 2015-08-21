# debian install

---

## 添加用户

```
$ useradd myname
```

---

## 改源

```
# /etc/apt/source.list
deb http://ftp.cn.debian.org/debian unstable main contrib non-free
deb http://ftp.cn.debian.org/debian-multimedia unstable main non-free
```

---

## 改公钥

```
$ apt-get install debian-keyring
$ gpg --keyserver subkeys.pgp.net --recv-keys 1F41B907
$ gpg --armor --export 1F41B907 | apt-key add -
```

---

## 更新

```
$ aptitude update
$ aptitude full-upgrade
```

---

## 修复 locale

```
$ aptitude install locales
$ dpkg-reconfigure locales
$ locale-gen
$ update-locale LC_CTYPE=en_US.UTF-8
```

---

## 必须

```
$ aptitude install \
        build-essential \
        curl \
        git \
        htop \
        man-db \
        nginx-full \
        sudo \
        tmux \
        vim-nox \
        wget \
        zsh
```

---

## sudo

```
$ adduser myname sudo
```

---

## ssh key

```
$ ssh-copy-id -i pub_key -p port user@hostname
```
---
