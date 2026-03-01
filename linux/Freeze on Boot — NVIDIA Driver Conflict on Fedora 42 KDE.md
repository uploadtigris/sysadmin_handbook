# Freeze on Boot — NVIDIA Driver Conflict on Fedora 42 KDE

**Date:** 2025-07-16\
**OS:** Fedora 42 KDE Plasma\
**Environment:** Lenovo Yoga 9 / Daily Driver\
**Category:** Linux, Drivers, Boot

---

## Situation
Fresh Fedora 42 KDE Plasma installation froze on the logo screen with the spinner locked in place. Nothing happened after 10+ minutes. Adding `nomodeset` to GRUB boot parameters resulted in a black screen. Root cause was an NVIDIA driver conflict preventing the GUI from loading.

## Action

**1. Boot from Fedora Live USB and Mount Installed System**
```bash
sudo mkdir /mnt/system
sudo mount -t btrfs -o subvol=root /dev/nvme0n1p3 /mnt/system

sudo mkdir -p /mnt/system/dev
sudo mkdir -p /mnt/system/proc
sudo mkdir -p /mnt/system/sys

sudo mount --bind /dev /mnt/system/dev
sudo mount --bind /proc /mnt/system/proc
sudo mount --bind /sys /mnt/system/sys
```

**2. Chroot into Installed System**
```bash
sudo chroot /mnt/system
```

**3. Remove NVIDIA Drivers and Regenerate Boot Image**
```bash
dnf remove -y nvidia-driver nvidia-driver-libs akmod-nvidia
dracut --force --regenerate-all
systemctl set-default multi-user.target
exit
sudo reboot
```

**4. Recover Forgotten Username via Emergency Mode**
- Held `Esc` during boot → pressed `e` on Fedora entry
- Added `systemd.unit=emergency.target` to the line starting with `linux`
- Booted with `Ctrl+X`
```bash
cat /etc/passwd | grep 1000
# Grab username from output
```

**5. Update System**
```bash
sudo dnf update    # ~2GB of updates
```

**6. Reinstall NVIDIA Drivers via RPM Fusion**
```bash
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda
```

**7. Build Drivers and Regenerate Boot Image**
```bash
sudo akmods --force
sudo dracut --force
sudo reboot
```

**8. Restore Graphical Target**
```bash
sudo systemctl start display-manager
sudo systemctl set-default graphical.target
sudo reboot
```

**9. Verify NVIDIA Driver Active**
```bash
lspci -k | grep -A 2 -i nvidia
```

## Result
Removing the conflicting NVIDIA drivers, running a full system update, and reinstalling via RPM Fusion resolved the boot freeze. System boots to KDE Plasma GUI successfully.

**Root cause:** NVIDIA driver shipped with Fedora 42 conflicted with the hardware. RPM Fusion drivers resolved the conflict.

---

**Tags:** `linux` `fedora` `nvidia` `boot` `dracut` `akmods` `grub` `chroot` `rpm-fusion` `kde`
