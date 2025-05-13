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
pipx install "poetry"
```

## Additional multimedia support

Fedora ships with free plugins for sound, which seem to work in mainstream sites such as YouTube. But for added support one needs to enable the non-free repo. Take a look at [this page](https://rpmfusion.org/Howto/Multimedia) for more information.

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

### Kitty Terminal

First time running Kitty, you can create a default config pressing `Ctrl + Shift + F2`.

The following important configurations are:

- `shell <shell>`: Run the following shell when opening. This may be safer than using `chsh` since it can accept non-POSIX compliant shells, like `xonsh` and `nu`.

For themes, check the website. The current config folder has a selected light theme that looks nice in the eyes.

### Latex

See [this page](https://docs.fedoraproject.org/en-US/neurofedora/latex/) for details with running LaTeX in Fedora. Here I am trying to setup with the *medium* set of packages.


### IRPF

Esta seção está em português por ser específica do Brasil.

Para usar o programa do IRPF sempre precisamos primeiro de usar uma versão compatível do Java. O script de instalação atual já permite que eu possa alterá-la se necessário, então isto está coberto.

O segundo problema é na hora de enviar, em que recebo erros de certificado. Veja [esta página para detalhes](https://www.vivaolinux.com.br/dica/Problema-na-Transmissao-da-Declaracao-de-Imposto-de-Renda-PF-pelo-Aplicativo-IRPF-Resolvido).

No fim das contas, para funcionar no Fedora, eu fiz o seguinte:

- Abra o arquivo `/etc/crypto-policies/back-ends/java.config` com permissão de root;
- Comente *todas* as linhas. O site recomenda apenas uma, mas para funcionar eu precisei desabilitar tudo.

Isso pode parecer inseguro, mas mais que isso é ficar em débito com a receita federel.

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
