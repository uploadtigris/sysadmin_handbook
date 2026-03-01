# BitLocker Recovery Loop — Post Power Outage

**Date:** 2026-03-01
**OS:** Windows 11
**Environment:** Enterprise
**Category:** Authentication, Storage, Hardware
**Model:** Dell OptiPlex AIO 7410

---

## Situation
Device was stuck in a repeating BitLocker recovery loop. User suspected the issue was triggered by a power outage. Device was also exhibiting hardware instability — keyboard not detected, slow to boot, and returning to the BitLocker screen after entering the recovery key.

## Task
Recover access to the device and resolve the underlying cause of the BitLocker loop.

## Action

**1. Retrieve BitLocker Recovery Key**
- Activated BitLocker Key Reader role in Azure via admin credentials
- Obtained recovery ID from user
- Relayed recovery key to user over the phone

**2. Attempted Recovery — Unsuccessful**
- Entered recovery key → Continue → Automatic Repair → returned to BitLocker screen
- Had user hold power button for 30 seconds to force shutdown
- Device powered on slowly — lights flickered then powered off

**3. Hardware Isolation**
- Unplugged all peripherals except power cable
- Powered on — keyboard not detected error appeared
- User changed USB port for keyboard — was then able to enter BIOS via F2

**4. BIOS Configuration Fix**
- Found RAID enabled in BIOS
- Switched storage controller from RAID → AHCI/NVMe
- Saved and exited BIOS

**5. Login and Remediation**
- Device booted to administrator login
- After a few minutes device allowed login
- Opened admin PowerShell and disabled auto admin logon:
```powershell
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoAdminLogon" -Value 0
```

## Result
Switching the storage controller from RAID to AHCI/NVMe resolved the BitLocker loop. Power outage likely caused a BIOS setting corruption that triggered the repeated recovery screen. Disabling AutoAdminLogon restored normal login behavior. User restored to full functionality.

---

**KBA:** `KB0013391` — Retrieving BitLocker Recovery Drive Passwords  
**Tags:** `windows` `bitlocker` `bios` `RAID` `AHCI` `power-outage` `recovery` `authentication`
