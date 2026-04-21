#!/usr/bin/env bash 

# =============================================================================
# Package Installation for Samsung 550XDA-KF2BR
# Hardware: Intel i5-1135G7 (TigerLake) + 8GB RAM + Iris Xe
# Optimized for: Gaming, Content Creation, Virtualization, Development
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
source "$PROJECT_ROOT/helpers/apt-packages.sh"
source "$PROJECT_ROOT/helpers/flatpak-packages.sh"

APT_PACKAGES=(
    # ==== SYSTEM MONITORING & PERFORMANCE ====
    linux-tools-common
    linux-tools-generic
    cpufrequtils
    thermald
    tlp
    tlp-rdw
    irqbalance
    preload
    htop
    btop
    glances
    
    # ==== INTEL IRIS XE GRAPHICS (TigerLake) ====
    mesa-utils
    mesa-vulkan-drivers
    vulkan-tools
    libvulkan1
    intel-media-va-driver-non-free
    intel-gpu-tools
    i965-va-driver
    i965-va-driver-shaders
    vainfo                          # Verify VA-API support
    vulkan-validationlayers         # For debugging Vulkan
    
    # ==== DEVELOPMENT TOOLS ====
    build-essential
    clang
    lld
    cmake
    xmake
    ninja-build
    pkg-config
    valgrind
    git
    curl
    wget
    zsh
    fzf
    bat
    exa
    ripgrep
    fd-find
    
    # ==== NETWORK (Wi-Fi 6 AX201) ====
    ethtool
    iw
    wireless-tools
    network-manager
    iputils-ping
    traceroute
    
    # ==== INTEL SPECIFIC TOOLS ====
    x11vnc
    
    # ==== THERMAL & HARDWARE ====
    psensor
    nvme-cli
    smartmontools
    lm-sensors
    
    # ==== VIRTUALIZAÇÃO ====
    # QEMU/KVM
    qemu-kvm
    libvirt-daemon
    libvirt-clients
    virt-manager
    virt-install
    bridge-utils
    dnsmasq
    
    # Docker
    docker.io
    docker-compose
    docker-buildx
    
    # Podman
    podman
    podman-docker
    
    # ==== GAMING ====
    # GameMode - temporary performance boost for games
    gamemode
    libgamemode0
    
    # Gamescope (Valve's micro-compositor)
    # gamescope  # Available via flatpak or source
    
    # SDL2 for better game compatibility
    libsdl2-2.0-0
    libsdl2-mixer-2.0
    libsdl2-image-2.0
    libsdl2-ttf-2.0
    
    # Additional game libraries
    libvulkan1
    libgl1-mesa-dri
    libglx-mesa0
    
    # ==== CONTENT CREATION ====
    # Video
    ffmpeg
    ffmpegthumbnailer
    
    # Audio
    pavucontrol          # PulseAudio volume control
    pipewire             # Modern audio server
    pipewire-pulse
    wireplumber
    
    # ==== RUNTIME LIBRARIES ====
    # .NET
    dotnet-sdk-8.0
    dotnet-runtime-8.0
    
    # Java
    openjdk-21-jdk
    openjdk-21-jre
    
    # Node.js
    nodejs
    npm
    
    # Python
    python3
    python3-pip
    python3-venv

FLATPAK_PACKAGES=(
    # ==== BROWSERS ====
    "com.microsoft.Edge"
    "org.mozilla.firefox"
    
    # ==== COMMUNICATION ====
    "com.spotify.Client"
    "org.telegram.desktop"
    "com.discord.Discord"
    
    # ==== DEVELOPMENT ====
    "com.visualstudio.code"
    "com.jetbrains.IntelliJ-IDEA-Community"
    "com.jetbrains.WebStorm"
    "org.python.PyCharm-Community"
    
    # ==== PRODUCTIVITY ====
    "org.onlyoffice.desktopeditors"
    "md.obsidian.Obsidian"
    "io.appflowy.AppFlowy"
    "org.gnome.Geary"
    
    # ==== MEDIA / CONTENT CREATION ====
    "io.freetubeapp.FreeTube"
    "com.obsproject.Studio"
    "org.videolan.VLC"
    "io.mpv.Mpv"
    "org.audacityteam.Audacity"
    "org.blender.Blender"
    "org.gimp.GIMP"
    "org.inkscape.Inkscape"
    "com.rawtherapee.RawTherapee"
    "org.darktable.Darktable"
    "org.kde.kdenlive"
    
    # ==== GAMING ====
    "com.valvesoftware.Steam"
    "net.lutris.Lutris"
    
    # ==== SYSTEM TOOLS ====
    "org.freedesktop.Platform"
    "org.freedesktop.Sdk"
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

log_info "Running post-install configuration..."

# ==== NETWORK: Enable BBR TCP congestion control ====
sudo modprobe tcp_bbr 2>/dev/null || true
sudo modprobe tcp_cubic 2>/dev/null || true
sudo sysctl -w net.ipv4.tcp_congestion_control=bbr 2>/dev/null || true
sudo sysctl -w net.core.default_qdisc=fq 2>/dev/null || true

# ==== SERVICES ====
# Enable irqbalance (CPU load balancing)
sudo systemctl enable --now irqbalance 2>/dev/null || true

# Enable libvirt (KVM virtualization)
sudo systemctl enable --now libvirtd 2>/dev/null || true
sudo usermod -aG libvirt "$USER" 2>/dev/null || true

# Enable Docker
sudo systemctl enable --now docker 2>/dev/null || true
sudo usermod -aG docker "$USER" 2>/dev/null || true

# Enable PipeWire (modern audio)
sudo systemctl --user enable --now pipewire 2>/dev/null || true
sudo systemctl --user enable --now pipewire-pulse 2>/dev/null || true

# ==== INTEL GPU: Verify hardware acceleration ====
log_info "Verifying Intel Iris Xe Graphics..."
if command -v vainfo &> /dev/null; then
    vainfo 2>/dev/null || log_info "VA-API: Run manually to verify"
fi

# ==== GAMING: Configure GameMode ====
if command -v gamemoded &> /dev/null; then
    sudo systemctl enable --now gamemoded 2>/dev/null || true
    log_info "GameMode: Enabled for gaming optimization"
fi

# ==== PERMISSION: Add user to required groups ====
for group in kvm libvirt docker audio video; do
    sudo usermod -aG "$group" "$USER" 2>/dev/null || true
done

log_info "✅ Post-install configuration complete"

upgrade_system
upgrade_flatpak

echo "✅ All installations completed successfully"