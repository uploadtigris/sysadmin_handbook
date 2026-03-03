# Windows 11 Network Troubleshooting
## Diagnose First
```cmd
ipconfig /all          # Shows full network config (IP, DNS, gateway, MAC)
ping 8.8.8.8           # Tests basic internet connectivity (bypasses DNS)
ping google.com        # Tests DNS resolution + connectivity
nslookup google.com    # Tests DNS specifically, shows which server responds
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
ipconfig /flushdns     # Clears cached DNS entries that may be stale or corrupted
```
**2. Reset Winsock** ⚠️ Restart required
```cmd
netsh winsock reset    # Resets Windows socket API — fixes corruption from malware or bad installs
```
**3. Reset TCP/IP** ⚠️ Restart required
```cmd
netsh int ip reset     # Rewrites core TCP/IP stack registry entries back to default
```
**4. Release & Renew IP**
```cmd
ipconfig /release      # Drops current IP lease from DHCP server
ipconfig /renew        # Requests a fresh IP from DHCP server
```
**5. Reset Network Adapter**
```powershell
Get-NetAdapter | Restart-NetAdapter    # Power cycles all network adapters
```
**6. Clear ARP Cache**
```cmd
netsh interface ip delete arpcache    # Clears cached IP-to-MAC mappings that may be outdated
```
**7. Nuclear Option — Full Network Reset**
Settings → Network & Internet → Advanced → Network Reset
*(Reinstalls all adapters and resets all network components to default)*

---
## Verify After Fix
```cmd
ping 8.8.8.8                              # Confirms basic internet is back
ping google.com                           # Confirms DNS is resolving
ipconfig /all | findstr "DNS"             # Shows which DNS server you're using
Test-NetConnection google.com -Port 443   # Confirms HTTPS traffic is unblocked
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
tracert [address]    # Trace the route to a host, shows each hop
```
> Always run as Administrator. Restart after steps 2 and 3.
