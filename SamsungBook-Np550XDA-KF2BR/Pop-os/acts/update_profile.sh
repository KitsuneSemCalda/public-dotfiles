#!/usr/bin/env bash

# =============================================================================
# Environment Variables for Samsung 550XDA-KF2BR
# Optimized for: Content Creation, Gaming, Virtualization
# Hardware: Intel i5-1135G7 (TigerLake) + 8GB RAM + Iris Xe Graphics
# =============================================================================

PROFILE_FILE="$HOME/.profile"
BASHRC_FILE="$HOME/.bashrc"

# Check if variable already exists (prevent duplicates)
var_exists() {
    grep -q "^export $1=" "$2" 2>/dev/null
}

# Add variable only if not exists
add_var() {
    local file="$1"
    local var="$2"
    local val="$3"
    
    if [[ ! -f "$file" ]]; then
        touch "$file"
    fi
    
    if ! grep -q "^export $var=" "$file" 2>/dev/null; then
        echo "export $var=$val" >> "$file"
    fi
}

# Add section header only if not exists
add_section() {
    local file="$1"
    local section="$2"
    
    if [[ ! -f "$file" ]]; then
        touch "$file"
    fi
    
    if ! grep -q "# === $section ===" "$file" 2>/dev/null; then
        echo "" >> "$file"
        echo "# === $section ===" >> "$file"
    fi
}

# =============================================================================
# GPU Optimization (Intel Iris Xe Graphics)
# =============================================================================

GPU_ENV=(
    # Vulkan & OpenGL
    "MESA_VK_WSI_DEBUG=async"
    "RADV_PERFTEST=aco"
    "AMD_VULKAN_ICD=RADV"
    "VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/intel_icd.x86_64.json"
    
    # Enable GPU compression
    "INTEL_DEBUG=nosag"
    "MESA_GL_VERSION_OVERRIDE=4.6"
    "MESA_GLSL_VERSION_OVERRIDE=460"
    
    # Enable hardware acceleration
    "LIBVA_DRIVER_NAME=iHD"
    "VAAPI_VIDEO_DEC_DRIVER=i965"
    "GBM_BACKEND=i915"
    
    # DXVK & Wine GPU settings
    "DXVK_ASYNC=1"
    "DXVK_STATE_CACHE=1"
    "PROTON_USE_WINED3D=0"
    "WINEDEBUG=-all"
    
    # Render nodes
    "ELECTRON_OZONE_PLATFORM_HINT=auto"
)

# =============================================================================
# CPU Optimization (Intel i5-1135G7)
# =============================================================================

CPU_ENV=(
    # Multi-threading optimization
    "OMP_NUM_THREADS=8"
    "MKL_NUM_THREADS=8"
    "OPENBLAS_NUM_THREADS=8"
    "NUMEXPR_NUM_THREADS=8"
    "MAX_JOBS=8"
    "MAKEFLAGS=-j8"
    
    # CPU frequency scaling
    "CPUFREQ=performance"
    
    # Compiler optimizations
    "CFLAGS=-O3 -march=native -mtune=native -ffast-math -funroll-loops"
    "CXXFLAGS=-O3 -march=native -mtune=native -ffast-math -funroll-loops"
    "LDFLAGS=-Wl,-O3,--sort-common,--as-needed,-z,relro,-z,now"
    
    # Rust/Cargo optimization
    "CARGO_BUILD_JOBS=8"
    "RUSTFLAGS=-C target-cpu=native"
    
    # Node.js optimization
    "NODE_OPTIONS=--max-old-space-size=4096"
    
    # Java optimization
    "_JAVA_OPTIONS=-Xmx4g -XX:+UseG1GC -XX:+UseStringDeduplication"
)

# =============================================================================
# Memory Optimization (8GB RAM)
# =============================================================================

MEMORY_ENV=(
    # Node.js heap
    "NODE_OPTIONS=--max-old-space-size=4096"
    
    # Python memory
    "PYTHONMALLOC=debug"
    "PYTHONTRACEMALLOC=1"
    
    # Java heap (4GB max for 8GB system)
    "_JAVA_OPTIONS=-Xmx4g -Xms1g -XX:+UseG1GC"
    
    # Go memory
    "GOMEMLIMIT=6Gi"
    "GOGC=100"
    
    # General
    "MALLOC_CONF=metadata_thp:always,thp:default"
    
    # Shader cache
    "RADV_PERFTEST=aco"
    "MESA_SHADER_CACHE_DISABLE=false"
    "MESA_SHADER_CACHE_MAX_SIZE=1G"
)

# =============================================================================
# Virtualization (QEMU/KVM)
# =============================================================================

VIRT_ENV=(
    # QEMU/KVM
    "QEMU_AUDIO_DRV=pa"
    "SPICE_USBREDIR_CHANNEL=true"
    "LIBVIRT_DEFAULT_URI=qemu:///system"
    
    # Docker
    "DOCKER_BUILDKIT=1"
    "COMPOSE_DOCKER_CLI_BUILD=1"
    "DOCKER_DEFAULT_PLATFORM=linux/amd64"
    
    # Podman
    "CONTAINER_MAX_MEMORY=6g"
    "CONTAINER_MAX_CPU=8"
    
    # VirtualBox
    "VBOX_LOG_FLAGS=all"
    "VBOX_LOG_DEST=file=/tmp/vbox.log"
)

# =============================================================================
# Content Creation (Video/Image/Audio)
# =============================================================================

CONTENT_ENV=(
    # FFmpeg hardware acceleration
    "FFMPEG_HW_ACCEL=vaapi"
    "VAAPI_DEVICE=/dev/dri/renderD128"
    
    # Blender
    "BLENDER_CPU_DEVICE=CPU"
    "CYCLES_DEVICE=CPU"
    "CYCLES_NUM_THREADS=8"
    
    # OBS Studio
    "OBS_USE_EGL=1"
    "OBS_VK_DEVICE=0"
    
    # GIMP
    "GIMP_PLUG_IN_DIR=/usr/lib/gimp/2.0/plug-ins"
    
    # Inkscape
    "INKSCAPE_PROFILE_DIR=\$HOME/.config/inkscape"
    
    # DaVinci Resolve (if installed)
    "RESOLVE_CUDA_DEVICE_PREFIX=/dev/dri"
    "RESOLVE_OPENCL_DEVICE_PREFIX=/dev/dri"
    
    # Kdenlive
    "KDENLIVE_RENDER_THREADS=8"
    
    # Audacity
    "AUDACITY_SAMPLE_RATE=48000"
)

# =============================================================================
# Gaming
# =============================================================================

GAMING_ENV=(
    # Steam
    "STEAM_FRAME_FORCE_CLOSE=1"
    "STEAM_RUNTIME=/usr/lib/steam-runtime"
    "PROTON_USE_WINED3D=0"
    "PROTON_NO_ESYNC=0"
    "PROTON_NO_FSYNC=0"
    
    # Lutris
    "LUTRIS_SKIP_INIT=1"
    "DXVK_LOG_LEVEL=none"
    "DXVK_STATE_CACHE=1"
    
    # Gamescope
    "GAMESCOPE_WSI_INTERFACE=wayland"
    "GAMESCOPE_LIMIT_FPS=0"
    
    # General
    "SDL_AUDIODRIVER=pulseaudio"
    "SDL_VIDEODRIVER=wayland,x11"
    "LIBGL_ALWAYS_SOFTWARE=0"
    "MESA_GL_VERSION_OVERRIDE=4.6"
    "GALLIUM_DRIVER=iris"
    
    # FPS counter
    "MESA_VK_WSI_DEBUG=present"
)

# =============================================================================
# Development
# =============================================================================

DEV_ENV=(
    # Git
    "GIT_LFS_SKIP_SMUDGE=1"
    "GIT_TERMINAL_PROMPT=1"
    
    # NPM/Yarn/PNPM
    "npm_config_loglevel=warn"
    "YARN_ENABLE_MIRROR=1"
    "PNPM_HOME=\$HOME/.local/share/pnpm"
    
    # Rust
    "RUSTUP_TOOLCHAIN=stable"
    "RUST_LOG=info"
    
    # Go
    "GO111MODULE=on"
    "GOPROXY=https://proxy.golang.org,direct"
    
    # Python
    "PYTHONDONTWRITEBYTECODE=1"
    "PYTHONPATH=\$HOME/.local/lib/python3.12/site-packages"
    
    # Java/Gradle/Maven
    "MAVEN_OPTS=-Xmx2g"
    "GRADLE_OPTS=-Xmx2g -Dorg.gradle.daemon=true"
    
    # CMAKE
# =============================================================================
# Apply Environment Variables (idempotent - no duplicates)
# =============================================================================

add_var() {
    local file="$1" var="$2" val="$3"
    [[ ! -f "$file" ]] && touch "$file"
    grep -q "^export $var=" "$file" 2>/dev/null || echo "export $var=$val" >> "$file"
}

add_section() {
    local file="$1" section="$2"
    [[ ! -f "$file" ]] && touch "$file"
    grep -q "# === $section ===" "$file" 2>/dev/null || { echo "" >> "$file"; echo "# === $section ===" >> "$file"; }
}

# GPU
add_section "$PROFILE_FILE" "GPU Optimization"
add_var "$PROFILE_FILE" "MESA_VK_WSI_DEBUG" "async"
add_var "$PROFILE_FILE" "LIBVA_DRIVER_NAME" "iHD"
add_var "$PROFILE_FILE" "GBM_BACKEND" "i915"
add_var "$PROFILE_FILE" "ELECTRON_OZONE_PLATFORM_HINT" "auto"
add_var "$PROFILE_FILE" "MESA_GL_VERSION_OVERRIDE" "4.6"
add_var "$PROFILE_FILE" "GALLIUM_DRIVER" "iris"

# CPU
add_section "$PROFILE_FILE" "CPU Optimization"
add_var "$PROFILE_FILE" "OMP_NUM_THREADS" "8"
add_var "$PROFILE_FILE" "MKL_NUM_THREADS" "8"
add_var "$PROFILE_FILE" "MAKEFLAGS" "-j8"
add_var "$PROFILE_FILE" "CARGO_BUILD_JOBS" "8"
add_var "$PROFILE_FILE" "RUSTFLAGS" "-C target-cpu=native"

# Memory
add_section "$PROFILE_FILE" "Memory Optimization"
add_var "$PROFILE_FILE" "NODE_OPTIONS" "--max-old-space-size=4096"
add_var "$PROFILE_FILE" "_JAVA_OPTIONS" "-Xmx4g -XX:+UseG1GC"
add_var "$PROFILE_FILE" "MALLOC_CONF" "metadata_thp:always,thp:default"

# Virtualization
add_section "$PROFILE_FILE" "Virtualization"
add_var "$PROFILE_FILE" "DOCKER_BUILDKIT" "1"
add_var "$PROFILE_FILE" "COMPOSE_DOCKER_CLI_BUILD" "1"
add_var "$PROFILE_FILE" "LIBVIRT_DEFAULT_URI" "qemu:///system"

# Gaming
add_section "$PROFILE_FILE" "Gaming"
add_var "$PROFILE_FILE" "STEAM_FRAME_FORCE_CLOSE" "1"
add_var "$PROFILE_FILE" "PROTON_USE_WINED3D" "0"
add_var "$PROFILE_FILE" "SDL_VIDEODRIVER" "wayland,x11"
add_var "$PROFILE_FILE" "DXVK_ASYNC" "1"
add_var "$PROFILE_FILE" "DXVK_STATE_CACHE" "1"

# Development
add_section "$PROFILE_FILE" "Development"
add_var "$PROFILE_FILE" "CMAKE_BUILD_PARALLEL_LEVEL" "8"

# Apply to .bashrc
for var in $(grep "^export " "$PROFILE_FILE" | cut -d' ' -f2 | cut -d'=' -f1); do
    val=$(grep "^export $var=" "$PROFILE_FILE" | head -1 | cut -d'=' -f2-)
    add_var "$BASHRC_FILE" "$var" "$val"
done

# System-wide
SYSTEM_ENV_FILE="/etc/environment.d/99-samsung-optimization.conf"
sudo tee "$SYSTEM_ENV_FILE" > /dev/null << 'EOF'
MESA_VK_WSI_DEBUG=async
LIBVA_DRIVER_NAME=iHD
GBM_BACKEND=i915
ELECTRON_OZONE_PLATFORM_HINT=auto
OMP_NUM_THREADS=8
MAKEFLAGS=-j8
MALLOC_CONF=metadata_thp:always,thp:default
DOCKER_BUILDKIT=1
STEAM_FRAME_FORCE_CLOSE=1
PROTON_USE_WINED3D=0
SDL_VIDEODRIVER=wayland,x11
CMAKE_BUILD_PARALLEL_LEVEL=8
EOF

echo "✅ Environment variables applied (idempotent)"
echo "⚠️  Restart session or run: source ~/.bashrc"
# =============================================================================
# Create /etc/environment for system-wide variables
# =============================================================================

SYSTEM_ENV_FILE=\"/etc/environment.d/99-samsung-optimization.conf\"

sudo tee \"\$SYSTEM_ENV_FILE\" > /dev/null << 'EOF'
# Samsung 550XDA-KF2BR System-wide Optimization
# Hardware: Intel i5-1135G7 + 8GB RAM + Iris Xe Graphics

# GPU - Intel Iris Xe
MESA_VK_WSI_DEBUG=async
RADV_PERFTEST=aco
LIBVA_DRIVER_NAME=iHD
GBM_BACKEND=i915
ELECTRON_OZONE_PLATFORM_HINT=auto

# CPU - Multi-threading
OMP_NUM_THREADS=8
MKL_NUM_THREADS=8
MAKEFLAGS=-j8

# Memory
MALLOC_CONF=metadata_thp:always,thp:default

# Virtualization
DOCKER_BUILDKIT=1
COMPOSE_DOCKER_CLI_BUILD=1

# Gaming
STEAM_FRAME_FORCE_CLOSE=1
PROTON_USE_WINED3D=0
SDL_VIDEODRIVER=wayland,x11

# Development
CMAKE_BUILD_PARALLEL_LEVEL=8
ELECTRON_OZONE_PLATFORM_HINT=auto
EOF

echo \"✅ Environment variables applied for Samsung 550XDA-KF2BR\"
echo \"   Files updated: \$PROFILE_FILE, \$BASHRC_FILE\"
echo \"   System-wide: \$SYSTEM_ENV_FILE\"
echo \"\"
echo \"⚠️  Restart your session or run: source ~/.bashrc\"