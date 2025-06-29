#!/usr/bin/env bash
# shellcheck disable=SC2154
#|---/ /+--------------------------+---/ /|#
#|--/ /-| Script cài đặt chính     |--/ /-|#
#|-/ /--| PhuocTho OcD             |-/ /--|#
#|/ /---+--------------------------+/ /---|#

cat <<"EOF"

-------------------------------------------------
        .
       / \         ___   ___  ___
      /^  \       / _ \ / __||   \
     /  _  \     | (_) | (__ | |) |
    /  | | ~\     \___/ \___||___/
   /.-'   '-.\    i3wm dotfiles

-------------------------------------------------

EOF

#--------------------------------#
# Import biến và hàm dùng chung  #
#--------------------------------#
scrDir="$(dirname "$(realpath "$0")")"
# shellcheck disable=SC1091
if ! source "${scrDir}/global_fn.sh"; then
    echo "Lỗi: không thể import global_fn.sh..."
    exit 1
fi

#------------------#
# Xử lý tuỳ chọn   #
#------------------#
flg_Install=0
flg_Restore=0
flg_Service=0
flg_DryRun=0
flg_Shell=0
flg_ThemeInstall=1

while getopts idrstmh: RunStep; do
    case $RunStep in
    i) flg_Install=1 ;; # Cài đặt i3wm không kèm config
    d)
        flg_Install=1
        export use_default="--noconfirm" # Cài đặt mặc định không hỏi xác nhận
        ;;
    r) flg_Restore=1 ;; # Khôi phục file cấu hình
    s) flg_Service=1 ;; # Bật các dịch vụ hệ thống
    h)
        export flg_Shell=0
        print_log -r "[shell] " -b "Reevaluate :: " "shell options"
        ;;
    t) flg_DryRun=1 ;; # Chạy thử, không thực thi thật
    m) flg_ThemeInstall=0 ;; # Không cài lại theme
    *)
        cat <<EOF
Usage: $0 [options]
            i : [i]nstall i3wm without configs
            d : install i3wm [d]efaults without configs --noconfirm
            r : [r]estore config files
            s : enable system [s]ervices
            h : re-evaluate S[h]ell
            m : no the[m]e reinstallations
            t : [t]est run without executing (-irst to dry run all)

NOTE: 
        running without args is equivalent to -irs

EOF
        exit 1
        ;;
    esac
done

# Chỉ export các biến dùng ngoài script này
OCD_LOG="$(date +'%y%m%d_%Hh%Mm%Ss')"
export flg_DryRun flg_Shell flg_Install flg_ThemeInstall OCD_LOG

# Tạo thư mục log nếu chưa tồn tại
cacheDir="${HOME}/.cache/dotfiles"
mkdir -p "${cacheDir}/logs/${OCD_LOG}" || {
    print_log -sec "log" -crit "Không thể tạo thư mục log: ${cacheDir}/logs/${OCD_LOG}"
    exit 1
}

if [ "${flg_DryRun}" -eq 1 ]; then
    print_log -n "[test-run] " -b "enabled :: " "Testing without executing"
elif [ $OPTIND -eq 1 ]; then
    flg_Install=1
    flg_Restore=1
    flg_Service=1
fi

#---------------------#
# Script tiền cài đặt #
#---------------------#
if [ ${flg_Install} -eq 1 ] && [ ${flg_Restore} -eq 1 ]; then
    cat <<"EOF"
                _         _       _ _
 ___ ___ ___   |_|___ ___| |_ ___| | |
| . |  _| -_|  | |   |_ -|  _| .'| | |
|  _|_| |___|  |_|_|_|___|_| |__,|_|_|
|_|

EOF

    "${scrDir}/install_pre.sh" || {
        print_log -sec "pre-install" -crit "Script tiền cài đặt thất bại"
        exit 1
    }
fi

#------------#
# Cài đặt    #
#------------#
if [ ${flg_Install} -eq 1 ]; then
    cat <<"EOF"

 _         _       _ _ _
|_|___ ___| |_ ___| | |_|___ ___
| |   |_ -|  _| .'| | | |   | . |
|_|_|_|___|_| |__,|_|_|_|_|_|_  |
                            |___|

EOF

    #------------------------#
    # Chuẩn bị danh sách gói #
    #------------------------#
    shift $((OPTIND - 1))
    custom_pkg=$1
    cp "${scrDir}/pacman_apps.lst" "${scrDir}/install_pkg.lst" || {
        print_log -sec "pkg" -crit "Không thể sao chép pacman_apps.lst"
        exit 1
    }
    trap 'mv "${scrDir}/install_pkg.lst" "${cacheDir}/logs/${OCD_LOG}/install_pkg.lst" 2>/dev/null' EXIT

    echo -e "\n#user packages" >>"${scrDir}/install_pkg.lst" # Thêm đánh dấu cho gói người dùng
    if [ -f "${custom_pkg}" ] && [ -n "${custom_pkg}" ]; then
        cat "${custom_pkg}" >>"${scrDir}/install_pkg.lst" || {
            print_log -sec "pkg" -crit "Không thể thêm gói người dùng từ ${custom_pkg}"
            exit 1
        }
    fi

    #----------------------#
    # Lựa chọn AUR & shell #
    #----------------------#
    echo ""
    if ! chk_list "aurhlpr" "${aurList[@]}"; then
        print_log -c "\nAUR Helpers :: "
        aurList+=("yay-bin") # Chỉ còn yay-bin
        for i in "${!aurList[@]}"; do
            print_log -sec "$((i + 1))" " ${aurList[$i]} "
        done

        prompt_timer 120 "Enter option number [default: yay-bin] | q to quit "

        case "${PROMPT_INPUT}" in
        1) export getAur="yay" ;;
        2) export getAur="yay-bin" ;;
        q)
            print_log -sec "AUR" -crit "Quit" "Exiting..."
            exit 1
            ;;
        *)
            print_log -sec "AUR" -warn "Defaulting to yay-bin"
            print_log -sec "AUR" -stat "default" "yay-bin"
            export getAur="yay-bin"
            ;;
        esac
        if [[ -z "$getAur" ]]; then
            print_log -sec "AUR" -crit "No AUR helper found..." "Log file at ${cacheDir}/logs/${OCD_LOG}"
            exit 1
        fi
    fi

    if ! chk_list "myShell" "${shlList[@]}"; then
        print_log -c "Shell :: "
        for i in "${!shlList[@]}"; do
            print_log -sec "$((i + 1))" " ${shlList[$i]} "
        done
        prompt_timer 120 "Enter option number [default: zsh] | q to quit "

        case "${PROMPT_INPUT}" in
        1) export myShell="zsh" ;;
        2) export myShell="fish" ;;
        q)
            print_log -sec "shell" -crit "Quit" "Exiting..."
            exit 1
            ;;
        *)
            print_log -sec "shell" -warn "Defaulting to zsh"
            export myShell="zsh"
            ;;
        esac
        print_log -sec "shell" -stat "Added as shell" "${myShell}"
        echo "${myShell}" >>"${scrDir}/install_pkg.lst"

        if [[ -z "$myShell" ]]; then
            print_log -sec "shell" -crit "No shell found..." "Log file at ${cacheDir}/logs/${OCD_LOG}"
            exit 1
        else
            print_log -sec "shell" -stat "detected :: " "${myShell}"
        fi
    fi

    if ! grep -q "^#user packages" "${scrDir}/install_pkg.lst"; then
        print_log -sec "pkg" -crit "No user packages found..." "Log file at ${cacheDir}/logs/${OCD_LOG}/install.sh"
        exit 1
    fi

    #-------------------------------#
    # Cài đặt các gói từ danh sách  #
    #-------------------------------#
    sudo "${scrDir}/install_pkg.sh" "${scrDir}/install_pkg.lst" || {
        print_log -sec "install" -crit "Cài đặt gói thất bại"
        exit 1
    }
fi

#----------------------------#
# Khôi phục cấu hình cá nhân #
#----------------------------#
if [ ${flg_Restore} -eq 1 ]; then
    cat <<"EOF"

             _           _
 ___ ___ ___| |_ ___ ___|_|___ ___
|  _| -_|_ -|  _| . |  _| |   | . |
|_| |___|___|_| |___|_| |_|_|_|_  |
                              |___|

EOF

    # Skip font and icon installation - removed by user request
    print_log -sec "restore" -stat "Skipping font and icon installation"

    if [ "${flg_DryRun}" -ne 1 ] && pgrep -x "i3" >/dev/null; then
        i3-msg reload >/dev/null 2>&1 || true
        print_log -sec "install" -stat "reload :: i3wm"
    fi

    if [ "${flg_DryRun}" -ne 1 ]; then
        export PATH="$HOME/.local/lib/ocd:${PATH}"
        print_log -sec "install" -stat "reload :: i3wm"
    fi
fi

#------------------------#
# Bật các dịch vụ hệ thống #
#------------------------#
if [ ${flg_Service} -eq 1 ]; then
    cat <<"EOF"

                 _
 ___ ___ ___ _ _|_|___ ___ ___
|_ -| -_|  _| | | |  _| -_|_ -|
|___|___|_|  \_/|_|___|___|___|

EOF

    # Đảm bảo restore_svc.sh có quyền thực thi
    if [ ! -x "${scrDir}/restore_svc.sh" ]; then
        sudo chmod +x "${scrDir}/restore_svc.sh" || {
            print_log -sec "service" -crit "Không thể cấp quyền thực thi cho ${scrDir}/restore_svc.sh"
            exit 1
        }
    fi

    sudo "${scrDir}/restore_svc.sh" || {
        print_log -sec "service" -crit "Bật dịch vụ hệ thống thất bại"
        exit 1
    }
fi

if [ $flg_Install -eq 1 ]; then
    echo ""
    print_log -g "Installation" " :: " "COMPLETED!"
fi
print_log -b "Log" " :: " -y "View logs at ${cacheDir}/logs/${OCD_LOG}"
if { [ $flg_Install -eq 1 ] || [ $flg_Restore -eq 1 ] || [ $flg_Service -eq 1 ]; } && [ $flg_DryRun -ne 1 ]; then
    print_log -stat "OCD" "Không nên sử dụng hệ thống vừa cài đặt hoặc nâng cấp OCD mà không khởi động lại. Bạn có muốn khởi động lại không? (y/N)"
    read -r answer

    if [[ "$answer" == [Yy] ]]; then
        echo "Đang khởi động lại hệ thống"
        sudo systemctl reboot
    else
        echo "Hệ thống sẽ không khởi động lại"
    fi
fi