#!/usr/bin/env bash

# =============================================================================
# Pop!OS Optimization Main Script
# Hardware: Samsung 550XDA-KF2BR (i5-1135G7 + 8GB RAM + Iris Xe)
# Purpose: Content Creation, Gaming, Virtualization, Development
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if running as root (some operations need sudo)
if [[ $EUID -eq 0 ]]; then
    log_warn "Running as root. Some sudo commands may fail."
fi

echo ""
echo "=============================================="
echo "  Pop!OS Optimization for Samsung 550XDA-KF2BR"
echo "=============================================="
echo ""

# =============================================================================
# Step 1: Install Packages
# =============================================================================
log_info "Step 1/4: Installing packages..."

if [[ -f "./clean-system.sh" ]]; then
    chmod +x ./clean-system.sh
    bash ./clean-system.sh
    log_info "System cleaned successfully"
else
    log_warn "clean-system.sh not found! Skipping system cleanup."
fi

if [[ -f "./install_new_things.sh" ]]; then    
    chmod +x ./install_new_things.sh
    bash ./install_new_things.sh
    log_info "Packages installed successfully"
else
    log_error "install_new_things.sh not found!"
    exit 1
fi

echo ""

# =============================================================================
# Step 2: System Optimization (sysctl)
# =============================================================================
log_info "Step 2/4: Applying system optimizations..."

if [[ -f "./sysctl-tuning.sh" ]]; then
    chmod +x ./sysctl-tuning.sh
    sudo bash ./sysctl-tuning.sh
    log_info "System optimizations applied"
else
    log_error "sysctl-tuning.sh not found!"
    exit 1
fi

echo ""

# =============================================================================
# Step 3: Start Services
# =============================================================================
log_info "Step 3/4: Starting and enabling services..."

if [[ -f "./start-services.sh" ]]; then
    chmod +x ./start-services.sh
    sudo bash ./start-services.sh
    log_info "Services configured successfully"
else
    log_error "start-services.sh not found!"
    exit 1
fi

echo ""

# =============================================================================
# Step 4: Environment Variables
# =============================================================================
log_info "Step 4/4: Setting up environment variables..."

if [[ -f "./update_profile.sh" ]]; then
    chmod +x ./update_profile.sh
    bash ./update_profile.sh
    log_info "Environment variables configured"
else
    log_error "update_profile.sh not found!"
    exit 1
fi

echo ""
echo "=============================================="
echo -e "${GREEN}✅ Optimization complete!${NC}"
echo "=============================================="
echo ""
echo "Next steps:"
echo "  1. Restart your session: logout & login"
echo "  2. Or source: source ~/.bashrc"
echo "  3. Check services: systemctl status tlp thermald"
echo ""
echo "Optional (manual):"
echo "  - Clean system: bash ./clean-system.sh"
echo "  - Verify GPU:  vainfo"
echo "  - Check TLP:   tlp-stat -s"
echo ""