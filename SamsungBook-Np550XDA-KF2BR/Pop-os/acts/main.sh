#!/usr/bin/env bash

# =============================================================================
# Pop!OS Optimization Main Script
# Hardware: Samsung 550XDA-KF2BR (Intel i5-1135G7 + 8GB RAM + Iris Xe)
# Optimized for: Gaming, Content Creation, Virtualization, Development
# 
# Source of Truth: ../Config/enviroment_config
# =============================================================================

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

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║   Pop!OS Optimization for Samsung 550XDA-KF2BR            ║"
echo "║   Hardware: Intel i5-1135G7 + 8GB RAM + Iris Xe Graphics  ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# =============================================================================
# Verify enviroment_config exists
# =============================================================================

ENV_CONFIG="$PROJECT_ROOT/Config/enviroment_config"
if [[ ! -f "$ENV_CONFIG" ]]; then
    log_error "enviroment_config not found at: $ENV_CONFIG"
    exit 1
fi
log_info "Using enviroment_config: $ENV_CONFIG"

# =============================================================================
# Step 1: Clean System
# =============================================================================
log_step "Step 1/5: Cleaning system..."

if [[ -f "./clean-system.sh" ]]; then
    chmod +x ./clean-system.sh
    bash ./clean-system.sh
    log_info "System cleaned successfully"
else
    log_warn "clean-system.sh not found! Skipping."
fi

echo ""

# =============================================================================
# Step 2: Install Packages
# =============================================================================
log_step "Step 2/5: Installing packages..."

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
# Step 3: System Optimization (sysctl)
# =============================================================================
log_step "Step 3/5: Applying sysctl optimizations..."

if [[ -f "./sysctl-tuning.sh" ]]; then
    chmod +x ./sysctl-tuning.sh
    sudo bash ./sysctl-tuning.sh
    log_info "Sysctl optimizations applied"
else
    log_error "sysctl-tuning.sh not found!"
    exit 1
fi

echo ""

# =============================================================================
# Step 4: Start Services
# =============================================================================
log_step "Step 4/5: Starting services..."

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
# Step 5: Environment Variables
# =============================================================================
log_step "Step 5/5: Setting up environment variables..."

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
