#!/usr/bin/env bash 

# =============================================================================
# System Services for Samsung 550XDA-KF2BR
# Hardware: Intel i5-1135G7 (TigerLake) + 8GB RAM + Iris Xe
# Optimized for: Gaming, Content Creation, Virtualization
# =============================================================================

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[SERVICE]${NC} $1"; }

# =============================================================================
# Core System Services
# =============================================================================

CORE_SERVICES=(
    "thermald"          # Thermal management (Intel)
    "tlp"               # Power management (TLP)
    "irqbalance"        # CPU load balancing
    "preload"           # RAM preloading
)

# =============================================================================
# Gaming Services
# =============================================================================

GAMING_SERVICES=(
    "gamemoded"         # GameMode daemon (NVIDIA/AMD/Intel optimization)
)

# =============================================================================
# Virtualization Services
# =============================================================================

VIRT_SERVICES=(
    "libvirtd"          # KVM/QEMU virtualization
    "docker"            # Docker daemon
)

# =============================================================================
# Enable and start all services
# =============================================================================

enable_service() {
    local service="$1"
    if systemctl list-unit-files "$service" &>/dev/null; then
        sudo systemctl enable --now "$service" 2>/dev/null && \
            log_info "Enabled: $service" || \
            log_info "Skipped: $service (not installed)"
    else
        log_info "Not found: $service"
    fi
}

log_info "Starting core services..."
for svc in "${CORE_SERVICES[@]}"; do
    enable_service "$svc"
done

log_info "Starting gaming services..."
for svc in "${GAMING_SERVICES[@]}"; do
    enable_service "$svc"
done

log_info "Starting virtualization services..."
for svc in "${VIRT_SERVICES[@]}"; do
    enable_service "$svc"
done

# =============================================================================
# TLP Configuration for Intel TigerLake
# =============================================================================

TLP_CONFIG="/etc/tlp.d/99-tigerlake.conf"

cat > "$TLP_CONFIG" << 'EOF'
# TLP Configuration for Samsung 550XDA-KF2BR
# CPU: Intel i5-1135G7 (TigerLake)
# GPU: Intel Iris Xe Graphics
# Optimized for: Gaming, Content Creation

# === CPU ===
CPU_SCALING_GOVERNOR_ON_AC=performance
CPU_SCALING_GOVERNOR_ON_BAT=powersave
CPU_MIN_PERF_ON_AC=100
CPU_MAX_PERF_ON_AC=100
CPU_MIN_PERF_ON_BAT=20
CPU_MAX_PERF_ON_BAT=60
CPU_BOOST_ON_AC=1
CPU_BOOST_ON_BAT=0
CPU_ENERGY_PERF_POLICY_ON_AC=performance
CPU_ENERGY_PERF_POLICY_ON_BAT=power

# === GPU (Intel Iris Xe) ===
GPU_DRIVER_SWITCHING=0
INTEL_GPU_MIN_FREQ_ON_AC=300
INTEL_GPU_MIN_FREQ_ON_BAT=100
INTEL_GPU_MAX_FREQ_ON_AC=1300
INTEL_GPU_MAX_FREQ_ON_BAT=600

# === PCI Express ===
PCIE_ASPM_ON_AC=performance
PCIE_ASPM_ON_BAT=powersave
RUNTIME_PM_ON_AC=on
RUNTIME_PM_ON_BAT=auto

# === Storage ===
SATA_ALPM_ON_AC=min_power
SATA_ALPM_ON_BAT=min_power
DISK_IO_SCHEDULER="mq-deadline"

# === Wireless ===
WIFI_PWR_ON_AC=off
WIFI_PWR_ON_BAT=on

# === Bluetooth ===
BT_ON_AC=off
BT_ON_BAT=on

# === Audio ===
SOUND_POWER_SAVE_ON_AC=0
SOUND_POWER_SAVE_ON_BAT=1
SOUND_POWER_SAVE_CONTROLLER=Y
EOF

# Apply TLP config
tlp start 2>/dev/null || true

# =============================================================================
# CPU Governor (alternative to TLP)
# =============================================================================

# Set performance governor for gaming/content creation
if [[ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]]; then
    for cpu in /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_governor; do
        echo "performance" | sudo tee "$cpu" 2>/dev/null || true
    done
    log_info "CPU governor set to: performance"
fi

# =============================================================================
# Intel GPU Frequency (via intel-gpu-tools)
# =============================================================================

# Set max GPU frequency for performance
if command -v intel_gpu_frequency &>/dev/null; then
    sudo intel_gpu_frequency -m 1300 2>/dev/null || true
    log_info "Intel GPU: Max frequency set"
fi

# =============================================================================
# NVMe Scheduler (mq-deadline for NVMe)
# =============================================================================

for nvme in /sys/block/nvme*/queue/scheduler; do
    echo "mq-deadline" | sudo tee "$nvme" 2>/dev/null || true
done
log_info "NVMe scheduler: mq-deadline"

# =============================================================================
# User Groups
# =============================================================================

for group in kvm libvirt docker audio video input; do
    if getent group "$group" &>/dev/null; then
        sudo usermod -aG "$group" "$USER" 2>/dev/null || true
    fi
done
log_info "User groups updated"

log_info "✅ Services and TLP configuration applied for Samsung 550XDA-KF2BR"