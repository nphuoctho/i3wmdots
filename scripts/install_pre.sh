#!/usr/bin/env bash
#|---/ /+-------------------------------------+---/ /|#
#|--/ /-| Script to apply pre install configs |--/ /-|#
#|-/ /--| PhuocTho OcD                        |-/ /--|#
#|/ /---+-------------------------------------+/ /---|#

scrDir=$(dirname "$(realpath "$0")")
# shellcheck disable=SC1091
if ! source "${scrDir}/global_fn.sh"; then
    echo "Error: unable to source global_fn.sh..."
    exit 1
fi

flg_DryRun=${flg_DryRun:-0}

# grub
if pkg_installed grub && [ -f /boot/grub/grub.cfg ]; then
    print_log -sec "bootloader" -b "detected :: " "grub..."

    if [ ! -f /etc/default/grub.ocd.bkp ] && [ ! -f /boot/grub/grub.ocd.bkp ]; then
        [ "${flg_DryRun}" -eq 1 ] || sudo cp /etc/default/grub /etc/default/grub.ocd.bkp
        [ "${flg_DryRun}" -eq 1 ] || sudo cp /boot/grub/grub.cfg /boot/grub/grub.ocd.bkp

        print_log -g "[bootloader] " "Select grub theme:" -y "\n[1]" -y " Retroboot (dark)" -y "\n[2]" -y " Pochita (light)"
        read -r -p " :: Press enter to skip grub theme <or> Enter option number : " grubopt
        case ${grubopt} in
        1) grubtheme="Retroboot" ;;
        2) grubtheme="Pochita" ;;
        *) grubtheme="None" ;;
        esac

        if [ "${grubtheme}" == "None" ]; then
            print_log -g "[bootloader] " -b "skip :: " "grub theme selection skipped..."
            echo ""
        else
            print_log -g "[bootloader] " -b "set :: " "grub theme // ${grubtheme}"
            echo ""
            # shellcheck disable=SC2154
            [ "${flg_DryRun}" -eq 1 ] || sudo tar -xzf "${cloneDir}/source/arcs/Grub_${grubtheme}.tar.gz" -C /usr/share/grub/themes/
            [ "${flg_DryRun}" -eq 1 ] || sudo sed -i "/^GRUB_DEFAULT=/c\GRUB_DEFAULT=saved
            /^GRUB_GFXMODE=/c\GRUB_GFXMODE=1280x1024x32,auto
            /^GRUB_THEME=/c\GRUB_THEME=\"/usr/share/grub/themes/${grubtheme}/theme.txt\"
            /^#GRUB_THEME=/c\GRUB_THEME=\"/usr/share/grub/themes/${grubtheme}/theme.txt\"
            /^#GRUB_SAVEDEFAULT=true/c\GRUB_SAVEDEFAULT=true" /etc/default/grub
            [ "${flg_DryRun}" -eq 1 ] || sudo grub-mkconfig -o /boot/grub/grub.cfg
        fi

    else
        print_log -y "[bootloader] " -b "exist :: " "grub is already configured..."
    fi
fi
