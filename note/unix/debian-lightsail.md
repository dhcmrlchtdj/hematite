# 更新成 debian sid
echo 'deb http://ftp.jp.debian.org/debian sid main' | sudo tee /etc/apt/sources.list
sudo apt update && sudo apt dist-upgrade
sudo apt update && sudo apt full-upgrade && sudo apt autoremove && sudo apt autoclean

# 环境
sudo apt install build-essential
sudo apt install git htop
sudo apt install zsh zsh-syntax-highlighting zsh-autosuggestions

# 配置 ntp
sudo apt remove chrony

# 切换 shell
sudo chsh -s /usr/bin/zsh admin

# 配置 locale
sudo dpkg-reconfigure locales
sudo update-locale LC_CTYPE=en_US.UTF-8

# 编辑器
sudo apt install neovim
sudo apt install nodejs npm
sudo update-alternatives --config editor

# 配置 ss
sudo apt install ss-libev ss-plugin
sudo systemctl disable --now ss-libev.service
sudo vim /etc/ss-libev/config.json
sudo systemctl enable --now ss-libev.service

# 配置 nginx
sudo apt install nginx-full certbot
sudo systemctl disable --now nginx.service
vim ~/.config/letsencrypt/cli.ini
certbot ...
