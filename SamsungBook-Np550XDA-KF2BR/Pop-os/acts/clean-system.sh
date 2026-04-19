#!/usr/bin/env bash

source "helpers/apt-packages.sh"

APT_PACKAGES_TO_REMOVE=(
    "libreoffice*"
    "firefox"
)

for package in "${APT_PACKAGES_TO_REMOVE[@]}"; do
    echo "Removing package: $package"
    remove_package "$package"
done