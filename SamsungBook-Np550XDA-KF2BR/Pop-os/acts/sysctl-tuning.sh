#!/usr/bin/env bash 

# =============================================================================
# Pop!OS System Optimization for Samsung 550XDA-KF2BR
# Hardware: Intel Core i5-1135G7 (TigerLake) + 8GB RAM + NVMe
# Optimized for: Gaming, Content Creation, Virtualization
# =============================================================================

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[SYSCTL]${NC} $1"; }

# =============================================================================
# Memory & VM optimizations (8GB RAM + NVMe)
# =============================================================================

MEMORY_VM=(
    # Reduce swap tendency (8GB RAM is sufficient)
    "vm.swappiness=10"
    
    # Dirty page tuning for NVMe
    "vm.dirty_ratio=15"
    "vm.dirty_background_ratio=5"
    "vm.dirty_writeback_centisecs=1500"
    "vm.dirty_expire_centisecs=3000"
    
    # Cache pressure
    "vm.vfs_cache_pressure=50"
    
    # ZRAM optimization (already active with 7.48GB)
    "vm.compaction_proactiveness=0"
    "vm.memory_failure_early_kill=1"
    
    # Transparent HugePages - madvise for gaming (reduces jitter)
    "vm.nr_hugepages=0"
    
    # Watermark tuning for gaming consistency
    "vm.watermark_boost_factor=0"
    "vm.watermark_scale_factor=100"
    "vm.min_free_kbytes=1048576"
    
    # Page lock unfairness (reduces latency)
    "vm.page_lock_unfairness=1"
    
    # Disable zone reclaim (reduce latency spikes)
    "vm.zone_reclaim_mode=0"
)

# =============================================================================
# Gaming optimizations (from Arch Wiki Gaming)
# =============================================================================

GAMING=(
    # Increase max map count for games
    "vm.max_map_count=1048576"
    
    # Reduce proactive compaction (causes jitter)
    "vm.compaction_proactiveness=0"
    
    # MGLRU for better memory management
    "vm.lru_gen.enabled=5"
)

# =============================================================================
# Network optimizations for Wi-Fi 6 AX201
# =============================================================================

NETWORK=(
    # Buffer sizes
    "net.core.rmem_max=134217728"
    "net.core.wmem_max=134217728"
    "net.ipv4.tcp_rmem=4096 87380 67108864"
    "net.ipv4.tcp_wmem=4096 65536 67108864"
    
    # BBR TCP congestion (better throughput)
    "net.ipv4.tcp_congestion_control=bbr"
    "net.core.default_qdisc=fq"
    
    # TCP optimizations
    "net.ipv4.tcp_fastopen=3"
    "net.ipv4.tcp_slow_start_after_idle=0"
    "net.ipv4.tcp_timestamps=1"
    "net.ipv4.tcp_sack=1"
    
    # Core network buffers
    "net.core.netdev_max_backlog=5000"
    "net.core.optmem_max=65536"
)

# =============================================================================
# File system optimizations for NVMe
# =============================================================================

FILESYSTEM=(
    "fs.file-max=2097152"
    "fs.inotify.max_user_watches=524288"
    "fs.inotify.max_user_instances=1024"
    "fs.inotify.max_user_instances=1024"
)

# =============================================================================
# Kernel scheduler optimizations
# =============================================================================

SCHEDULER=(
    # Reduce child first runs (more consistent performance)
    "kernel.sched_child_runs_first=0"
    
    # Autogroup for desktop interactivity
    "kernel.sched_autogroup_enabled=1"
    
    # CFS bandwidth slice (lower = more responsive)
    "kernel.sched_cfs_bandwidth_slice_us=3000"
)

# =============================================================================
# Apply all sysctl settings
# =============================================================================

apply_sysctl() {
    local group="$1"
    shift
    local configs=("$@")
    
    log_info "Applying $group..."
    for config in "${configs[@]}"; do
        sysctl -w "$config" 2>/dev/null || true
    done
}

# Apply all groups
apply_sysctl "Memory/VM" "${MEMORY_VM[@]}"
apply_sysctl "Gaming" "${GAMING[@]}"
apply_sysctl "Network" "${NETWORK[@]}"
apply_sysctl "Filesystem" "${FILESYSTEM[@]}"
apply_sysctl "Scheduler" "${SCHEDULER[@]}"

# =============================================================================
# Make settings persistent (create sysctl config)
# =============================================================================

SYSCTL_FILE="/etc/sysctl.d/99-samsung-tigerlake.conf"

cat > "$SYSCTL_FILE" << 'EOF'
# Samsung 550XDA-KF2BR System Optimization
# Hardware: Intel i5-1135G7 (TigerLake) + 8GB RAM + Iris Xe

# === Memory/VM ===
vm.swappiness=10
vm.dirty_ratio=15
vm.dirty_background_ratio=5
vm.dirty_writeback_centisecs=1500
vm.dirty_expire_centisecs=3000
vm.vfs_cache_pressure=50
vm.compaction_proactiveness=0
vm.memory_failure_early_kill=1
vm.watermark_boost_factor=0
vm.watermark_scale_factor=100
vm.min_free_kbytes=1048576
vm.page_lock_unfairness=1
vm.zone_reclaim_mode=0

# === Gaming ===
vm.max_map_count=1048576
vm.lru_gen.enabled=5

# === Network ===
net.core.rmem_max=134217728
net.core.wmem_max=134217728
net.ipv4.tcp_rmem=4096 87380 67108864
net.ipv4.tcp_wmem=4096 65536 67108864
net.ipv4.tcp_congestion_control=bbr
net.core.default_qdisc=fq
net.ipv4.tcp_fastopen=3
net.ipv4.tcp_slow_start_after_idle=0
net.ipv4.tcp_timestamps=1
net.ipv4.tcp_sack=1
net.core.netdev_max_backlog=5000
net.core.optmem_max=65536

# === Filesystem ===
fs.file-max=2097152
fs.inotify.max_user_watches=524288
fs.inotify.max_user_instances=1024

# === Scheduler ===
kernel.sched_child_runs_first=0
kernel.sched_autogroup_enabled=1
kernel.sched_cfs_bandwidth_slice_us=3000
EOF

log_info "✅ System optimization applied for Samsung 550XDA-KF2BR"
log_info "   Persistent config: $SYSCTL_FILE"