#!/usr/bin/env bash

# para ejecutarlo directamente desde la terminal
# sh -c "$(curl -s https://raw.githubusercontent.com/FQ211776/dot/master/run_onchange_install-packages.sh)"

#  ██████╗ ██╗ ██████╗███████╗    ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗
#  ██╔══██╗██║██╔════╝██╔════╝    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗
#  ██████╔╝██║██║     █████╗      ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝
#  ██╔══██╗██║██║     ██╔══╝      ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗
#  ██║  ██║██║╚██████╗███████╗    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║
#  ╚═╝  ╚═╝╚═╝ ╚═════╝╚══════╝    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝
#   Script to install my dotfiles
#   Author: z0mbi3
#   url: https://github.com/gh0stzk

clear

CRE=$(tput setaf 1)
CYE=$(tput setaf 3)
CGR=$(tput setaf 2)
CBL=$(tput setaf 4)
BLD=$(tput bold)
CNC=$(tput sgr0)

backup_folder=~/.RiceBackup
date=$(date +%Y%m%d-%H%M%S)

logo() {

    local text="${1:?}"
    echo -en "
	               %%%
	        %%%%%//%%%%%
	      %%************%%%
	  (%%//############*****%%
	%%%%%**###&&&&&&&&&###**//
	%%(**##&&&#########&&&##**
	%%(**##*****#####*****##**%%%
	%%(**##     *****     ##**
	   //##   @@**   @@   ##//
	     ##     **###     ##
	     #######     #####//
	       ###**&&&&&**###
	       &&&         &&&
	       &&&////   &&
	          &&//@@@**
	            ..***
    z0mbi3 Dotfiles\n\n"
    printf ' %s [%s%s %s%s %s]%s\n\n' "${CRE}" "${CNC}" "${CYE}" "${text}" "${CNC}" "${CRE}" "${CNC}"
}

# Function to check and install gum if not present
check_gum() {
    command -v gum >/dev/null 2>&1 || {
        echo >&2 "Gum is not installed. Installing..."
        sudo pacman -S --noconfirm gum
    }
}

# Function to check and install dialog if not present
check_dialog() {
    command -v dialog >/dev/null 2>&1 || {
        echo >&2 "Dialog is not installed. Installing..."
        sudo pacman -S --noconfirm dialog
    }
}

# Function to display the menu
display_menu() {
    clear
    gum style --foreground 212 --border double --padding "1 1" --margin "1 1" --align center "Initial System Setup"
    echo
    gum style --foreground 142 "Hello $USER, please select an option. Press 'i' for the Wiki."
    echo
    gum style --foreground 35 "1. Instalar paquetes adicionales no incluidos en los dotfiles originales."
    gum style --foreground 35 "2. Instalar paquetes adicionales desde aur no incluidos en los dotfiles originales."
    gum style --foreground 35 "3. Clonar o actualizar copia local de los dotfiles originales."
    gum style --foreground 35 "4. Instalar los dotfiles originales."
    gum style --foreground 35 "5. configurar ZSH."
    gum style --foreground 35 "5. configurar Fish."
    echo
    gum style --foreground 33 "Type your selection or 'q' to return to main menu."
}

########## ---------- You must not run this as root ---------- ##########

if [ "$(id -u)" = 0 ]; then
    echo "This script MUST NOT be run as root user."
    exit 1
fi

home_dir=$HOME
current_dir=$(pwd)

if [ "$current_dir" != "$home_dir" ]; then
    printf "%s%sThe script must be executed from the HOME directory.%s\n" "${BLD}" "${CYE}" "${CNC}"
    exit 1
fi

########## ---------- Welcome ---------- ##########

logo "Welcome!"
printf '%s%sThis script will check if you have the necessary dependencies, and if not, it will install them. Then, it will clone my repository in your HOME directory.\nAfter that, it will create a backup of your files, and then copy the new files to your computer.\n\nMy dotfiles DO NOT modify any of your system configurations.\nYou will be prompted for your root password to install missing dependencies and/or to switch to zsh shell if its not your default.\n\nThis script doesnt have the potential power to break your system, it only copies files from my repository to your HOME directory.%s\n\n' "${BLD}" "${CRE}" "${CNC}"

while true; do
    read -rp " Do you wish to continue? [y/N]: " yn
    case $yn in
    [Yy]*) break ;;
    [Nn]*) exit ;;
    *) printf " Error: just write 'y' or 'n'\n\n" ;;
    esac
done
clear

Instalar_paquetes_adicionales() {
    ########## ---------- Install packages ---------- ##########

    logo "Installing needed packages.."

    dependencias=(alacritty base-devel brightnessctl bspwm dunst feh firefox geany git kitty imagemagick jq
        jgmenu libwebp lsd maim mpc mpd neovim ncmpcpp npm pamixer pacman-contrib
        papirus-icon-theme physlock picom playerctl polybar polkit-gnome python-gobject ranger
        redshift rofi rustup sxhkd tmux ttf-inconsolata ttf-jetbrains-mono ttf-jetbrains-mono-nerd
        ttf-joypixels ttf-terminus-nerd ueberzug webp-pixbuf-loader xclip xdg-user-dirs
        xdo xdotool xorg-xdpyinfo xorg-xkill xorg-xprop xorg-xrandr xorg-xsetroot
        xorg-xwininfo zsh zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting
        yt-dlp bat bat-extras tldr
        diff-so-fancy geany hub github-cli peco wget eza
        zsh fish grml-zsh-config wget xorg-xfd curl
        wezterm ttf-nerd-fonts-symbols-mono python-nautilus noto-fonts-emoji xsel micro lazygit ark fzf atuin fd starship)
    is_installed() {
        pacman -Q "$1" &>/dev/null
    }
    # atuin necesita configuracion manual
    printf "%s%sChecking for required packages...%s\n" "${BLD}" "${CBL}" "${CNC}"
    for paquete in "${dependencias[@]}"; do
        if ! is_installed "$paquete"; then
            if sudo pacman -S "$paquete" --noconfirm >/dev/null 2>>RiceError.log; then
                printf "%s%s%s %shas been installed succesfully.%s\n" "${BLD}" "${CYE}" "$paquete" "${CBL}" "${CNC}"
                sleep 1
            else
                printf "%s%s%s %shas not been installed correctly. See %sRiceError.log %sfor more details.%s\n" "${BLD}" "${CYE}" "$paquete" "${CRE}" "${CBL}" "${CRE}" "${CNC}"
                sleep 1
            fi
        else
            printf '%s%s%s %sis already installed on your system!%s\n' "${BLD}" "${CYE}" "$paquete" "${CGR}" "${CNC}"
            sleep 1
        fi
    done
}

Instalar_repositorio() {
    ########## ---------- Preparing Folders ---------- ##########

    # Verifies if the archive user-dirs.dirs doesn't exist in ~/.config
    if [ ! -e "$HOME/.config/user-dirs.dirs" ]; then
        xdg-user-dirs-update
    fi

    ########## ---------- Cloning the Rice! ---------- ##########

    logo "Downloading dotfiles"

    # repo_url="https://github.com/gh0stzk/dotfiles"
    # repo_dir="$HOME/dotfiles"
    repo_dir="$HOME/Developments/github.com/gh0stzk"

    # Crear carpeta de respaldo si no existe
    mkdir -p "$repo_dir"

    download_repo() {
        repo="https://github.com/${1}/${2}"
        folder="${repo_dir}/${2}"
        if [ ! -d $folder ]; then

            printf 'Downloading dotfiles from %s%s %s into %s%s\n' "${BLD}${CYE}" "${repo}" "${CNC}" "${CGR}" "${folder}"
            printf '%s\n' "${CNC}"

            git clone --depth 1 ${repo} ${folder}
            sleep 15
        else
            printf 'Updating dotfiles from %s%s %s in %s%s\n' "${BLD}${CYE}" "${repo}" "${CNC}" "${CGR}" "${folder}"
            printf '%s\n' "${CNC}"

            git -C "${folder}" pull --rebase
            sleep 60
        fi
    }

    download_repo "gh0stzk" "dotfiles"

    # # Verifies if the folder of the repository exists, and if it does, deletes it
    # if [ -d "$repo_dir" ]; then
    #     printf "Removing existing dotfiles repository\n"
    #     rm -rf "$repo_dir"
    # fi

    # # Clone the repository
    # printf "Cloning dotfiles from %s\n" "$repo_url"
    # git clone "$repo_url" "$repo_dir"
    # sleep 2
    # clear
}

Instalar_dotfiles() {

    ########## ---------- Backup files ---------- ##########

    logo "Backup files"

    repo_dir="$HOME/Developments/github.com/gh0stzk/dotfiles"

    printf "If you already have a powerful and super Pro NEOVIM configuration, write 'n' in the next question. If you answer 'y' your neovim configuration will be moved to the backup directory.\n\n"

    while true; do
        read -rp "Do you want to try my nvim config? (y/n): " try_nvim
        if [[ "$try_nvim" == "y" || "$try_nvim" == "n" ]]; then
            break
        else
            echo "Invalid input. Please enter 'y' or 'n'."
        fi
    done

    printf "\nBackup files will be stored in %s%s%s/.RiceBackup%s \n\n" "${BLD}" "${CRE}" "$HOME" "${CNC}"
    sleep 3

    [ ! -d "$backup_folder" ] && mkdir -p "$backup_folder"

    for folder in bspwm alacritty picom rofi eww sxhkd dunst kitty polybar ncmpcpp ranger tmux zsh mpd paru; do
        if [ -d "$HOME/.config/$folder" ]; then
            if mv "$HOME/.config/$folder" "$backup_folder/${folder}_$date" 2>>RiceError.log; then
                printf "%s%s%s folder backed up successfully at %s%s/%s_%s%s\n" "${BLD}" "${CGR}" "$folder" "${CBL}" "$backup_folder" "$folder" "$date" "${CNC}"
                sleep 1
            else
                printf "%s%sFailed to backup %s folder. See %sRiceError.log%s\n" "${BLD}" "${CRE}" "$folder" "${CBL}" "${CNC}"
                sleep 1
            fi
        else
            printf "%s%s%s folder does not exist, %sno backup needed%s\n" "${BLD}" "${CGR}" "$folder" "${CYE}" "${CNC}"
            sleep 1
        fi
    done

    if [[ $try_nvim == "y" ]]; then
        # Backup nvim
        if [ -d "$HOME/.config/nvim" ]; then
            if mv "$HOME/.config/nvim" "$backup_folder/nvim_$date" 2>>RiceError.log; then
                printf "%s%snvim folder backed up successfully at %s%s/nvim_%s%s\n" "${BLD}" "${CGR}" "${CBL}" "$backup_folder" "$date" "${CNC}"
                sleep 1
            else
                printf "%s%sFailed to backup nvim folder. See %sRiceError.log%s\n" "${BLD}" "${CRE}" "${CBL}" "${CNC}"
                sleep 1
            fi
        else
            printf "%s%snvim folder does not exist, %sno backup needed%s\n" "${BLD}" "${CGR}" "${CYE}" "${CNC}"
            sleep 1
        fi
    fi

    for folder in "$HOME"/.mozilla/firefox/*.default-release/chrome; do
        if [ -d "$folder" ]; then
            if mv "$folder" "$backup_folder"/chrome_"$date" 2>>RiceError.log; then
                printf "%s%sChrome folder backed up successfully at %s%s/chrome_%s%s\n" "${BLD}" "${CGR}" "${CBL}" "$backup_folder" "${date}" "${CNC}"
            else
                printf "%s%sFailed to backup Chrome folder. See %sRiceError.log%s\n" "${BLD}" "${CRE}" "${CBL}" "${CNC}"
            fi
        else
            printf "%s%sThe folder Chrome does not exist, %sno backup needed%s\n" "${BLD}" "${CGR}" "${CYE}" "${CNC}"
        fi
    done

    for file in "$HOME"/.mozilla/firefox/*.default-release/user.js; do
        if [ -f "$file" ]; then
            if mv "$file" "$backup_folder"/user.js_"$date" 2>>RiceError.log; then
                printf "%s%suser.js file backed up successfully at %s%s/user.js_%s%s\n" "${BLD}" "${CGR}" "${CBL}" "$backup_folder" "${date}" "${CNC}"
            else
                printf "%s%sFailed to backup user.js file. See %sRiceError.log%s\n" "${BLD}" "${CRE}" "${CBL}" "${CNC}"
            fi
        else
            printf "%s%sThe file user.js does not exist, %sno backup needed%s\n" "${BLD}" "${CGR}" "${CYE}" "${CNC}"
        fi
    done

    printf "%s%sDone!!%s\n\n" "${BLD}" "${CGR}" "${CNC}"
    sleep 5

    ########## ---------- Copy the Rice! ---------- ##########

    logo "Installing dotfiles.."
    printf "Copying files to respective directories..\n"

    [ ! -d ~/.config ] && mkdir -p ~/.config
    [ ! -d ~/.local/bin ] && mkdir -p ~/.local/bin
    [ ! -d ~/.local/share ] && mkdir -p ~/.local/share
    #  echo $folder
    #  rm -rfv $folder/config/mpd
    #  rm -rfv $folder/config/ncmpcpp
    for dirs in $repo_dir/config/*; do
        dir_name=$(basename "$dirs")
        # If the directory is nvim and the user doesn't want to try it, skip this loop
        if [[ $dir_name == "nvim" && $try_nvim != "y" ]]; then
            continue
        fi
        if cp -R "${dirs}" ~/.config/ 2>>RiceError.log; then
            printf "%s%s%s %sconfiguration installed succesfully%s\n" "${BLD}" "${CYE}" "${dir_name}" "${CGR}" "${CNC}"
            sleep 1
        else
            printf "%s%s%s %sconfiguration failed to been installed, see %sRiceError.log %sfor more details.%s\n" "${BLD}" "${CYE}" "${dir_name}" "${CRE}" "${CBL}" "${CRE}" "${CNC}"
            sleep 1
        fi
    done

    for folder in applications asciiart fonts startup-page; do
        if cp -R $repo_dir/misc/$folder ~/.local/share/ 2>>RiceError.log; then
            printf "%s%s%s %sfolder copied succesfully!%s\n" "${BLD}" "${CYE}" "$folder" "${CGR}" "${CNC}"
            sleep 15
        else
            printf "%s%s%s %sfolder failed to been copied, see %sRiceError.log %sfor more details.%s\n" "${BLD}" "${CYE}" "$folder" "${CRE}" "${CBL}" "${CRE}" "${CNC}"
            sleep 15
        fi
    done

    if cp -R $repo_dir/misc/bin ~/.local/ 2>>RiceError.log; then
        printf "%s%sbin %sfolder copied succesfully!%s\n" "${BLD}" "${CYE}" "${CGR}" "${CNC}"
        sleep 15
    else
        printf "%s%sbin %sfolder failed to been copied, see %sRiceError.log %sfor more details.%s\n" "${BLD}" "${CYE}" "${CRE}" "${CBL}" "${CRE}" "${CNC}"
        sleep 15
    fi

    if cp -R $repo_dir/misc/firefox/* ~/.mozilla/firefox/*.default-release/ 2>>RiceError.log; then
        printf "%s%sFirefox theme %scopied succesfully!%s\n" "${BLD}" "${CYE}" "${CGR}" "${CNC}"
        sleep 15
    else
        printf "%s%sFirefox theme %sfailed to been copied, see %sRiceError.log %sfor more details.%s\n" "${BLD}" "${CYE}" "${CRE}" "${CBL}" "${CRE}" "${CNC}"
        sleep 15
    fi

    sed -i "s/user_pref(\"browser.startup.homepage\", \"file:\/\/\/home\/z0mbi3\/.local\/share\/startup-page\/index.html\")/user_pref(\"browser.startup.homepage\", \"file:\/\/\/home\/$USER\/.local\/share\/startup-page\/index.html\")/" "$HOME"/.mozilla/firefox/*.default-release/user.js
    sed -i "s/name: 'gh0stzk'/name: '$USER'/" "$HOME"/.local/share/startup-page/config.js

    fc-cache -rv >/dev/null 2>&1

    printf "\n\n%s%sFiles copied succesfully!!%s\n" "${BLD}" "${CGR}" "${CNC}"
    sleep 60

}

desde_aur() {
    ########## ---------- Installing Paru & others ---------- ##########

    logo "installing Paru, Eww, tdrop & xqp"

    # Installing Paru
    if command -v paru >/dev/null 2>&1; then
        printf '%s%s%s %sis already installed on your system from AUR!%s\n' "${BLD}" "${CYE}" "paru" "${CGR}" "${CNC}"
    else
        printf "%s%sInstalling paru%s\n" "${BLD}" "${CBL}" "${CNC}"
        {
            cd "$HOME" || exit
            git clone https://aur.archlinux.org/paru-bin.git
            cd paru-bin || exit
            makepkg -si --noconfirm
        } || {
            printf "\n%s%sFailed to install Paru. You may need to install it manually%s\n" "${BLD}" "${CRE}" "${CNC}"
        }
    fi

    # Installing tdrop for scratchpads
    if command -v tdrop >/dev/null 2>&1; then
        printf '%s%s%s %sis already installed on your system from AUR!%s\n' "${BLD}" "${CYE}" "tdrope" "${CGR}" "${CNC}"
    else
        printf "%s%sInstalling tdrop, this should be fast!%s\n" "${BLD}" "${CBL}" "${CNC}"
        paru -S tdrop-git --skipreview --noconfirm
    fi

    # Installing xqp
    if command -v xqp >/dev/null 2>&1; then
        printf '%s%s%s %sis already installed on your system from AUR!%s\n' "${BLD}" "${CYE}" "xqp" "${CGR}" "${CNC}"
    else
        printf "%s%sInstalling xqp, this should be fast!%s\n" "${BLD}" "${CBL}" "${CNC}"
        paru -S xqp --skipreview --noconfirm
    fi

    # Installing Eww
    if command -v eww >/dev/null 2>&1; then
        printf '%s%s%s %sis already installed on your system from AUR!%s\n' "${BLD}" "${CYE}" "eww" "${CGR}" "${CNC}"
    else
        printf "%s%sInstalling Eww, this could take 10 mins or more.%s\n" "${BLD}" "${CBL}" "${CNC}"
        {
            sudo pacman -S rustup --noconfirm
            cd "$HOME" || exit
            git clone https://github.com/elkowar/eww
            cd eww || exit
            cargo build --release --no-default-features --features x11
            sudo install -m 755 "$HOME/eww/target/release/eww" -t /usr/bin/
            cd "$HOME" || exit
            rm -rf {paru-bin,.cargo,.rustup,eww}
        } || {
            printf "\n%s%sFailed to install Eww. You may need to install it manually%s\n" "${BLD}" "${CRE}" "${CNC}"
        }
    fi

    aur_dependencias=(ttf-meslo-nerd zoxide-git flutter gitkraken ttf-unifont noto-color-emoji-fontconfig xorg-fonts-misc ttf-dejavu ttf-meslo-nerd-font-powerlevel10k noto-fonts-emoji powerline-fonts microsoft-edge-stable-bin microsoft-edge-beta-bin bcompare brew ghq mise git-delta ydiff ghq nodejs-commitizen topgrade visual-studio-code-insiders-bin mise) 
    #siji-ng localsend

    # Función para verificar si un paquete está instalado en AUR
    is_installed_aur() {
        pacman -Qi "$1" &>/dev/null
    }

    # Instalación de paquetes AUR (optimizado)
    for paquete in "${aur_dependencias[@]}"; do
        if is_installed_aur "$paquete"; then # No invertimos la condición con '!'
            printf '%s%s%s %sya está instalado desde AUR!%s\n' "${BLD}" "${CYE}" "$paquete" "${CGR}" "${CNC}"
        else
            printf '%s%s%s %sinstalando desde AUR...%s\n' "${BLD}" "${CYE}" "$paquete" "${CBL}" "${CNC}"
            paru -S "$paquete" --skipreview

            if paru -Q "$paquete" &>/dev/null; then # Verificamos si la instalación fue exitosa
                printf '%s%s%s %sse instaló correctamente desde AUR!%s\n' "${BLD}" "${CYE}" "$paquete" "${CGR}" "${CNC}"
            else
                printf '%s%s%s %sno se pudo instalar. Instálalo manualmente.%s\n' "${BLD}" "${CRE}" "$paquete" "${CNC}"
            fi
        fi
        sleep 1 # Pausa opcional
    done

}

########## --------- Changing shell to zsh ---------- ##########

zsh_() {
    clear

    # Variables
    backup_folder="$HOME/.RiceBackup"
    folder=".oh-my-zsh"
    backup_path="$backup_folder/${folder}_$date"

    # Crear carpeta de respaldo si no existe
    mkdir -p "$backup_folder"

    gum style --foreground 35 "Setting up ZSH with p10k & OMZ Plugins..."
    sleep 2
    echo

    if [ -f ~/.zshrc ]; then
        if mv ~/.zshrc "$backup_folder"/.zshrc_"$date" 2>>RiceError.log; then
            printf "%s%s.zshrc file backed up successfully at %s%s/.zshrc_%s%s\n" "${BLD}" "${CGR}" "${CBL}" "$backup_folder" "${date}" "${CNC}"
        else
            printf "%s%sFailed to backup .zshrc file. See %sRiceError.log%s\n" "${BLD}" "${CRE}" "${CBL}" "${CNC}"
        fi
    else
        printf "%s%sThe file .zshrc does not exist, %sno backup needed%s\n" "${BLD}" "${CGR}" "${CYE}" "${CNC}"
    fi

    # Verificar si la carpeta .oh-my-zsh existe
    if [ -d "$HOME/$folder" ]; then
        # Mover la carpeta a la carpeta de respaldo
        if mv "$HOME/$folder" "$backup_path" 2>>RiceError.log; then
            printf "%s%s%s folder backed up successfully at %s%s%s%s\n" "${BLD}" "${CGR}" "$folder" "${CBL}" "$backup_path" "${CNC}"
        else
            printf "%s%sFailed to backup %s folder. See %sRiceError.log%s\n" "${BLD}" "${CRE}" "$folder" "${CBL}" "${CNC}"
        fi
    else
        # Mensaje si la carpeta no existe
        printf "%s%s%s folder does not exist, %sno backup needed%s\n" "${BLD}" "${CGR}" "$folder" "${CYE}" "${CNC}"
    fi

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    cd $HOME/ && wget https://raw.githubusercontent.com/xerolinux/xero-fixes/main/conf/.p10k.zsh
    gum style --foreground 35 "ZSH setup complete! Log out and back in."

    logo "Changing default shell to zsh"

    if [[ $SHELL != "/usr/bin/zsh" ]]; then
        printf "\n%s%sChanging your shell to zsh. Your root password is needed.%s\n\n" "${BLD}" "${CYE}" "${CNC}"
        # Cambia la shell a zsh
        chsh -s /usr/bin/zsh
        printf "%s%sShell changed to zsh. Please reboot.%s\n\n" "${BLD}" "${CGR}" "${CNC}"
    else
        printf "%s%sYour shell is already zsh\nGood bye! installation finished, now reboot%s\n" "${BLD}" "${CGR}" "${CNC}"
    fi
    atuin import auto
    sleep 3

}

fish_() {
    sleep 3

    # Cambia el shell por defecto a fish
    chsh -s /usr/bin/fish
    rm -rf ~/.local/share/omf
    # Descarga e instala oh-my-fish
    curl -L https://get.oh-my.fish | fish

    # Instala el tema bobthefish usando oh-my-fish
    fish -c "omf install bobthefish"
    omf install bobthefish
    set -g theme_nerd_fonts yes

    echo "Fish, Oh-My-Fish y el tema bobthefish se han instalado correctamente."
    echo "Por favor, cierra y vuelve a abrir tu terminal o inicia una nueva sesión p"
    atuin import auto
}

main() {
    check_gum
    check_dialog
    while :; do
        display_menu
        read -rp "Enter your choice: " CHOICE
        echo

        case $CHOICE in
        1) Instalar_paquetes_adicionales ;;
        2) desde_aur ;;
        3) Instalar_repositorio ;;
        4) Instalar_dotfiles ;;
        5) zsh_ ;;
        6) fish_ ;;
        q) clear && exit ;;
        *)
            gum style --foreground 50 "Invalid choice. Please select a valid option."
            echo
            ;;
        esac
        sleep 1
    done
}

main

# https://github.com/ymattw/ydiff
# https://github.com/commitizen/cz-cli
