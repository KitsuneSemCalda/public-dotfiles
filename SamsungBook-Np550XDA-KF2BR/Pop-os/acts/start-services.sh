#!/usr/bin/env bash 

# =============================================================================
# System Services for Samsung 550XDA-KF2BR
# Optimized for Intel TigerLake i5-1135G7
# =============================================================================

SYSTEMD_SERVICES=(
    "thermald"
    "tlp"
    "irqbalance"
)

for service in "${SYSTEMD_SERVICES[@]}"; do
    systemctl enable --now "$service" 2>/dev/null || true
done

# =============================================================================
# TLP Configuration for Intel TigerLake
# =============================================================================

TLP_CONFIG="/etc/tlp.d/99-tigerlake.conf"

cat > "$TLP_CONFIG" << 'EOF'
# TLP Configuration for Samsung 550XDA-KF2BR
# CPU: Intel i5-1135G7 (TigerLake)
# GPU: Intel Iris Xe Graphics

# CPU Performance Governor
CPU_SCALING_GOVERNOR_ON_AC=performance
CPU_SCALING_GOVERNOR_ON_BAT=powersave

# CPU Frequency Limits
CPU_MIN_PERF_ON_AC=100
CPU_MAX_PERF_ON_AC=100
CPU_MIN_PERF_ON_BAT=20
CPU_MAX_PERF_ON_BAT=60

# Intel Turbo Boost
CPU_BOOST_ON_AC=1
CPU_BOOST_ON_BAT=0

# CPU Energy Performance Preferences
CPU_ENERGY_PERF_POLICY_ON_AC=performance
CPU_ENERGY_PERF_POLICY_ON_BAT=power

# GPU Power Management
GPU_DRIVER_SWITCHING=0

# Intel Graphics
INTEL_GPU_MIN_FREQ_ON_AC=300
INTEL_GPU_MIN_FREQ_ON_BAT=100
INTEL_GPU_MAX_FREQ_ON_AC=1300
INTEL_GPU_MAX_FREQ_ON_BAT=600

# PCI Express Active State Power Management
PCIE_ASPM_ON_AC=performance
PCIE_ASPM_ON_BAT=powersave

# Runtime Power Management
RUNTIME_PM_ON_AC=on
RUNTIME_PM_ON_BAT=auto

# SATA ALPM
SATA_ALPM_ON_AC=min_power
SATA_ALPM_ON_BAT=min_power

# Wi-Fi Power Saving
WIFI_PWR_ON_AC=off
WIFI_PWR_ON_BAT=on

# Bluetooth
BT_ON_AC=off
BT_ON_BAT=on

# Sound Card
SOUND_POWER_SAVE_ON_AC=0
SOUND_POWER_SAVE_ON_BAT=1
SOUND_POWER_SAVE_CONTROLLER=Y

# Disk IO Scheduler
DISK_IO_SCHEDULER="mq-deadline"
EOF

# Apply TLP config
tlp start 2>/dev/null || true

echo "✅ Services and TLP configuration applied for Samsung 550XDA-KF2BR"