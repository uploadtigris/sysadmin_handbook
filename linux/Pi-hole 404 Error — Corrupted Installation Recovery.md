
# Pi-hole 404 Error — Corrupted Installation Recovery

**Date:** 2026-03-01\
**OS:** Raspberry Pi OS (Debian-based)\
**Environment:** Homelab\
**Category:** Networking, Linux, Maintenance

---

## Situation
Attempted routine maintenance on Pi-hole ad blocker. Navigating to the device's IP in a browser returned `Error 404: Not Found`. GUI was inaccessible and device appeared to have a corrupted installation.

## Task
Restore Pi-hole functionality and complete pending system updates.

## Action

**1. Initial Diagnosis**
- Power cycled the device
- Reconnected to IP in browser — GUI loaded and showed pending updates
- SSH'd into the device:
```bash
ssh 192.168.1.x
```

**2. Attempted System Update**
```bash
sudo apt update        # Successful
sudo apt upgrade       # Failed — installation corrupted errors
```

**3. Force Filesystem Check on Reboot**
```bash
sudo touch /forcefsck
sudo reboot
```

**4. Verify Device Back Online**
```bash
arp -a
```

**5. Repair Broken Packages**
```bash
sudo apt --fix-broken install    # Successful
sudo apt upgrade                 # Ran successfully — took longer than expected
```

Note: 7 packages failed to upgrade across multiple attempts — suspected failing Micro SD card

**6. Fresh Pi-hole Installation**
```bash
# Clean up broken packages
sudo dpkg --configure -a
sudo apt-get clean

# Install dependency
sudo apt-get install binutils -y

# Reinstall Pi-hole
curl -sSL https://install.pi-hole.net | bash
```

## Result
Fresh Pi-hole installation resolved the 404 error and restored full functionality. Root cause was a corrupted installation, possibly related to SD card degradation. If the issue recurs, replacing the Micro SD card is the next step.

**Tools used:** `ping` `arp` `ssh` `apt` `dpkg` `curl`

---

**Tags:** `linux` `raspberry-pi` `pi-hole` `networking` `apt` `corrupted-install` `homelab` `maintenance` `ssh`
