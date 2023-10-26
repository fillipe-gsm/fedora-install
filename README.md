# Fedora new installation

A companion of files, scripts and notes to have a proper Fedora installation from scratch.
After cloning this repo, run

```bash
bash full_setup.sh
```

and let everything run by itself.

The following sections are just brief explanations of the config files and annotations given my research when creating this script.


# Post-installation steps

## Installing packages
### System Packages

```bash
sudo dnf install pipx git
# Utilities
sudo dnf install fish kitty ranger htop wlsunset flameshot pass zathura zathura-pdf-poppler
# Neovim specific packages
sudo dnf install neovim gcc fd-find nodejs cargo python3-pip
```

### pipx packages

```bash
pipx install "xonsh[full]" & pipx install "poetry"
```

## Software configuration

### Sway

In the first time running it, copy the default configuration:

```bash
mkdir -p ~/.config/sway
cp /etc/sway/config ~/.config/sway/config
```

A lot of things must be configured there, such as keyboard layouts, rate, the "toggle back" workspaces, and autostart apps.

Otherwise, just copy the config file from the `config/sway` folder.

### Waybar
Most of Fedora's default config seem o.k., with the exception of the bar position that I prefer at the bottom.

Copy the configuration:

```bash
mkdir -p ~/.config/waybar
cp /etc/xdg/waybar/config ~/.config/waybar/config
```

and add `position: botttom`.

### Xonsh shell

Install the required xontribs

```bash
xpip install xontrib-vox & xpip install xontrib-whole-word-jumping & xpip install xontrib-fish-completer
```

Then copy the `.xonshrc` file to the `$HOME` directory.

### Kitty Terminal

First time running Kitty, you can create a default config pressing `Ctrl + Shift + F2`.

The following important configurations are:

- `shell <shell>`: Run the following shell when opening. This may be safer than using `chsh` since it can accept non-POSIX compliant shells, like `xonsh` and `nu`.

For themes, check the website. The current config folder has a selected light theme that looks nice in the eyes.


# Commands

## Update system

```bash
sudo dnf update
```

## Install package

```bash
sudo dnf install <package-name>
```

## Search package

```bash
sudo dnf search <keyword>
```
