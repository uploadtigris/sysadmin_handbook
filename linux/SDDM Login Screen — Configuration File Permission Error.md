# SDDM Login Screen — Configuration File Permission Error

**Date:** 2025-09-01\
**OS:** CachyOS (Arch-based)\
**Environment:** Homelab / Daily Driver\
**Category:** Linux, Display Manager, Permissions

---

## Situation
SDDM login screen was not displaying correctly. Needed to reset SDDM to default settings. Running the fix commands returned a permission error on the SDDM greeter config file.
```
configuration file "/var/lib/sddm/.config/sddm-greeter/qt6rc" not writable
```

## Task
Restore SDDM to default graphical login behavior and resolve the config file permission issue.

## Action

**1. Re-enable SDDM and Set Default Graphical Target**
```bash
sudo systemctl enable sddm --force
sudo systemctl set-default graphical.target
```

**2. Check Directory Ownership and Permissions**
```bash
ls -ld /var/lib/sddm
ls -ld /var/lib/sddm/.config
ls -ld /var/lib/sddm/.config/sddm-greeter
```

**3. Create Config File as SDDM User**
```bash
sudo -u sddm touch /var/lib/sddm/.config/sddm-greeter/qt6rc
```

**4. Restart SDDM**
```bash
sudo systemctl restart sddm
```

## Result
Creating the `qt6rc` file with correct ownership resolved the permission error. SDDM restarted successfully and displayed the correct login screen.

**Root cause:** The greeter config file either did not exist or was owned by the wrong user, preventing SDDM from writing to it.

---

**Tags:** `linux` `cachyos` `sddm` `permissions` `display-manager` `systemd` `arch`
