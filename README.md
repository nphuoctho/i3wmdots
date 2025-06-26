# i3wm Arch Linux Configuration

---

## 🌸 Overview
A modern, minimal, and productive i3wm setup for Arch Linux, featuring a curated selection of tools for daily use and development.

## 📂 Structure
```
dotfiles/
├── config/                 # Configuration files
│   ├── base/               # Base configurations (terminal, shell, etc.)
│   │   ├── ghostty/
│   │   ├── zsh/
│   │   └── tmux/
│   ├── desktop/            # Desktop environment configs
│   │   ├── i3/
│   │   ├── polybar/
│   │   ├── rofi/
│   │   ├── dunst/
│   │   └── picom/
│   ├── development/        # Development tool configs
│   │   ├── nvim/
│   │   └── git/
│   └── media/              # Media tool configs
├── scripts/                # Utility scripts
│   ├── install/            # Installation scripts
│   ├── setup/              # Setup scripts
│   └── utils/              # Utility scripts
├── themes/                 # Theme files
│   ├── wallpapers/
│   ├── icons/
│   └── fonts/
├── packages/               # Package lists
│   ├── pacman.txt
│   └── aur.txt
├── install.sh              # Main installation script
├── uninstall.sh            # Main uninstallation script
└── README.md               # Documentation
```

## 📑 Table of Contents
- [Overview](#-overview)
- [Structure](#-structure)
- [Features](#-features)
- [Recommendations](#-recommendations)
- [AUR Helper Setup](#aur-helper-setup)
- [Packages](#-package)
- [Installation](#️-installation)
- [Uninstallation](#-uninstallation)

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
- **Shell:** [Zsh](https://www.zsh.org/)
- **Terminals:** [Alacritty](https://alacritty.org/), [Ghostty](https://ghostty.org/)
- **Compositor:** [Picom (FT-Labs)](https://github.com/FT-Labs/picom)
- **Editor:** [Neovim](https://neovim.io/)
- **File Managers:** [Yazi](https://github.com/sxyazi/yazi), [Dolphin](https://apps.kde.org/dolphin/)
- **Application Launcher:** [Rofi](https://github.com/davatorium/rofi)
- **Notifications:** [Dunst](https://dunst-project.org/)
- **Terminal Multiplexer:** [tmux](https://github.com/tmux/tmux/wiki)

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

## � Installation
To install these dotfiles, simply clone the repository and run the installation script:

```bash
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles
chmod +x install.sh
./install.sh
```

The installer provides various options:
- Full installation (recommended)
- Core components only
- Development tools only
- Custom installation

## 🗑️ Uninstallation
To remove these dotfiles and configurations:

```bash
cd dotfiles
chmod +x uninstall.sh
./uninstall.sh
```

The uninstaller provides various options:
- Remove all (configs, packages, AUR packages)
- Remove configurations only (keep packages)
- Remove packages only (keep configs)
- Custom uninstallation

## �📦 Packages
Package lists are now organized in separate files:
- `pacman.txt`: Core packages from Arch repositories
- `aur.txt`: AUR packages

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
- `alacritty`
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
