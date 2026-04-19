#!/usr/bin/env bash 

source "helpers/apt-packages.sh"
source "helpers/flatpak-packages.sh"

APT_PACKAGES=(
    # System monitoring and performance tools
    linux-tools-common
    linux-tools-generic
    cpufrequtils
    thermald
    tlp
    tlp-rdw
    irqbalance
    preload
    
    # Intel Iris Xe Graphics drivers and utilities
    mesa-utils
    mesa-vulkan-drivers
    vulkan-tools
    libvulkan1
    intel-media-va-driver-non-free
    intel-gpu-tools
    i965-va-driver
    i965-va-driver-shaders

    # Development tools 
    build-essential
    clang
    lld
    cmake
    xmake
    ninja-build
    pkg-config
    valgrind
    
    # ==== NOVAS ADIÇÕES PARA SAMSUNG 550XDA-KF2BR ====
    
    # Network utilities (Wi-Fi 6 AX201)
    ethtool
    iw
    wireless-tools
    
    # BBR TCP congestion control
    linux-image-extra-virtual
    
    # ==== REMOVIDO: tuned (conflita com TLP) ====
    # tuned
    # tuned-utils
    
    # Intel-specific tools
    intel-speed-select
    
    # Thermal management
    psensor
    
    # NVMe tools
    nvme-cli
    
    # ==== VIRTUALIZAÇÃO (QEMU/KVM/Docker) ====
    # QEMU/KVM
    qemu-kvm
    libvirt-daemon
    libvirt-clients
    virt-manager
    virt-install
    bridge-utils
    
    # Docker
    docker.io
    docker-compose
    
    # Podman (alternativa sem daemon)
    podman
    podman-docker
    
    # ==== CRIAÇÃO DE CONTEÚDO ====
    # Video editing
    # kdenlive # substituído por DaVinci Resolve (flatpak)
    obs-studio
    ffmpeg
    
    # Audio
    audacity
    
    # Image/3D
    blender
    gimp
    inkscape
)

FLATPAK_PACKAGES=(
    "com.microsoft.Edge"
    "com.spotify.Client"
    "com.visualstudio.code"

    "org.onlyoffice.desktopeditors"
    
    "md.obsidian.Obsidian"
    
    "io.freetubeapp.FreeTube"
    "io.appflowy.AppFlowy"
    
    # ==== GAMING ====
    "com.valvesoftware.Steam"
    "net.lutris.Lutris"
    "com.obsproject.Studio"
    
    # ==== CRIAÇÃO DE CONTEÚDO ====
    "com.blackmagic-design.DaVinciResolve"
)

FLATPAK_PACKAGES=(
    "com.microsoft.Edge"
    "com.spotify.Client"
    "com.visualstudio.code"

    "org.onlyoffice.desktopeditors"
    
    "md.obsidian.Obsidian"
    
    "io.freetubeapp.FreeTube"
    "io.appflowy.AppFlowy"
)

# Install all APT packages
for package in "${APT_PACKAGES[@]}"; do
    install_package "$package"
done

# Install all Flatpak packages
for package in "${FLATPAK_PACKAGES[@]}"; do
    install_flatpak "$package"
done

# =============================================================================
# Post-install configuration for Samsung 550XDA-KF2BR
# =============================================================================

# Enable BBR TCP congestion control
sudo modprobe tcp_bbr 2>/dev/null || true
sudo modprobe tcp_cubic 2>/dev/null || true

# Set BBR as default
sudo sysctl -w net.ipv4.tcp_congestion_control=bbr 2>/dev/null || true
sudo sysctl -w net.core.default_qdisc=fq 2>/dev/null || true

# ==== REMOVIDO: tuned (conflita com TLP) ====
# sudo tuned-adm profile balanced 2>/dev/null || true

# Enable irqbalance
sudo systemctl enable --now irqbalance 2>/dev/null || true

# Enable libvirt (virtualization)
sudo systemctl enable --now libvirtd 2>/dev/null || true
sudo usermod -aG libvirt "$USER" 2>/dev/null || true

# Enable Docker (if installed)
sudo systemctl enable --now docker 2>/dev/null || true
sudo usermod -aG docker "$USER" 2>/dev/null || true

echo "✅ Additional packages installed and configured for Samsung 550XDA-KF2BR"

upgrade_system
upgrade_flatpak

for package in "${APT_PACKAGES[@]}"; do
    install_apt "$package"
done

for package in "${FLATPAK_PACKAGES[@]}"; do
    install_flatpak "$package"
done