#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
source "$PROJECT_ROOT/helpers/apt-packages.sh"

APT_PACKAGES_TO_REMOVE=(
    "libreoffice*"
    "firefox"
)

for package in "${APT_PACKAGES_TO_REMOVE[@]}"; do
    echo "Removing package: $package"
    remove_package "$package"
done