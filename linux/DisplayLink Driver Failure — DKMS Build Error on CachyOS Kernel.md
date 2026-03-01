# DisplayLink Driver Failure — DKMS Build Error on CachyOS Kernel

**Date:** 2026-03-01\
**OS:** CachyOS (Arch-based)\
**Environment:** Homelab / Daily Driver\
**Category:** Hardware, Drivers, Linux

---

## Situation
DisplayLink drivers failed to build on CachyOS kernels. DKMS could not compile the `evdi` module required by DisplayLink because CachyOS does not ship the matching Arch kernel build tree.
```
Error! Bad return status for module build on kernel: 6.17.9-2-cachyos
Error! Bad return status for module build on kernel: 6.12.59-2-cachyos-lts
==> ERROR: Missing 6.17.9-arch1-1 kernel modules tree
```

This is a known limitation on custom-patched kernels such as CachyOS, Xanmod, and Liquorix.

## Task
Get DisplayLink drivers compiling and running on the system.

## Action

**1. Install Vanilla Arch Kernel and Headers**
```bash
sudo pacman -S linux linux-headers
```

**2. Reboot and Select Arch Kernel from Bootloader**

**3. Verify Kernel Changed**
```bash
uname -r
# Expected output: 6.17.9-arch1-1
```

**4. Reinstall DisplayLink Drivers**
```bash
yay -S displaylink evdi-dkms
```

**5. Enable DisplayLink Service on Startup**
```bash
sudo systemctl enable --now displaylink.service
sudo reboot
```

## Result
Installing the vanilla Arch kernel provided the missing build tree required for DKMS to compile `evdi`. DisplayLink drivers installed and enabled successfully.

**Root cause:** CachyOS kernels apply custom patches that remove the standard Arch kernel module build tree, breaking DKMS-dependent drivers like DisplayLink.

**Note:** If CachyOS kernel is selected at boot, DisplayLink will stop working. Always boot into the vanilla Arch kernel when DisplayLink is needed.

---

**Tags:** `linux` `cachyos` `arch` `displaylink` `dkms` `evdi` `kernel` `drivers` `hardware`
