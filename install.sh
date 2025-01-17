#!/bin/bash
set -e

if [ $EUID -ne 0 ]; then
    echo "$0 is not running as root. Try using sudo."
    exit 2
fi

USERNAME=$(id -nu "$SUDO_UID")

sudo pacman -Syu \
    iwd \
    openssh \
    inetutils \
    nm-connection-editor \
    network-manager-applet \
    bluez \
    sof-firmware \
    lightdm \
    lightdm-gtk-greeter \
    xorg-xrandr \
    autorandr \
    arandr \
    i3-wm \
    i3status \
    i3lock \
    dmenu \
    dunst \
    man-db \
    nitrogen \
    alacritty \
    chromium \
    docker \
    docker-buildx \
    docker-compose \
    tree \
    curl \
    wget \
    htop \
    vim \
    flameshot \
    make \
    jq \
    git \
    imwheel \
    fuse \
    openvpn \
    bash-completion \
    peek \
    nautilus \
    ttf-dejavu \
    ttf-liberation \
    ttf-font-awesome \
    noto-fonts \
    noto-fonts-emoji \
    zip \
    unzip \
    net-tools \
    dnsutils \
    speedtest-cli \
    keychain \
    openresolv \
    wireguard-tools \
    terraform \
    packer \
    spotify-launcher \
    go \
    firewalld \
    gedit \
    ansible \
    traceroute \
    vlc \
    eog \
    unrar \
    kubectl \
    helm \
    postgresql-client \
    blueman \
    bluez \
    whois \
    networkmanager-l2tp \
    strongswan \
    gnome-disk-utility \
    gum \
    --noconfirm

sudo systemctl enable lightdm

echo "Xcursor.size: 24" > $HOME/.Xresources

# Docker post installation
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

sudo groupadd docker || echo "ok"
sudo usermod -aG docker "$USERNAME"

# use buildkit by default and set mtu to match Wireguard
mkdir -p /etc/docker
echo '{ "features": { "buildkit": true }, "mtu": 1420 }' | sudo tee /etc/docker/daemon.json

# Firewalld post installation
sudo systemctl enable --now firewalld

# Light post installation
sudo usermod -a -G video "$USERNAME"

# Allow users to run nmcli assuming root
sudo chmod +s /usr/bin/nmcli

if [ "$1" == "--yay" ]; then
  # Install yay
  if [ ! -d "/home/$USERNAME/yay" ]; then
    sudo -u "$USERNAME" git clone https://aur.archlinux.org/yay.git "/home/$USERNAME/yay"
    (cd "/home/$USERNAME/yay" && sudo -u "$USERNAME" makepkg -si)
  else
    echo "yay already installed"a
  fi

  # Update everything
  sudo -u "$USERNAME" yay -Sy

  # Install
  sudo -u "$USERNAME" yay -S --noconfirm --answerdiff=None --answerclean=None \
   aws-cli-v2 \
   amazon-ecr-credential-helper \
   slack-desktop
fi

echo "Done"
