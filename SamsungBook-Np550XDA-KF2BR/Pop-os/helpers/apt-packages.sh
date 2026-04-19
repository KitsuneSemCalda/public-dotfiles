#!/usr/bin/env bash

# This function installs a package using apt. 
# It takes the package name as an argument and checks if it is provided before attempting to install it. 
# If the installation fails, it prints an error message.
install_package() {
    if [ -z "$1" ]; then
        echo "No package name provided."
        return 1
    fi

    sudo apt update
    sudo apt install -y "$1"

    if [ $? -ne 0 ]; then
        echo "Failed to install package: $1"
    fi
}

# This function removes a package using apt.
# It takes the package name as an argument and checks if it is provided before attempting to remove it.
# It also performs an autoremove to clean up any dependencies that are no longer needed.
# If the removal fails, it prints an error message.
remove_package() {
    if [ -z "$1" ]; then
        echo "No package name provided."
        return 1
    fi

    sudo apt remove --purge -y "$1"
    sudo apt autoremove -y
    sudo apt autoclean -y

    if [ $? -ne 0 ]; then
        echo "Failed to remove package: $1"
    fi
}

# This function upgrades the system by updating the package lists and upgrading all installed packages.
# It also performs an autoremove and autoclean to clean up any unnecessary packages and cached files
# If the upgrade process fails, it prints an error message.
upgrade_system() {
    sudo apt update
    sudo apt upgrade -y

    sudo apt autoremove -y
    sudo apt autoclean -y

    if [ $? -ne 0 ]; then
        echo "Failed to upgrade the system."
    fi
}