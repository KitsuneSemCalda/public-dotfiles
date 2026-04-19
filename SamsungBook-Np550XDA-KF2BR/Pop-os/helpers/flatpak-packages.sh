#!/usr/bin/env bash 

install_flatpak() {
    if [ -z "$1" ]; then
        echo "No package name provided."
        return 1
    fi

    flatpak install -y flathub "$1"

    if [ $? -ne 0 ]; then
        echo "Failed to install package: $1"
    fi
}

remove_flatpak() {
    if [ -z "$1" ]; then
        echo "No package name provided."
        return 1
    fi

    flatpak uninstall -y "$1"

    if [ $? -ne 0 ]; then
        echo "Failed to remove package: $1"
    fi
}

upgrade_flatpak() {
    flatpak update -y

    if [ $? -ne 0 ]; then
        echo "Failed to upgrade flatpak packages."
    fi
}