#!/bin/bash

# TODO check if comic code ligatures is installed, if not download and install it
# need to add it as an api request somewhere ...

check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo "Error: $1 is not installed or not in PATH" >&2
        exit 1
    fi
}

check_command yay

aur_pkgs=(
    "webcord"
    "tofi"
    "font-manager"
    "plexamp-appimage"
    "hyprshot" # https://github.com/Gustash/Hyprshot
    "clipman" # https://wiki.hyprland.org/Useful-Utilities/Clipboard-Managers/
)

arch_pkgs=(
    "xdg-desktop-portal-hyprland"
    "ttf-font-awesome"
    "ripgrep"
    "stow"
    "ghostty"
    "neovim"
    "neofetch"
    "pavucontrol"
    "bluez"
    "fish"
    "eza"
    "zoxide"
    "linux-headers"
    "dkms"
    "zk"
    "xclip"
    "jq"
    "texlive"
    "zathura"
    "nwg-displays"
    "bluez"

    # GUI apps
    "firefox"
    "steam" # enable multilib in /etc/pacman.conf
    "lutris"
    "obsidian"
    "okular"

    # hyprland stuff
    "hyprpaper"
    "waybar"
)


for pkg in "${aur_pkgs[@]}"; do
    yay -S "$pkg" --noconfirm --needed
done

for pkg in "${arch_pkgs[@]}"; do
    sudo pacman -S "$pkg" --noconfirm --needed
done

