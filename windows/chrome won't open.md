# Chrome Fails to Launch — Blank Screen / Long Load Time

**Date:** 2026-01-29  
**OS:** Windows 11  
**Environment:** Enterprise  
**Category:** Software, Workstation  

---

## Situation
Team member reported Chrome would not start. Issue was intermittent. BTSupport RDP file sent via email link was also failing to open. Elevation with `adm.t2` credentials initially failed with an "already running" error.

## Task
Restore Chrome functionality on the affected workstation.

## Action
1. RDP file not opening — had user open the support website in Edge instead
2. Elevation with `adm.t2` failed — "already running" error
3. Ran `gpupdate` to refresh group policy:
```bash
gpupdate /force
```

4. Elevation prompted user to accept — succeeded after gpupdate
5. Chrome opened successfully after elevation
6. User noted issue is intermittent — decided to reinstall Chrome with `adm.t2` credentials
7. Error reappeared after reinstall
8. Opened Task Manager → End Task on all Chrome processes → relaunched — same issue
9. Chrome eventually loaded after 4 minutes — Edge loaded in 1 second by comparison
10. Found Reddit thread suggesting adding `--no-experiments` flag to Chrome shortcut target field:
    - Right-click Chrome shortcut → Properties
    - Target field: `"C:\Program Files\Google\Chrome\Application\chrome.exe" --no-experiments`
11. Chrome launched immediately — issue resolved

## Result
The `--no-experiments` flag disabled experimental Chrome features that were causing the blank screen and long load times. Reinstalling Chrome alone did not fix the issue. Group policy refresh was necessary to allow elevation. User restored to full functionality.

---

**Reference:** [Reddit — Chrome blank screen fix](https://www.reddit.com/r/chrome/comments/1mou3yz/for_anyone_having_blank_screen_issues/)  
**KBAs:** `KB0010399` `KB0019299`  
**Tags:** `windows` `chrome` `elevation` `gpupdate` `workstation` `--no-experiments`
