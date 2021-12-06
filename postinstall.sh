set -e

sudo pacman -S \
    lightdm \
    lightdm-gtk-greeter \
    arandr \
    i3-wm \
    i3status \
    dmenu \
    gnome-terminal \
    chromium \
    docker \
    docker-compose \
    tree \
    curl \
    htop \
    nano \
    flameshot \
    make \
    jq \
    git \
    code \
    imwheel \
    --noconfirm

sudo systemctl enable lightdm

echo "Xcursor.size: 24" > ~/.Xresources

# Docker post installation
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

sudo groupadd docker || echo "ok"
sudo usermod -aG docker $USER

# Install snapd
git clone https://aur.archlinux.org/snapd.git ~/snapd || echo "snapd already cloned"
(cd ~/snapd && makepkg -s --noconfirm) || ERROR_CODE=$?
if [ "${ERROR_CODE}" -ne 13 ]; then
    echo "something bad happened"
    exit "${ERROR_CODE}"
fi

(cd ~/snapd && sudo pacman -U snapd-*-x86_64.pkg.tar.zst --noconfirm)

sudo systemctl enable snapd

# Install spotify
sudo snap install spotify

echo "Done, now reboot for snapd and docker without sudo to work"