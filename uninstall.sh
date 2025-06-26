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

# Function to remove a package
remove_package() {
    if is_installed "$1"; then
        echo -e "${GREEN}Removing $1...${NC}"
        sudo pacman -Rns --noconfirm "$1"
    else
        echo -e "${RED}$1 is not installed, skipping...${NC}"
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

# Development Git Repositories (remove directories)
DEV_GIT_REPOS=(
    "https://github.com/zsh-users/zsh-autosuggestions.git"
    "https://github.com/zsh-users/zsh-syntax-highlighting.git"
)

# Uninstall function
uninstall() {
    echo -e "${GREEN}=== Uninstalling Core Packages ===${NC}"
    for pkg in "${CORE_PACKAGES[@]}"; do
        remove_package "$pkg"
    done

    echo -e "${GREEN}=== Uninstalling Development Pacman Packages ===${NC}"
    for pkg in "${DEV_PACMAN_PACKAGES[@]}"; do
        remove_package "$pkg"
    done

    echo -e "${GREEN}=== Uninstalling Development AUR Packages ===${NC}"
    for pkg in "${DEV_AUR_PACKAGES[@]}"; do
        remove_package "$pkg"
    done

    echo -e "${GREEN}=== Removing Development Git Repositories ===${NC}"
    for repo in "${DEV_GIT_REPOS[@]}"; do
        local repo_name=$(basename "$repo" .git)
        local install_dir="$HOME/.local/src/$repo_name"
        if [ -d "$install_dir" ]; then
            echo -e "${GREEN}Removing $repo_name...${NC}"
            rm -rf "$install_dir"
        else
            echo -e "${RED}$repo_name not found, skipping...${NC}"
        fi
    done

    # Disable LightDM
    sudo systemctl disable lightdm
    echo -e "${GREEN}Uninstallation complete!${NC}"
}

# Run uninstall
uninstall