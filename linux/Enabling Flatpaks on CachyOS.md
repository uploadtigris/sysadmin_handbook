# Enabling Flatpaks on CachyOS

**Date:** 2025-12-01\
**OS:** CachyOS (Arch-based)\
**Environment:** Homelab / Daily Driver\
**Category:** Linux, Package Management

---

## Situation
Flatpak was not installed or configured. Needed to enable Flathub and install applications via Flatpak.

## Action

**1. Install Flatpak**
```bash
sudo pacman -S flatpak
```

**2. Enable Flathub Repository**
```bash
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

**3. Install Applications**

From a downloaded `.flatpakref` file:
```bash
flatpak install ./md.obsidian.Obsidian.flatpakref
```

From Flathub directly:
```bash
flatpak install flathub com.discordapp.Discord
```

**4. Verify Installation**
```bash
flatpak list | grep -i obsidian
```

---

**Tags:** `linux` `cachyos` `arch` `flatpak` `flathub` `package-management`
