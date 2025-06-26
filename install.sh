#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to check if a package is installed
is_installed() {
    pacman -Qs "$1" > /dev/null 2>&1
    return $?
}

# Function to install a package via pacman
install_package() {
    if ! is_installed "$1"; then
        echo -e "${GREEN}Installing $1...${NC}"
        sudo pacman -S --noconfirm "$1"
    else
        echo -e "${RED}$1 is already installed, skipping...${NC}"
    fi
}

# Function to install a package via yay (AUR)
install_aur_package() {
    if ! is_installed "$1"; then
        echo -e "${GREEN}Installing AUR package $1...${NC}"
        yay -S --noconfirm "$1"
    else
        echo -e "${RED}$1 is already installed, skipping...${NC}"
    fi
}

# Function to clone and install Git repository
install_git_repo() {
    local repo_name=$(basename "$1" .git)
    local install_dir="$HOME/.local/src/$repo_name"
    if [ ! -d "$install_dir" ]; then
        echo -e "${GREEN}Cloning and installing $repo_name...${NC}"
        mkdir -p "$HOME/.local/src"
        git clone "$1" "$install_dir"
        cd "$install_dir" && make install || echo -e "${RED}Installation of $repo_name failed, please check manually.${NC}"
    else
        echo -e "${RED}$repo_name is already cloned, skipping...${NC}"
    fi
}

# Install yay (AUR helper)
install_yay() {
    if ! is_installed "yay"; then
        echo -e "${GREEN}Installing yay (AUR helper)...${NC}"
        sudo pacman -S --needed base-devel git
        git clone https://aur.archlinux.org/yay.git "$HOME/.local/src/yay"
        cd "$HOME/.local/src/yay" && makepkg -si --noconfirm
    else
        echo -e "${RED}yay is already installed, skipping...${NC}"
    fi
}

# Core Packages
CORE_PACKAGES=(
    "lightdm" "lightdm-gtk-greeter" "betterlockscreen" "maim" "feh" "firefox"
    "qutebrowser" "pamixer" "brightnessctl" "polybar" "xclip" "zsh" "alacritty"
    "ghostty" "picom" "neovim" "yazi" "dolphin" "rofi" "dunst" "tmux"
)

# Development Pacman Packages
DEV_PACMAN_PACKAGES=(
    "docker" "docker-compose" "nodejs" "npm" "python" "git" "lazygit" "lazysql"
)

# Development AUR Packages
DEV_AUR_PACKAGES=(
    "i3-gaps" "lazydocker"
)

# Development Git Repositories
DEV_GIT_REPOS=(
    "https://github.com/zsh-users/zsh-autosuggestions.git"
    "https://github.com/zsh-users/zsh-syntax-highlighting.git"
)

# Enable LightDM
enable_lightdm() {
    sudo systemctl enable lightdm
    echo -e "${GREEN}LightDM enabled.${NC}"
}

# Basic configuration
configure_basic() {
    # Configure i3 (copy default config if not exists)
    if [ ! -f ~/.config/i3/config ]; then
        mkdir -p ~/.config/i3
        cp /etc/i3/config ~/.config/i3/config
        echo -e "${GREEN}i3 config copied to ~/.config/i3/config${NC}"
    fi

    # Basic Polybar config
    if [ ! -f ~/.config/polybar/config ]; then
        mkdir -p ~/.config/polybar
        cat > ~/.config/polybar/config << EOL
[bar/main]
width = 100%
height = 30
background = #2E3440
foreground = #D8DEE9
modules-left = i3
modules-right = date
tray-position = right

[module/date]
type = internal/date
date = %Y-%m-%d%
time = %H:%M
label = %date% %time%
EOL
        echo -e "${GREEN}Polybar config created at ~/.config/polybar/config${NC}"
    fi

    # Basic Dunst config
    if [ ! -f ~/.config/dunst/dunstrc ]; then
        mkdir -p ~/.config/dunst
        cat > ~/.config/dunst/dunstrc << EOL
[global]
    monitor = 0
    geometry = "300x5-30+20"
    transparency = 10
    frame_color = "#81A1C1"
    font = JetBrainsMono Nerd Font 12
EOL
        echo -e "${GREEN}Dunst config created at ~/.config/dunst/dunstrc${NC}"
    fi
}

# Install function
install() {
    echo -e "${GREEN}=== Installing yay (AUR helper) ===${NC}"
    install_yay

    echo -e "${GREEN}=== Installing Core Packages ===${NC}"
    for pkg in "${CORE_PACKAGES[@]}"; do
        install_package "$pkg"
    done

    echo -e "${GREEN}=== Installing Development Pacman Packages ===${NC}"
    for pkg in "${DEV_PACMAN_PACKAGES[@]}"; do
        install_package "$pkg"
    done

    echo -e "${GREEN}=== Installing Development AUR Packages ===${NC}"
    for pkg in "${DEV_AUR_PACKAGES[@]}"; do
        install_aur_package "$pkg"
    done

    echo -e "${GREEN}=== Installing Development Git Repositories ===${NC}"
    for repo in "${DEV_GIT_REPOS[@]}"; do
        install_git_repo "$repo"
    done

    enable_lightdm
    configure_basic
    echo -e "${GREEN}Installation complete! Please reboot to apply changes.${NC}"
}

# Run install
install