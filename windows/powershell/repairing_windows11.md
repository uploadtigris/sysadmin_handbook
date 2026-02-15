# Windows Application Repair Guide

When applications won't open or crash on launch, use these troubleshooting and repair steps.

---

## Quick Application-Specific Fixes

### Chrome Won't Open or Crashes

**Add experimental flags bypass:**
1. Right-click Chrome shortcut → **Properties**
2. In **Target** field, add to the end (after the quotes):
```
--no-experiments
```
Example:
```
"C:\Program Files\Google\Chrome\Application\chrome.exe" --no-experiments
```
3. Click **Apply** → **OK**
4. Launch Chrome from the modified shortcut

**Other useful Chrome flags:**
```
--disable-gpu                    # If display issues
--disable-extensions             # If extension causing crash
--no-sandbox                     # If sandbox errors
--disable-software-rasterizer    # If rendering issues
```

**Reset Chrome (preserves bookmarks):**
```
chrome://settings/reset
```

---

### Edge Won't Open

**Repair Edge:**
```powershell
# Run in PowerShell as Admin
Get-AppxPackage *edge* | Reset-AppPackage
```

**Or reinstall Edge:**
1. Settings → Apps → Microsoft Edge → **Repair** or **Reset**

---

### Microsoft Store Apps Won't Open

**Reset specific app:**
```powershell
Get-AppxPackage *AppName* | Reset-AppPackage
```

**Reset all apps:**
```powershell
Get-AppxPackage | Reset-AppPackage
```

**Re-register all apps:**
```powershell
Get-AppxPackage -AllUsers | ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
```

---

### Office Applications Won't Open

**Repair Office:**
1. Settings → Apps → Microsoft 365 (or Office) → **Modify**
2. Choose **Online Repair**
3. Follow prompts

**Or via CMD:**
```cmd
"C:\Program Files\Common Files\microsoft shared\ClickToRun\OfficeClickToRun.exe" scenario=Repair platform=x64
```

---

### Generic Application Won't Open

**Try these in order:**

1. **Run as Administrator** - Right-click → Run as administrator
2. **Compatibility Mode** - Right-click → Properties → Compatibility → Try different Windows versions
3. **Repair/Reset** - Settings → Apps → [App Name] → Advanced options → Repair or Reset
4. **Reinstall** - Uninstall completely, reboot, reinstall fresh

---

## System Repair Commands

### Basic System File Repair

**Check and repair system files:**
```cmd
sfc /scannow
```
**Expected time:** 15-30 minutes
**What it does:** Scans and repairs corrupted Windows system files

---

### Advanced Image Repair

**Repair Windows component store:**
```cmd
Dism /online /Cleanup-Image /RestoreHealth
```
**Expected time:** 20-45 minutes
**What it does:** Repairs the Windows image used for system file repairs

**Run DISM first, then SFC:**
```cmd
Dism /online /Cleanup-Image /RestoreHealth
sfc /scannow
```

---

### The Kitchen Sink (Complete System Repair)

**Run all repair commands sequentially:**
```cmd
dism /online /cleanup-image /scanhealth && dism /online /cleanup-image /checkhealth && dism /online /cleanup-image /restorehealth && sfc /scannow && gpupdate /force
```

**What each part does:**
- `/scanhealth` - Check for corruption (quick)
- `/checkhealth` - Verify component store health
- `/restorehealth` - Repair corruption
- `sfc /scannow` - Fix system files
- `gpupdate /force` - Refresh all Group Policies

**Expected time:** 45-90 minutes
**When to use:** When multiple apps won't open, system is unstable, or after malware removal

⚠️ **Requires Administrator CMD** and stable internet connection

---

## Windows Store Repair

**Reset Windows Store:**
```cmd
wsreset.exe
```

**Re-register Store:**
```powershell
Get-AppXPackage *WindowsStore* -AllUsers | ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
```

---

## User Profile Corruption

If apps won't open for ONE user but work for others:

**Check for temporary profile:**
```cmd
whoami
```
If you see `.TEMP` in username, profile is corrupted.

**Create new user profile:**
1. Settings → Accounts → Family & other users → **Add account**
2. Create local account
3. Make administrator
4. Log in as new user
5. Copy files from old profile at `C:\Users\<oldusername>`

---

## .NET Framework Repair

Many apps require .NET Framework:

**Repair .NET Framework:**
1. Download .NET Framework Repair Tool from Microsoft
2. Or reinstall from Windows Features:
```cmd
dism /online /enable-feature /featurename:NetFx3 /all
```

---

## DLL Registration Issues

**Re-register all DLLs (advanced):**
```cmd
for %i in (%windir%\system32\*.dll) do regsvr32.exe /s %i
```
⚠️ This takes a long time and may show some errors (normal)

---

## Windows Update Repair

Corrupted updates can prevent apps from opening:

**Reset Windows Update components:**
```cmd
net stop wuauserv
net stop cryptSvc
net stop bits
net stop msiserver
ren C:\Windows\SoftwareDistribution SoftwareDistribution.old
ren C:\Windows\System32\catroot2 catroot2.old
net start wuauserv
net start cryptSvc
net start bits
net start msiserver
```

---

## Check for Disk Errors

**Scan and repair disk:**
```cmd
chkdsk C: /f /r
```
⚠️ Requires reboot, runs at startup, takes 1-3 hours

---

## Event Viewer Diagnostics

**Check application crash logs:**
1. `eventvwr.msc`
2. Windows Logs → **Application**
3. Look for **Error** level events around the time app failed
4. Note the application name and error code

Common errors:
- **Event ID 1000** - Application crash
- **Event ID 1002** - Application hang

---

## Startup Interference

**Boot into Safe Mode:**
1. Hold **Shift** while clicking Restart
2. Troubleshoot → Advanced Options → Startup Settings → Restart
3. Press **4** for Safe Mode
4. Test if app opens in Safe Mode
5. If yes, likely startup program or driver conflict

**Disable startup programs:**
```cmd
msconfig
```
→ Startup tab → Open Task Manager → Disable non-essential items

---

## Nuclear Option: In-Place Upgrade

If nothing works, perform in-place Windows upgrade (keeps files/apps):

1. Download Windows 11 Media Creation Tool
2. Run and choose **Upgrade this PC now**
3. Keep personal files and apps
4. This reinstalls Windows without wiping data

⚠️ **Last resort** - Back up important data first

- *not an option in many remote image based desktop envrionments*
- instead, you may use Intune Wipe or Support Assist OS Recovery

---

## Quick Decision Tree

```
App won't open?
│
├─ Specific app (Chrome, Edge, Office)?
│  └─ Try app-specific fix above
│
├─ Microsoft Store app?
│  └─ Reset-AppPackage command
│
├─ Multiple apps failing?
│  └─ Run Kitchen Sink repair
│
├─ Only fails for one user?
│  └─ Profile corruption - create new profile
│
├─ Works in Safe Mode?
│  └─ Startup program conflict - disable via msconfig
│
└─ Nothing works?
   └─ In-place upgrade
```

---

## Verification Steps

After repairs, verify:

1. **Reboot the computer** (critical!)
2. Test the application
3. Check Event Viewer for new errors
4. Run `sfc /verifyonly` to confirm system files are healthy:
```cmd
sfc /verifyonly
```

---

## Prevention

**Keep system healthy:**
- Reboot weekly
- Install Windows Updates monthly
- Run `sfc /scannow` quarterly
- Keep disk space above 15% free
- Avoid force shutdowns

---

## Command Quick Reference

```cmd
# System file repair
sfc /scannow

# Image repair
Dism /online /Cleanup-Image /RestoreHealth

# Complete repair sequence
dism /online /cleanup-image /scanhealth && dism /online /cleanup-image /checkhealth && dism /online /cleanup-image /restorehealth && sfc /scannow && gpupdate /force

# Reset Windows Store
wsreset.exe

# Check disk
chkdsk C: /f /r

# Event Viewer
eventvwr.msc

# System Configuration
msconfig

# Check SFC status
sfc /verifyonly
```