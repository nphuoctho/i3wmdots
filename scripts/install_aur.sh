#!/usr/bin/env bash
#|---/ /+-------------------------------------------+---/ /|#
#|--/ /-| Script to install aur helper, yay or paru |--/ /-|#
#|-/ /--| PhuocTho OcD                              |-/ /--|#
#|/ /---+-------------------------------------------+/ /---|#

scrDir=$(dirname "$(realpath "$0")")
source "${scrDir}/global_fn.sh"
if [ $? -ne 0 ]; then
    echo "Error: unable to source global_fn.sh..."
    exit 1
fi

if chk_list "aurhlpr" "${aurList[@]}"; then
    echo -e "\033[0;32m[AUR]\033[0m detected // ${aurhlpr}"
    exit 0
fi

aurhlpr="yay"

# Parse use_default from command line or environment
use_default="${use_default:-""}"

if [ -d "$HOME/Clone" ]; then
    echo "~/Clone directory exists..."
    rm -rf "$HOME/Clone/${aurhlpr}"
else
    mkdir "$HOME/Clone"
    echo -e "[Desktop Entry]\nIcon=default-folder-git" > "$HOME/Clone/.directory"
    echo "~/Clone directory created..."
fi

if pkg_installed git; then
    git clone "https://aur.archlinux.org/${aurhlpr}.git" "$HOME/Clone/${aurhlpr}"
else
    echo "git dependency is not installed..."
    exit 1
fi

cd "$HOME/Clone/${aurhlpr}"
makepkg ${use_default} -si

if [ $? -eq 0 ]; then
    echo "${aurhlpr} aur helper installed..."
    echo "Cleaning up Clone directory..."
    rm -rf "$HOME/Clone"
    
    # Ask if user wants to install AUR apps
    if [ -f "${scrDir}/aur_apps.lst" ]; then
        echo ""
        read -p "Do you want to install AUR applications (y/n): " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Installing AUR applications..."
            ${aurhlpr} -S $(grep -v '^#' "${scrDir}/aur_apps.lst" | grep -v '^$' | awk '{print $1}')
        else
            echo "Skipping AUR applications installation."
        fi
    else
        echo "Warning: aur_apps.lst not found in ${scrDir}"
    fi
    
    exit 0
else
    echo "${aurhlpr} installation failed..."
    exit 1
fi

