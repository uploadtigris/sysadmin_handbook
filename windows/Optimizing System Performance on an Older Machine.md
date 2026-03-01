# Optimizing System Performance on an Older Machine

**Date:** 2026-02-13\
**OS:** Windows 11\
**Environment:** Enterprise\
**Category:** Workstation, Performance\
**Device:** Dell Latitude 5410 w/ 8GB RAM

---

## Situation
Older laptop being repurposed as a primary work machine. Device needed performance optimization to run smoothly on aging hardware.

## Task
Maximize system performance using built-in Windows settings and lightweight configuration changes.

## Action

**1. Visual Effects — Optimize for Performance**
```cmd
sysdm.cpl
```
Advanced → Performance → Settings → "Adjust for best performance"  
Exception: Re-enable **Smooth edges of screen fonts** for readability

**2. Disable Unnecessary Startup Apps**
```cmd
# Task Manager → Startup Apps
# Disable anything not needed at login
taskmgr
```

**3. Set Power Mode to Performance**
Settings → System → Power & Battery → Power Mode → **Best Performance**

**4. Refresh Group Policy**
```cmd
gpupdate /force
```

**5. Set Default Browser Homepage to Work Portal**
- Set `https://myapps.microsoft.com/` to open on Edge launch
- Edge → Settings → On Startup → Open a specific page

**6. Additional Performance Tips**

Disable Search Indexing on older drives:
```cmd
services.msc
# Windows Search → Startup Type → Disabled
```

Disable Transparency Effects:
- Settings → Personalization → Colors → Transparency Effects → Off

Check for high CPU processes:
```cmd
taskmgr
# Sort by CPU — identify and disable unnecessary background processes
```

Disable Hibernation to free disk space:
```cmd
powercfg /hibernate off
```

Clear temp files:
```cmd
cleanmgr
```

Check drive health:
```cmd
wmic diskdrive get status
```

## Result
Device configured for optimal performance on aging hardware. Startup time and general responsiveness improved through visual effect reduction, startup management, and power mode adjustment. Machine successfully provisioned for daily use.

---

**Tags:** `windows` `performance` `optimization` `startup` `power-settings` `sysdm.cpl` `older-hardware`
