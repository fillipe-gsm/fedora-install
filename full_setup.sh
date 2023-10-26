#!/bin/bash

echo "=========================================================================="
echo "Installing packages"
echo "- Package managers..."
sudo dnf -y install pipx git
echo "... done."

echo "- Utilities..."
sudo dnf -y install fish kitty ranger htop wlsunset flameshot pass zathura zathura-pdf-poppler
echo "... done."

echo "- Neovim..."
sudo dnf install neovim gcc fd-find nodejs cargo python3-pip
echo "... done."

echo "- Pipx packages..."
pipx install "xonsh[full]" & pipx install "poetry"
echo "... done."

echo "- Xonsh xontribs..."
xpip install xontrib-vox & xpip install xontrib-whole-word-jumping & xpip install xontrib-fish-completer
echo "... done."

echo "=========================================================================="
echo "Copying .config files"
cp --archive --verbose --recursive --update ./config/. ~/.config/

echo "Copying .xonshrc configuration"
cp --verbose --update ./xonsh/.xonshrc ~/
