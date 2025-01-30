#!/bin/bash

# IT should be run with `sudo`, but some commands will not require such permissions and will be dropped

echo "=========================================================================="
echo "Updating system packages..."
dnf -y update
echo "... done."

echo "=========================================================================="
echo "Installing packages"
echo "- Package managers..."
dnf -y install pipx git
echo "... done."

echo "- Utilities..."
dnf -y install fish kitty htop wlsunset flameshot zathura zathura-pdf-poppler tuxguitar pandoc thunderbird libreoffice ipe hledger
echo "... done."

echo "- Virtualization..."
dnf -y install libvirt virt-manager qemu
echo "... done."

echo "- Neovim..."
dnf -y install neovim gcc fd-find nodejs cargo python3-pip
echo "... done."

echo "- Latex (installing medium set of packages)..."
dnf -y install texlive-scheme-medium
echo "... done."

echo "- Programming..."
dnf -y install httpie docker docker-compose R-devel
dnf copr enable atim/lazygit -y
dnf -y install lazygit
echo "... done."

echo "- Pipx packages..."
sudo -u $USER pipx install "poetry" 
sudo -u $USER pipx install ranger-fm
# pipx install "xonsh[full]" & pipx install "poetry" & pipx install ranger-fm
echo "... done."

# Thinking about ignoring xonsh
# echo "- Xonsh xontribs..."
# # Have to call momentarily from `xonsh`
# xonsh -lic "xpip install xontrib-vox && xpip install xontrib-whole-word-jumping && xpip install xontrib-fish-completer"
# echo "... done."

echo "=========================================================================="
echo "Copying .config files (with symbolic links)"
sudo -u $USER mkdir -p /home/$USER/.config/sway
sudo -u $USER mkdir -p /home/$USER/.config/waybar
sudo -u $USER ln -sf $PWD/config/sway/config /home/$USER/.config/sway/config
sudo -u $USER ln -sf $PWD/config/waybar/config /home/$USER/.config/waybar/config
sudo -u $USER ln -sf $PWD/config/kitty /home/$USER/.config/kitty

# echo "Copying .xonshrc configuration"
# cp --verbose --update ./xonsh/.xonshrc ~/

echo "... done."

echo "=========================================================================="
echo "Preparing for neovim..."

nvim_path="$HOME/.config/nvim"

if [ -d "$nvim_path" ]; then
	echo "...neovim config already exists. Skipping."
else
	sudo -u $USER git clone "https://github.com/fillipe-gsm/kickstart.nvim.git" "$nvim_path"
	echo "...open neovim and see everything being installed."
fi

echo "=========================================================================="
echo "Adding multimedia support via RPM Fusion..."

# Enabling the non-free repo
dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Switch to full ffmpeg
dnf -y swap ffmpeg-free ffmpeg --allowerasing

# Install additional codecs
dnf -y groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
dnf -y groupupdate sound-and-video

echo "... done."

echo "=========================================================================="
echo "Installing Mullvad VPN"
#dnf config-manager --add-repo https://repository.mullvad.net/rpm/stable/mullvad.repo  # Fedora 40 
dnf config-manager addrepo --from-repofile=https://repository.mullvad.net/rpm/stable/mullvad.repo  # Fedora 41
dnf install -y mullvad-vpn

echo "... done."

echo "=========================================================================="
echo "Configuring docker..."

systemctl enable docker  # enable it on startup
systemctl start docker  # start it now

# Add current user to "docker" group so we don't need `sudo` to use it
groupadd docker
gpasswd -a ${USER} docker
# newgrp docker  # to log-in if required

echo "... done."

echo "=========================================================================="
echo "Configuring git"

git config --global user.email "fillipe.gsm@tutanota.com"
git config --global user.name "Fillipe Goulart"
