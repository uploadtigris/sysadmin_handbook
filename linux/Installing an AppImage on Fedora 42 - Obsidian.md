# Installing an AppImage on Fedora 42 — Obsidian

**Date:** 2025-07-29\
**OS:** Fedora 42 KDE Plasma\
**Environment:** Daily Driver\
**Category:** Linux, Package Management, AppImage

---

## Situation
Obsidian was not available in the Fedora software store. Downloaded the AppImage directly from the Obsidian website. Running it directly from the download location produced repeating GPU errors and the app failed to launch properly.
```
ERROR:gl_surface_presentation_helper.cc(260)] GetVSyncParametersIfAvailable() failed for 1 times!
ERROR:gl_surface_presentation_helper.cc(260)] GetVSyncParametersIfAvailable() failed for 2 times!
```

## Task
Install the AppImage in a standard location, integrate it with the desktop environment, and make it launchable from both the terminal and applications menu.

## Action

**1. Move AppImage to Standard Location**
```bash
sudo mv Obsidian-1.8.10.appimage /opt/obsidian.appimage
```

**2. Extract and Install Icon**
```bash
mkdir -p ~/.local/share/icons

cd /tmp
/opt/obsidian.appimage --appimage-extract >/dev/null 2>&1
cp squashfs-root/usr/share/icons/hicolor/512x512/apps/obsidian.png ~/.local/share/icons/obsidian.png
rm -rf squashfs-root
cd ~
```

**3. Create Desktop Entry**
```bash
cat > ~/.local/share/applications/obsidian.desktop << EOF
[Desktop Entry]
Name=Obsidian
Exec=/opt/obsidian.appimage
Icon=obsidian
Type=Application
Categories=Office;TextEditor;
Comment=A powerful knowledge base on top of a local folder of plain text Markdown files
EOF
```

**4. Update Desktop Database**
```bash
update-desktop-database ~/.local/share/applications/
```

**5. Add Terminal Alias**
```bash
echo "alias obsidian='/opt/obsidian.appimage'" >> ~/.bashrc
source ~/.bashrc
```

## Result
Obsidian installed successfully. App appears in the KDE applications menu, can be pinned to the taskbar, and is launchable from the terminal via `obsidian` alias.

**Note:** This same workflow applies to any AppImage that is not available in the software store — move to `/opt`, create a desktop entry, extract the icon, and optionally add a bash alias.

---

**Tags:** `linux` `fedora` `appimage` `obsidian` `desktop-entry` `bashrc` `package-management`
