# Windows 11 Network Troubleshooting

## Diagnose First
```cmd
ipconfig /all
ping 8.8.8.8
ping google.com
nslookup google.com
```

| Symptom | Likely Cause | Fix |
|---------|--------------|-----|
| Can ping IPs but not domains | DNS | Steps 1, 4 |
| No connectivity | IP config | Steps 2, 3, 4 |
| Intermittent drops | Adapter | Step 5 |
| "DNS server not responding" | DNS corruption | Steps 1, 4 |

---

## Steps

**1. Flush DNS**
```cmd
ipconfig /flushdns
```

**2. Reset Winsock** ⚠️ Restart required
```cmd
netsh winsock reset
```

**3. Reset TCP/IP** ⚠️ Restart required
```cmd
netsh int ip reset
```

**4. Release & Renew IP**
```cmd
ipconfig /release
ipconfig /renew
```

**5. Reset Network Adapter**
```powershell
Get-NetAdapter | Restart-NetAdapter
```

**6. Clear ARP Cache**
```cmd
netsh interface ip delete arpcache
```

**7. Nuclear Option — Full Network Reset**
Settings → Network & Internet → Advanced → Network Reset

---

## Verify After Fix
```cmd
ping 8.8.8.8
ping google.com
ipconfig /all | findstr "DNS"
Test-NetConnection google.com -Port 443
```

---

## Quick Reference
```cmd
ipconfig /all        # Full network config
ipconfig /flushdns   # Clear DNS cache
ipconfig /release    # Release IP
ipconfig /renew      # Request new IP
netsh winsock reset  # Reset sockets
netsh int ip reset   # Reset TCP/IP
ping [address]       # Test connectivity
nslookup [domain]    # Test DNS
tracert [address]    # Trace route
```

> Always run as Administrator. Restart after steps 2 and 3.
