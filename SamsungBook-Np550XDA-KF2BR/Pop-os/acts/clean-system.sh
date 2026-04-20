#!/usr/bin/env bash

# =============================================================================
# System Cleanup for Samsung 550XDA-KF2BR
# Hardware: Intel i5-1135G7 (TigerLake) + 8GB RAM + Iris Xe
# Optimized for: Gaming, Content Creation, Virtualization
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
source "$PROJECT_ROOT/helpers/apt-packages.sh"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[CLEAN]${NC} $1"; }

# =============================================================================
# Bloatware to Remove
# =============================================================================

BLOATWARE=(
    "libreoffice*"
    "firefox"                    # Will be replaced by Edge/Flatpak Firefox
    "thunderbird*"
    "simple-scan"
    "cheese"                     # Camera app (rarely used)
    "gnome-screenshot"           # Use screenshot key instead
    "gnome-calendar"             # Use calendar app instead
    "gnome-contacts"
    "gnome-maps"
    "gnome-weather"
    "totem"                      # Use VLC/mpv instead
    "rhythmbox"                  # Use Spotify
    "shotwell"                   # Use GIMP/darktable
)

log_info "Removing bloatware..."
for package in "${BLOATWARE[@]}"; do
    remove_package "$package" 2>/dev/null || true
done

# =============================================================================
# Clean APT Cache
# =============================================================================

log_info "Cleaning APT cache..."
sudo apt-get clean -y 2>/dev/null || true
sudo apt-get autoremove -y 2>/dev/null || true

# =============================================================================
# Clean Thumbnails Cache (can grow large)
# =============================================================================

log_info "Cleaning thumbnails cache..."
rm -rf "$HOME/.cache/thumbnails/"* 2>/dev/null || true
rm -rf "$HOME/.cache/gnome-software/thumbnails/"* 2>/dev/null || true

# =============================================================================
# Clean Old Kernels (keep current)
# =============================================================================

log_info "Cleaning old kernels..."
sudo apt-get autoremove -y 2>/dev/null || true

# =============================================================================
# Clean Flatpak unused runtimes
# =============================================================================

if command -v flatpak &>/dev/null; then
    log_info "Cleaning Flatpak unused runtimes..."
    flatpak remove --unused -y 2>/dev/null || true
fi

# =============================================================================
# Clean Docker (optional - comment out if not wanted)
# =============================================================================

# log_info "Cleaning Docker..."
# docker system prune -af 2>/dev/null || true

# =============================================================================
# Clear journal logs (keep recent)
# =============================================================================

log_info "Cleaning journal logs..."
sudo journalctl --vacuum-time=7d 2>/dev/null || true

log_info "✅ System cleanup complete"