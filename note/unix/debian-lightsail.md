# 更新成 debian sid
echo 'deb http://ftp.debian.org/debian sid main' | sudo tee /etc/apt/sources.list
sudo apt update && sudo apt -y dist-upgrade && sudo apt -y full-upgrade

# 环境
sudo apt install -y build-essential
sudo apt install -y git neovim htop tmux sshguard ldnsutils
sudo apt install -y zsh zsh-syntax-highlighting zsh-autosuggestions
sudo apt install -y exa fzf ripgrep bat
sudo apt install -y nodejs npm

# 配置 ntp
sudo apt remove -y chrony

# 切换 shell
sudo chsh -s /usr/bin/zsh admin

# 配置 locale
sudo dpkg-reconfigure locales
sudo update-locale LANG=en_US.UTF-8
sudo update-locale LC_COLLATE=C
cat /etc/default/locale

# 编辑器
sudo update-alternatives --config editor

# 配置 ss
sudo apt install -y shadowsocks-libev shadowsocks-v2ray-plugin
sudo vim /etc/shadowsocks-libev/config.json
sudo systemctl restart shadowsocks-libev.service

# 配置 nginx
sudo apt install -y nginx-full certbot
sudo vim /etc/nginx/nginx.conf
mkdir -p ~/.config/letsencrypt
vim ~/.config/letsencrypt/cli.ini
certbot register --agree-tos --register-unsafely-without-email

# dns
echo 'nameserver 1.1.1.1\nnameserver 1.0.0.1' | sudo tee /etc/resolv.conf
sudo chattr +i /etc/resolv.conf
echo "127.0.0.1 $(hostname)" | sudo tee -a /etc/hosts

# sshguard
sudo vim /etc/ssh/sshd_config
sudo mkdir -p /var/lib/sshguard
sudo touch /var/lib/sshguard/blacklist.db
sudo vim /etc/sshguard/whitelist
sudo vim /etc/sshguard/sshguard.conf
sudo systemctl restart sshguard.service

# sysctl
sudo vim /etc/sysctl.d/66-bbr.conf
sudo sysctl --system
