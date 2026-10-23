#!/bin/bash
set -e

REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME="$(getent passwd "$REAL_USER" | cut -d: -f6)"

# It should be run with `sudo`, but some commands will not require such permissions and will be dropped

echo "=========================================================================="
echo "Updating system packages..."
dnf -y update
echo "... done."

echo "=========================================================================="
echo "Installing packages"
echo "- Package managers..."
dnf -y install pipx git
echo "... done."

echo "- Browsers..."
dnf -y install qutebrowser
echo "... done."

echo "- Utilities..."
# tuxguitar is gone from Fedora 42 and I found no alternative solution
dnf -y install fish kitty htop wlsunset flameshot zathura zathura-pdf-poppler pandoc thunderbird libreoffice ipe hledger keepassxc swappy tmux
echo "... done."

echo "- Virtualization..."
dnf -y install libvirt virt-manager qemu
echo "... done."

echo "- Neovim..."
dnf -y install neovim gcc fd-find nodejs cargo python3-pip
echo "... done."

echo "- Latex (installing medium set of packages)..."
dnf -y install texlive-scheme-medium texlive-powerdot texlive-luapstricks
echo "... done."

# `iptables-legacy` is required for docker to work in Fedora 42+
echo "- Programming..."
dnf -y install httpie docker docker-compose R-devel python3-devel iptables-legacy
dnf copr enable atim/lazygit -y
dnf -y install lazygit
echo "... done."

echo "- Pipx packages..."
sudo -H -u "$REAL_USER" pipx install uv
sudo -H -u "$REAL_USER" pipx install ruff # althought I can install it in my nvim with ruff as well
echo "... done."

echo "- Extra desktop and window managers..."
# Noctalia desktop shell v5 (Fedora 44 only)
dnf install noctalia
echo "... done."

# Opencode
sudo -H -u "$REAL_USER" curl -fsSL https://opencode.ai/v2/install | bash

# Agent of empires
sudo -H -u "$REAL_USER" curl -fsSL https://raw.githubusercontent.com/agent-of-empires/agent-of-empires/main/scripts/install.sh | bash


echo "=========================================================================="
echo "Preparing for neovim..."

nvim_path="$REAL_HOME/.config/nvim"

if [ -d "$nvim_path" ]; then
    echo "...neovim config already exists. Skipping."
else
    # Make sure to have SSH keys set up for git access
    sudo -H -u "$REAL_USER" git clone "git@github.com:fillipe-gsm/fedora-install.git" "$nvim_path"
    echo "...open neovim and see everything being installed."
fi

echo "=========================================================================="
echo "Adding multimedia support via RPM Fusion..."
# Enabling the non-free repo
dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Switch to full ffmpeg
dnf -y swap ffmpeg-free ffmpeg --allowerasing

# Install additional codecs
# Fedora 42
dnf update -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

echo "... done."

echo "=========================================================================="
echo "Installing Mullvad VPN"
#dnf config-manager --add-repo https://repository.mullvad.net/rpm/stable/mullvad.repo  # Fedora 40
dnf config-manager addrepo --overwrite --from-repofile=https://repository.mullvad.net/rpm/stable/mullvad.repo # Fedora 41 or later
dnf install -y mullvad-vpn

echo "... done."

echo "=========================================================================="
echo "Configuring docker..."

systemctl enable docker # enable it on startup
systemctl start docker  # start it now

# Add current user to "docker" group so we don't need `sudo` to use it
groupadd -f docker
gpasswd -a "${REAL_USER}" docker
# newgrp docker  # to log-in if required

echo "... done."

echo "=========================================================================="
echo "Configuring git"

sudo -H -u "$REAL_USER" git config --global user.email "fillipe.gsm@tutanota.com"
sudo -H -u "$REAL_USER" git config --global user.name "Fillipe Goulart"

echo "... done."

echo "=========================================================================="
echo "Installing yazi file manager"
dnf copr enable lihaohong/yazi -y
dnf install -y yazi
echo "... done."

echo "=========================================================================="
echo "Copying .config files (with symbolic links)"
sudo -H -u "$REAL_USER" mkdir -p /home/$REAL_USER/.config/sway
sudo -H -u "$REAL_USER" cp -r $PWD/config/sway/wallpapers /home/$REAL_USER/.config/sway/wallpapers
sudo -H -u "$REAL_USER" mkdir -p /home/$REAL_USER/.config/sway/config.d
# Noctalia v5 settings live in ~/.local/state/noctalia/settings.toml (tracked in git)
sudo -H -u "$REAL_USER" mkdir -p /home/$REAL_USER/.local/state/noctalia
sudo -H -u "$REAL_USER" ln -sfn "$PWD/config/noctalia/settings.toml" /home/$REAL_USER/.local/state/noctalia/settings.toml
sudo -H -u "$REAL_USER" ln -sf $PWD/config/sway_noctalia/config /home/$REAL_USER/.config/sway/config
# Disable Fedora default bar/idle/volume/brightness/media/screenshot bindings (replaced by Noctalia)
for f in 90-bar.conf 90-swayidle.conf 60-bindings-volume.conf 60-bindings-brightness.conf 60-bindings-media.conf 60-bindings-screenshot.conf; do
  sudo -H -u "$REAL_USER" ln -sf $PWD/config/sway_noctalia/config.d/$f /home/$REAL_USER/.config/sway/config.d/$f
done
# Waybar config kept for fallback but not used (Noctalia bar is default)
sudo -H -u "$REAL_USER" mkdir -p "/home/$REAL_USER/.config/waybar"
sudo -H -u "$REAL_USER" ln -sf "$PWD/config/waybar/config" "/home/$REAL_USER/.config/waybar/config"

# Kitty configs as symlinks
kitty_dest="/home/$REAL_USER/.config/kitty"
[ -L "$kitty_dest" ] && rm -f "$kitty_dest"
sudo -H -u "$REAL_USER" mkdir -p "$kitty_dest"
for f in "$PWD"/config/kitty/*; do
  sudo -H -u "$REAL_USER" ln -sfn "$f" "$kitty_dest/$(basename "$f")"
done

# Yazi
sudo -H -u "$REAL_USER" mkdir -p "/home/$REAL_USER/.config/yazi"
sudo -H -u "$REAL_USER" ln -sf "$PWD/config/yazi/yazi.toml" "/home/$REAL_USER/.config/yazi/yazi.toml"

# Agent of empires (Agent orchestration)
sudo -H -u "$REAL_USER" mkdir -p "/home/$REAL_USER/.config/agent-of-empires"
sudo -H -u "$REAL_USER" ln -sf "$PWD/config/agent-of-empires/config.toml" "/home/$REAL_USER/.config/agent-of-empires/config.toml"

# Fish shell extras
sudo -H -u "$REAL_USER" curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
fisher install Asim-Tahir/opencode.fish

echo "... done."