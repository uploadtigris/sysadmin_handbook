# Windows Network Printer Failure — Error 0x00000002

**Date:** 2026-03-01\
**OS:** Windows 11\
**Environment:** Enterprise\
**Category:** Hardware, Networking

---

## Situation
Team member unable to print to network printer. Other users on different machines could print successfully. Printer showed as ready in print services with TCP/IP port configured correctly.

## Task
Restore printing capability for the affected user without disrupting other users or the printer itself.

## Action
1. Verified printer status showed ready in print services
2. Confirmed port was set to TCP/IP
3. Attempted to connect via print server `\\spplv-fs1` — received error `0x00000002`
4. Attempted direct connection via printer IP — timed out
5. Sent test page directly to printer — printed successfully, confirming printer itself was functional
6. Restarted local print spooler:
```bash
# Win+R → services.msc → Ctrl+Shift+Enter (open as admin)
# Right-click Print Spooler → Restart
```

7. Right-clicked network printer → Connect — initially no response, eventually printer was added
8. Test print successful — all queued test prints printed

## Result
Restarting the local print spooler cleared the connection issue. The problem was isolated to the spooler on the affected machine rather than the printer or print server. User restored to full functionality.

---

**Tags:** `windows` `printing` `print-spooler` `networking` `error-0x00000002`
