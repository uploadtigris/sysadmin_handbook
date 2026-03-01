# Device Not on Domain — Windows Autopilot Hash Enrollment

**Date:** 2026-02-12
**OS:** Windows 11\
**Environment:** Enterprise\
**Category:** Workstation, Enrollment, Identity\

**Device Info:**
- Hostname: `PNWSL-2Z02SY3`
- Serial: `2Z02SY3`
- Model: Dell OptiPlex All-In-One 7410
- Warranty: Ending August 27, 2026

---

## Situation
Device was not joined to the domain. Needed to complete Windows Autopilot hash enrollment so the device could be provisioned through Intune.

## Task
Extract the Autopilot hardware hash and register the device in Intune under Windows Autopilot Devices.

## Action
1. Device was on OOBE screen
2. Attempted `Shift + F3` and `Shift + Fn + F3` to enter audit mode — neither worked
3. Restarted device
4. Used `Ctrl + Shift + F3` — entered Desktop Recovery mode
5. Restarted via `Ctrl + Alt + Del`
6. Device booted to Windows desktop — dismissed Dell Digital Delivery warning
7. Transferred `Autopilot.zip` to local machine via BTSupport
8. Extracted Autopilot hardware hash
9. Ran SysPrep to reset device back to OOBE:
```bash
# Navigated to:
C:\Windows\System32\Sysprep

# Selected options:
# Enter System Out-of-Box Experience (OOBE)
# Reboot → OK
```

10. Device restarted and opened to the Whole Foods Market branded OOBE screen
11. Confirmed hardware hash visible in Intune:
    - Devices → Enrollment → Windows Autopilot Devices → ST: `2Z02SY3`

## Result
Device successfully enrolled in Windows Autopilot. Hash confirmed present in Intune. User will complete first-time MFA sign-in setup via Microsoft Authenticator with a manager present.

---

**KBA:** `KB0018057` — Windows Autopilot Technical Overview  
**Tags:** `windows` `autopilot` `intune` `enrollment` `sysprep` `oobe` `domain` `MFA`
