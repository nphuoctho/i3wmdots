#!/usr/bin/env bash
#|---/ /+----------------------------------------+---/ /|#
#|--/ /-| Script to install pkgs from input list |--/ /-|#
#|-/ /--| PhuocTho OcD                           |-/ /--|#
#|/ /---+----------------------------------------+/ /---|#

# Set script directory and source global functions
scrDir=$(dirname "$(realpath "$0")")
source "${scrDir}/global_fn.sh"
if [ $? -ne 0 ]; then
    echo "Error: unable to source global_fn.sh..."
    exit 1
fi

# Disable 'set -e' for this script to handle errors gracefully
set +e

# Parse command line arguments
use_default=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --noconfirm|-y)
            use_default="--noconfirm"
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS] [PACKAGE_LIST_FILE]"
            echo "Options:"
            echo "  --noconfirm, -y        Install packages without confirmation"
            echo "  --help, -h             Show this help message"
            echo ""
            echo "PACKAGE_LIST_FILE defaults to pacman_apps.lst if not specified"
            exit 0
            ;;
        *)
            listPkg="$1"
            shift
            ;;
    esac
done

# Install AUR helper if needed
echo "Setting up yay AUR helper..."
"${scrDir}/install_aur.sh" 2>&1
chk_list "aurhlpr" "${aurList[@]}" || echo "Warning: yay AUR helper not found, AUR packages will be skipped"
# Set default package list file
listPkg="${listPkg:-"${scrDir}/pacman_apps.lst"}"

# Validate package list file
if [[ ! -f "${listPkg}" ]]; then
    echo "Error: Package list file '${listPkg}' not found!"
    exit 1
fi

echo "Installing packages from: ${listPkg}"
echo "Using options: ${use_default:-"(interactive mode)"}"

# Initialize package arrays
archPkg=()
aurhPkg=()
skippedPkg=()
ofs=$IFS
IFS='|'

# Statistics counters
total_packages=0
installed_packages=0
queued_arch_packages=0
queued_aur_packages=0

echo ""
echo "Processing package list..."
echo "========================="

while read -r pkg deps; do
    # Clean package name
    pkg="${pkg// /}"
    
    # Skip empty lines and comments
    if [[ -z "${pkg}" || "${pkg}" =~ ^[[:space:]]*# ]]; then
        continue
    fi
    
    ((total_packages++))
    
    # Check dependencies if specified
    if [[ -n "${deps}" ]]; then
        deps="${deps%"${deps##*[![:space:]]}"}"  # Trim trailing whitespace
        dependency_met=true
        
        while read -r cdep; do
            if [[ -z "${cdep}" ]]; then
                continue
            fi
            
            # Check if dependency is in the package list
            pass=$(cut -d '#' -f 1 "${listPkg}" | awk -F '|' -v chk="${cdep}" '{if($1 == chk) {print 1;exit}}')
            
            if [[ -z "${pass}" ]]; then
                # Check if dependency is already installed
                if ! pkg_installed "${cdep}"; then
                    dependency_met=false
                    break
                fi
            fi
        done < <(echo "${deps}" | xargs -n1)

        if [[ "${dependency_met}" != "true" ]]; then
            echo -e "\033[0;33m[skip]\033[0m ${pkg} - missing dependency: ${deps}"
            skippedPkg+=("${pkg} (missing: ${deps})")
            continue
        fi
    fi

    # Check if package is already installed
    if pkg_installed "${pkg}"; then
        echo -e "\033[0;32m[installed]\033[0m ${pkg} is already installed"
        ((installed_packages++))
    # Check if package is available in official repositories
    elif pkg_available "${pkg}"; then
        repo=$(pacman -Si "${pkg}" 2>/dev/null | awk -F ': ' '/Repository / {print $2}' || echo "official")
        echo -e "\033[0;34m[${repo}]\033[0m queuing ${pkg} from official repository"
        archPkg+=("${pkg}")
        ((queued_arch_packages++))
    # Check if package is available in AUR
    elif [[ -n "${aurhlpr}" ]] && aur_available "${pkg}"; then
        echo -e "\033[0;35m[aur]\033[0m queuing ${pkg} from AUR"
        aurhPkg+=("${pkg}")
        ((queued_aur_packages++))
    else
        echo -e "\033[0;31m[error]\033[0m ${pkg} - package not found in repositories"
        skippedPkg+=("${pkg} (not found)")
    fi
done < <(cut -d '#' -f 1 "${listPkg}")

IFS=${ofs}

# Display summary
echo ""
echo "Installation Summary"
echo "==================="
echo "Total packages processed: ${total_packages}"
echo "Already installed: ${installed_packages}"
echo "Queued for installation from official repos: ${queued_arch_packages}"
echo "Queued for installation from AUR: ${queued_aur_packages}"

if [[ ${#skippedPkg[@]} -gt 0 ]]; then
    echo "Skipped packages: ${#skippedPkg[@]}"
    for skip in "${skippedPkg[@]}"; do
        echo "  - ${skip}"
    done
fi

# Install packages from official repositories
if [[ ${#archPkg[@]} -gt 0 ]]; then
    echo ""
    echo "Installing ${#archPkg[@]} packages from official repositories..."
    echo "Packages: ${archPkg[*]}"
    
    if sudo pacman ${use_default} -S "${archPkg[@]}"; then
        echo -e "\033[0;32m[success]\033[0m Official packages installed successfully"
    else
        echo -e "\033[0;31m[error]\033[0m Failed to install some official packages"
    fi
else
    echo ""
    echo "No packages to install from official repositories."
fi

# Install packages from AUR
if [[ ${#aurhPkg[@]} -gt 0 ]]; then
    if [[ -n "${aurhlpr}" ]]; then
        echo ""
        echo "Installing ${#aurhPkg[@]} packages from AUR using ${aurhlpr}..."
        echo "Packages: ${aurhPkg[*]}"
        
        if "${aurhlpr}" ${use_default} -S "${aurhPkg[@]}"; then
            echo -e "\033[0;32m[success]\033[0m AUR packages installed successfully"
        else
            echo -e "\033[0;31m[error]\033[0m Failed to install some AUR packages"
        fi
    else
        echo ""
        echo -e "\033[0;33m[warning]\033[0m Cannot install AUR packages - no AUR helper available"
        echo "AUR packages that would be installed: ${aurhPkg[*]}"
    fi
else
    echo ""
    echo "No packages to install from AUR."
fi

echo ""
echo "Package installation completed!"