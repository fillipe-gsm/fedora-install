# Fedora new installation

A companion of files, scripts and notes to have a proper Fedora installation from scratch.
This

# Post-installation steps

## Installing packages
### System Packages

```bash
sudo dnf install kitty ranger pipx neovim
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

Otherwise, just copy the config file from the `config/sway` folder.

### Xonsh shell

Install the required xontribs

### Kitty Terminal

First time running Kitty, you can create a default config pressing `Ctrl + Shift + F2`.

The following important configurations are:

- `shell <shell>`: Run the following shell when opening. This may be safer than using `chsh` since it can accept non-POSIX compliant shells, like `xonsh` and `nu`.

TODO: Create a default `kitty.conf` so I can just download it from a git repository.


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

## Change keyboard layout
