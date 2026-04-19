#!/usr/bin/env bash 

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
source "$PROJECT_ROOT/helpers/apt-packages.sh"
source "$PROJECT_ROOT/helpers/flatpak-packages.sh"

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
    # DaVinci Resolve: build from source (not on Flathub)
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

echo ""

DAVINCI_ZIP="$HOME/Downloads/DaVinci_Resolve_*_Linux.zip"
DAVINCI_RUN="$HOME/Downloads/DaVinci_Resolve_*_Linux.run"

if [[ -f "$DAVINCI_ZIP" || -f "$DAVINCI_RUN" ]]; then
    echo "=== Installing DaVinci Resolve ==="

    sudo apt install -y fakeroot libglu1-mesa libssl3 ocl-icd-opencl-dev qtwayland5 xorriso

    if [[ -f "$HOME/Downloads/DaVinci_Resolve.zip" ]]; then
        unzip -o "$HOME/Downloads/DaVinci_Resolve.zip" -d "$HOME/Downloads/"
    fi

    cd "$HOME/Downloads"

    if [[ -f "./makeresolvedeb*.sh" && -f "./DaVinci_Resolve_*_Linux.run" ]]; then
        chmod +x ./makeresolvedeb*.sh
        bash ./makeresolvedeb*.sh DaVinci_Resolve_*_Linux.run
        sudo dpkg -i davinci-resolve*_amd64
    elif [[ -f "./DaVinci_Resolve_*_Linux.run" ]]; then
        chmod +x ./DaVinci_Resolve_*_Linux.run
        sudo ./DaVinci_Resolve_*_Linux.run
    fi

    echo "✅ DaVinci Resolve installed"
else
    echo "=== DaVinci Resolve not found ==="
    echo "Download from: https://www.blackmagic-design.com/products/davinciresolve"
    echo "1. Download DaVinci Resolve Linux .zip"
    echo "2. Download MakeResolveDeb script"
    echo "3. Extract to ~/Downloads/"
    echo "4. Run: sudo dpkg -i davinci-resolve*_amd64"
fi