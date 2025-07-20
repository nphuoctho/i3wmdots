# i3wm Arch Linux Configuration

---

## 🌸 Overview
A modern, minimal, and productive i3wm setup for Arch Linux, featuring a curated selection of tools for daily use and development. This repository includes configuration files, installation scripts, and pre-packaged resources to quickly set up a beautiful and functional i3 window manager environment.

## 📂 Structure
```
i3wmdots/
├── config/                 # Configuration files
│   ├── .config/            # User configuration directory
│   │   ├── i3/            # i3 window manager config
│   │   │   └── config     # i3 main configuration file
│   │   └── tmux/          # tmux configuration
│   │       └── tmux.conf  # tmux configuration file
│   ├── .p10k.zsh          # Powerlevel10k zsh theme config
│   └── .zshrc             # zsh shell configuration
├── scripts/                # Installation and utility scripts
│   ├── aur_apps.lst       # AUR packages list
│   ├── global_fn.sh       # Global functions for scripts
│   ├── install.sh         # Main installation script
│   ├── install_aur.sh     # AUR packages installer
│   ├── install_pkg.sh     # Package installer
│   ├── install_pre.sh     # Pre-installation setup
│   ├── pacman_apps.lst    # Pacman packages list
│   ├── restore_fnt.lst    # Font restoration list
│   ├── restore_svc.lst    # Service restoration list
│   └── restore_svc.sh     # Service restoration script
├── source/                 # Source files and archives
│   └── arcs/              # Archived resources
│       ├── Code_Wallbash.vsix         # VS Code Wallbash extension
│       ├── Cursor_BibataIce.tar.gz    # Bibata Ice cursor theme
│       ├── Firefox_Extensions.tar.gz  # Firefox extensions pack
│       ├── Firefox_UserConfig.tar.gz  # Firefox user configuration
│       ├── Font_CascadiaCove.tar.gz   # Cascadia Cove font
│       ├── Font_JetBrainsMono.tar.gz  # JetBrains Mono font
│       ├── Font_MapleNerd.tar.gz      # Maple Nerd font
│       ├── Font_MaterialDesign.tar.gz # Material Design icons font
│       ├── Font_MononokiNerd.tar.gz   # Mononoki Nerd font
│       ├── Font_NotoSansCJK.tar.gz    # Noto Sans CJK font
│       ├── Grub_Pochita.tar.gz        # Pochita GRUB theme
│       ├── Grub_Retroboot.tar.gz      # Retroboot GRUB theme
│       └── Icon_Wallbash.tar.gz       # Wallbash icon theme
├── .gitignore              # Git ignore file
└── README.md               # This documentation file
```

## 📑 Table of Contents
- [Overview](#-overview)
- [Structure](#-structure)
- [Features](#-features)
- [Recommendations](#-recommendations)
- [AUR Helper Setup](#aur-helper-setup)
- [Packages](#-packages)
- [Installation](#️-installation)
- [Resources](#-resources)

## ✨ Features
- **Distro:** [Arch Linux](https://archlinux.org/)
- **Window Manager:** [i3](https://i3wm.org/)
- **Display Manager:** [LightDM](https://www.lightdm.org/)
- **Screen Lock:** [betterlockscreen](https://github.com/betterlockscreen/betterlockscreen)
- **Screenshots:** [maim](https://github.com/naelstrof/maim)
- **Wallpaper:** [feh](https://feh.finalrewind.org/)
- **Browsers:** [Firefox](https://www.mozilla.org/en-US/firefox/new/), [qutebrowser](https://qutebrowser.org/)
- **Volume Control:** [pamixer](https://github.com/cdemoulins/pamixer)
- **Brightness Control:** [brightnessctl](https://github.com/Hummer12007/brightnessctl)
- **Bar:** [Polybar](https://github.com/polybar/polybar)
- **Menu/Logout:** [Rofi](https://github.com/davatorium/rofi) (custom script)
- **Clipboard Manager:** [xclip](https://github.com/astrand/xclip)
- **Shell:** [Zsh](https://www.zsh.org/) with [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- **Terminals:** [Alacritty](https://alacritty.org/), [Ghostty](https://ghostty.org/)
- **Compositor:** [Picom (FT-Labs)](https://github.com/FT-Labs/picom)
- **Editor:** [Neovim](https://neovim.io/)
- **File Managers:** [Yazi](https://github.com/sxyazi/yazi), [Dolphin](https://apps.kde.org/dolphin/)
- **Application Launcher:** [Rofi](https://github.com/davatorium/rofi)
- **Notifications:** [Dunst](https://dunst-project.org/)
- **Terminal Multiplexer:** [tmux](https://github.com/tmux/tmux/wiki)
- **Redshift:** [redshift](https://wiki.archlinux.org/title/Redshift)

## 🎨 Recommendations
### Wallpapers
- **Nordic Landscapes:** [Unsplash Nordic](https://unsplash.com/s/photos/nordic-landscape) – Minimal, fits dark themes.
- **Minimalist Art:** [Wallhaven](https://wallhaven.cc/) – Search for "minimal" or "dark".
- **Dynamic Wallpapers:** [Variety Wallpaper](https://peterlevi.com/variety/) – Auto wallpaper changer.

### Icons
- **Papirus Icon Theme:** [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) – Flexible, light/dark variants.
- **Numix Circle:** [Numix](https://github.com/numixproject/numix-icon-theme-circle) – Minimal, i3wm-friendly.
- **Tela Icon Theme:** [Tela](https://github.com/vinceliuice/Tela-icon-theme) – Modern, highly customizable.

### Themes
- **Nord Theme:** [Nord](https://www.nordtheme.com/) – Popular dark theme for i3wm.
- **Dracula Theme:** [Dracula](https://draculatheme.com/) – Beautiful, supports many apps (Dunst, Polybar, Alacritty).
- **Gruvbox:** [Gruvbox](https://github.com/morhetz/gruvbox) – Warm tones, great for retro style lovers.

### Fonts
- **JetBrains Mono:** [JetBrains Mono](https://www.jetbrains.com/lp/mono/) – Beautiful programming font, Nerd Font support.
- **Fira Code:** [Fira Code](https://github.com/tonsky/FiraCode) – Ligature feature, great for Neovim.
- **Iosevka:** [Iosevka](https://typeof.net/Iosevka/) – Minimal, high performance for terminal.

## AUR Helper Setup
### Install `yay`
Our installation script will handle this automatically, but if you want to install it manually:
```bash
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

## 📦 Packages
Package lists are organized in separate files:
- `scripts/pacman_apps.lst`: Core packages from Arch repositories
- `scripts/aur_apps.lst`: AUR packages

### Package Lists Location
The installation scripts use the following package lists:
- **Pacman packages:** `scripts/pacman_apps.lst`
- **AUR packages:** `scripts/aur_apps.lst`
- **Font restoration:** `scripts/restore_fnt.lst`
- **Service restoration:** `scripts/restore_svc.lst`

### Core Packages
- `lightdm`
- `lightdm-gtk-greeter`
- `betterlockscreen`
- `maim`
- `feh`
- `firefox`
- `qutebrowser`
- `pamixer`
- `brightnessctl`
- `polybar`
- `xclip`
- `zsh`
- `redshift`
- `ghostty`
- `picom`
- `neovim`
- `yazi`
- `dolphin`
- `rofi`
- `dunst`
- `tmux`

### Development Packages

#### Pacman Packages
- `docker`
- `docker-compose`
- `nodejs`
- `npm`
- `python`
- `git`
- `lazygit`

#### AUR Packages
- `lazydocker`
- `lazysql`

## 🛠️ Installation
To install these dotfiles, simply clone the repository and run the installation script:

```bash
git clone https://github.com/yourusername/i3wmdots.git
cd i3wmdots
chmod +x scripts/install.sh
./scripts/install.sh
```

The installation process includes:
- **Pre-installation setup:** `scripts/install_pre.sh`
- **Package installation:** `scripts/install_pkg.sh` 
- **AUR packages:** `scripts/install_aur.sh`
- **Service restoration:** `scripts/restore_svc.sh`

All installation scripts use shared functions from `scripts/global_fn.sh`.

## 📚 Resources
The `source/arcs/` directory contains pre-packaged resources:

### Fonts
- **Cascadia Cove:** Modern coding font with ligatures
- **JetBrains Mono:** Professional development font
- **Maple Nerd:** Nerd Font variant with icons
- **Material Design:** Icon fonts for UI elements
- **Mononoki Nerd:** Monospace programming font
- **Noto Sans CJK:** Comprehensive Asian language support

### Themes & Customization
- **Code Wallbash:** VS Code extension for dynamic theming
- **Bibata Ice Cursor:** Modern cursor theme
- **Wallbash Icons:** Dynamic icon theming
- **Pochita GRUB:** Anime-inspired GRUB theme
- **Retroboot GRUB:** Retro-style boot theme

### Browser Extensions
- **Firefox Extensions:** Curated extension pack
- **Firefox User Config:** Optimized browser settings

## 🔧 Configuration Details

### i3 Window Manager
The i3 configuration includes:
- Custom keybindings for productivity
- Workspace management
- Application-specific window rules
- Integration with system tools

### Zsh Shell
Features include:
- Powerlevel10k theme configuration
- Custom aliases and functions
- Enhanced completion system
- Plugin management

### tmux Terminal Multiplexer
Configuration provides:
- Custom key bindings
- Status bar customization
- Session management
- Plugin support

---

**Author:** PhuocTho OcD  
**License:** MIT  
**Last Updated:** June 2025
