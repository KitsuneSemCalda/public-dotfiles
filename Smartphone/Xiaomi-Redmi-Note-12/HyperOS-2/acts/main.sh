#!/usr/bin/env bash

set -e 

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$SCRIPT_DIR"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_step() { echo -e "${BLUE}[STEP]${NC} $1"; }

# Check if running as root (some operations need sudo)
if [[ $EUID -eq 0 ]]; then
    log_warn "Running as root. Some sudo commands may fail."
fi

# We have adb installed?
if [[ -n $(command -v adb) ]] ; then 
    log_info "Adb is installed"
else
    log_error "Adb is not installed"
    exit 1
fi

# Is Adb connected?
if [[ -n $(adb devices) ]] ; then 
    log_info "Adb is connected"
else
    log_error "Adb is not connected"
    exit 1
fi

# Cleaning default config
if [[ -f "clean-default-config.sh" ]]; then 
    chmod +x ./clean-default-config.sh
    ./clean-default-config.sh
    log_info "Default config cleaned successfully"
else
    log_warn "clean-default-config.sh not found!"
fi

adb reboot