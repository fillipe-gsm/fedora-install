#!/bin/bash

echo "=========================================================================="
echo "Updating system packages..."
sudo dnf -y update
echo "... done."

echo "=========================================================================="
echo "Installing packages"
echo "- Package managers..."
sudo dnf -y install pipx git
echo "... done."

echo "- Utilities..."
sudo dnf -y install fish kitty ranger htop wlsunset flameshot pass zathura zathura-pdf-poppler tuxguitar pandoc thunderbird-wayland tmux
echo "... done."

echo "- Neovim..."
sudo dnf -y install neovim gcc fd-find nodejs cargo python3-pip
echo "... done."

echo "- Latex (installing medium set of packages)..."
sudo dnf -y install texlive-scheme-medium
echo "... done."

echo "- Programming..."
sudo dnf -y install httpie docker docker-compose
sudo dnf copr enable atim/lazygit -y
sudo dnf -y install lazygit
echo "... done."

echo "- Pipx packages..."
pipx install "xonsh[full]" & pipx install "poetry"
echo "... done."

echo "- Xonsh xontribs..."
# Have to call momentarily from `xonsh`
xonsh -lic "xpip install xontrib-vox && xpip install xontrib-whole-word-jumping && xpip install xontrib-fish-completer"
echo "... done."

echo "=========================================================================="
echo "Copying .config files (with symbolic links)"
ln -sf $PWD/config/sway/config ~/.config/sway/config
ln -sf $PWD/config/waybar/config ~/.config/waybar/config
ln -sf $PWD/config/kitty ~/.config/kitty
# cp --archive --verbose --recursive --update ./config/. ~/.config/

echo "Copying .xonshrc configuration"
cp --verbose --update ./xonsh/.xonshrc ~/

echo "... done."

echo "=========================================================================="
echo "Preparing for neovim..."

nvim_path="$HOME/.config/nvim"

if [ -d "$nvim_path" ]; then
	echo "...neovim config already exists. Skipping."
else
	git clone "https://github.com/fillipe-gsm/kickstart.nvim.git" "$nvim_path"
	echo "...open neovim and see everything being installed."
fi

echo "=========================================================================="
echo "Adding multimedia support via RPM Fusion..."

# Enabling the non-free repo
sudo dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Switch to full ffmpeg
sudo dnf -y swap ffmpeg-free ffmpeg --allowerasing

# Install additional codecs
sudo dnf -y groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf -y groupupdate sound-and-video

echo "... done."

echo "=========================================================================="
echo "Configuring docker..."

sudo systemctl enable docker  # enable it on startup
sudo systemctl start docker  # start it now

# Add current user to "docker" group so we don't need `sudo` to use it
sudo groupadd docker
sudo gpasswd -a ${USER} docker
# newgrp docker  # to log-in if required

echo "... done."
