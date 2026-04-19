# Pop!OS Optimization for Samsung 550XDA-KF2BR

Optimized for: **Content Creation | Gaming | Virtualization | Development**

Hardware: Intel Core i5-1135G7 (TigerLake) + 8GB RAM + Intel Iris Xe Graphics + NVMe

---

## Quick Start

```bash
cd SamsungBook-Np550XDA-KF2BR/Pop-os/acts
chmod +x main.sh
sudo ./main.sh
```

## Scripts

| Script | Purpose |
|--------|---------|
| `main.sh` | Master script - runs all others in order |
| `install_new_things.sh` | Install packages (APT + Flatpak) |
| `sysctl-tuning.sh` | Kernel parameters (CPU, GPU, Memory, Network) |
| `start-services.sh` | Enable TLP, thermald, irqbalance |
| `update_profile.sh` | Environment variables (idempotent) |
| `clean-system.sh` | Remove bloatware (LibreOffice, Firefox) |

## What's Optimized

### CPU (i5-1135G7 - 8 threads)
- TLP: performance (AC) / powersave (battery)
- Turbo Boost: enabled on AC
- Multi-threading: OMP_NUM_THREADS=8, MAKEFLAGS=-j8

### GPU (Intel Iris Xe)
- VAAPI: iHD driver
- Vulkan: async mode
- Gallium: iris driver
- Frame buffer compression + PSR

### Memory (8GB)
- Swappiness: 5
- ZRAM: 7.48GB active
- THP: always
- Node.js heap: 4GB

### Storage (256GB NVMe)
- Scheduler: mq-deadline
- IO timeout: extended

### Network (Wi-Fi 6 AX201)
- TCP BBR + fq_codel
- Buffer sizes: 128MB

## Installed Packages

### System
- thermald, tlp, irqbalance, preload
- nvme-cli, psensor, ethtool

### Virtualization
- qemu-kvm, libvirt, virt-manager
- docker, podman

### Content Creation
- DaVinci Resolve (Flatpak), OBS Studio, FFmpeg
- Blender, GIMP, Audacity

### Gaming
- Steam (Flatpak), Lutris (Flatpak)
- DXVK async, PROTON_NO_ESYNC=0

### Development
- build-essential, clang, cmake, ninja
- Rust (native), Go, Node.js

## Post-Install

```bash
# Reload environment
source ~/.bashrc

# Check services
systemctl status tlp thermald irqbalance

# Verify GPU acceleration
vainfo

# Check TLP
tlp-stat -s
```

## Notes

- TLP conflicts with tuned → tuned removed
- Environment variables are idempotent (safe to run multiple times)
- DaVinci Resolve requires ~4GB extra space

