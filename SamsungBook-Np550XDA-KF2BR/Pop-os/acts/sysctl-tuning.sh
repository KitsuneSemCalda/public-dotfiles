#!/usr/bin/env bash 

# =============================================================================
# Pop!OS System Optimization for Samsung 550XDA-KF2BR
# Hardware: Intel Core i5-1135G7 (TigerLake) + 8GB RAM + NVMe
# =============================================================================

SYSCTL_CONFIG_LIST=(
    # Memory & VM optimizations (8GB RAM + NVMe)
    "vm.swappiness=5"
    "vm.dirty_ratio=15"
    "vm.dirty_background_ratio=5"
    "vm.vfs_cache_pressure=50"
    "vm.dirty_writeback_centisecs=1500"
    "vm.dirty_expire_centisecs=3000"
    
    # ZRAM optimization (already active with 7.48GB)
    "vm.compaction_proactiveness=20"
    "vm.memory_failure_early_kill=1"
    
    # Network optimizations for Wi-Fi 6 AX201
    "net.core.rmem_max=134217728"
    "net.core.wmem_max=134217728"
    "net.ipv4.tcp_rmem=4096 87380 67108864"
    "net.ipv4.tcp_wmem=4096 65536 67108864"
    "net.ipv4.tcp_congestion_control=bbr"
    "net.core.default_qdisc=fq"
    "net.ipv4.tcp_fastopen=3"
    "net.ipv4.tcp_slow_start_after_idle=0"
    
    # File system optimizations for NVMe
    "fs.file-max=2097152"
    "fs.inotify.max_user_watches=524288"
    "fs.inotify.max_user_instances=1024"
)

# Apply sysctl settings
for config in "${SYSCTL_CONFIG_LIST[@]}"; do
    sysctl -w "$config" 2>/dev/null || true
done

# =============================================================================
# Kernel Module Parameters for Intel TigerLake (i5-1135G7)
# =============================================================================

KERNEL_PARAMS=(
    # Intel iGPU (Iris Xe) optimizations
    "i915.perf_stream_paranoid=0"
    "i915.enable_guc=2"
    "i915.enable_psr=1"
    "i915.modeset=1"
    "i915.enable_fbc=1"
    
    # Audio low-latency for Intel Smart Sound
    "snd_hda_intel.dmic_detect=0"
    
    # NVMe optimizations
    "nvme.core.io_timeout=4294967295"
    "nvme.noacpi=1"
)

for param in "${KERNEL_PARAMS[@]}"; do
    echo "$param" > /sys/module/${param%%=*}/parameters/${param#*=} 2>/dev/null || true
done

echo "✅ System optimization applied for Samsung 550XDA-KF2BR"