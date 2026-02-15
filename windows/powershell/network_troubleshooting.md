
# Windows 11 Network Troubleshooting Guide

## Quick Diagnostic Commands

Before troubleshooting, gather baseline information:

```cmd
ipconfig /all
ping 8.8.8.8
ping google.com
nslookup google.com
```
## Common Issues & Solutions

| Symptom | Likely Cause | Recommended Steps |
|---------|--------------|-------------------|
| Can ping IPs but not domains | DNS issue | Steps 1, 4 |
| No connectivity at all | IP configuration | Steps 2, 3, 4 |
| Intermittent disconnections | Adapter issue | Step 5 |
| "DNS server not responding" | DNS corruption | Steps 1, 4, try alternate DNS |

---

## Step-by-Step Troubleshooting

### Step 1: Flush DNS Cache
**Purpose:** Clears corrupted or outdated DNS entries

```cmd
ipconfig /flushdns
```

**Expected Result:** "Successfully flushed the DNS Resolver Cache"

---

### Step 2: Reset Winsock Catalog
**Purpose:** Repairs network socket settings that may be corrupted

```cmd
netsh winsock reset
```

**Expected Result:** "Successfully reset the Winsock Catalog. You must restart the computer..."

⚠️ **Restart required after this step**

---

### Step 3: Reset TCP/IP Stack
**Purpose:** Resets IP configuration to default state

```cmd
netsh int ip reset
```

**Expected Result:** "Resetting ... OK!"

⚠️ **Restart required after this step**

---

### Step 4: Release and Renew IP Address
**Purpose:** Obtains new IP configuration from DHCP server

```cmd
ipconfig /release
ipconfig /renew
```

**Note:** You may briefly lose connectivity between these commands

---

### Step 5: Reset Network Adapter
**Purpose:** Disables and re-enables network adapter

**PowerShell (run as Administrator):**
```powershell
Get-NetAdapter | Restart-NetAdapter
```

**Alternative CMD method:**
```cmd
netsh interface set interface "Wi-Fi" disabled
netsh interface set interface "Wi-Fi" enabled
```

*Replace "Wi-Fi" with your adapter name from `ipconfig`*

---

### Step 6: Clear ARP Cache
**Purpose:** Removes potentially incorrect MAC address mappings

```cmd
netsh interface ip delete arpcache
```

---

### Step 7: Reset Network Settings (Nuclear Option)
**Purpose:** Complete network configuration reset

**Settings UI Method:**
1. Open Settings → Network & Internet
2. Scroll to Advanced network settings
3. Click "Network reset"
4. Confirm and restart

**PowerShell Method:**
```powershell
Get-NetAdapter | Reset-NetAdapterAdvancedProperty
```

---

## Verification Commands

After troubleshooting, verify connectivity:

```cmd
# Test basic connectivity
ping 8.8.8.8

# Test DNS resolution
ping google.com

# Check routing table
route print

# Verify DNS servers
ipconfig /all | findstr "DNS"

# Test specific port (PowerShell)
Test-NetConnection google.com -Port 443
```

---

## Additional Diagnostics

### Check Network Adapter Status
```powershell
Get-NetAdapter | Select-Object Name, Status, LinkSpeed
```

### View Active Network Connections
```cmd
netstat -ano
```

### Check for Packet Loss
```cmd
ping -n 50 8.8.8.8
```

### Test with Alternative DNS
```cmd
nslookup google.com 8.8.8.8
nslookup google.com 1.1.1.1
```

---


## Notes

- Always run Command Prompt or PowerShell as **Administrator**
- Document your network configuration before making changes
- Restart your computer after Steps 2, 3, or 8
- If problems persist, check physical connections and router/modem
- Consider updating network adapter drivers via Device Manager

## Quick Command Reference

```cmd
# Must-know troubleshooting commands
ipconfig /all              # View full network config
ipconfig /flushdns         # Clear DNS cache
ipconfig /release          # Release IP address
ipconfig /renew            # Request new IP address
netsh winsock reset        # Reset network sockets
netsh int ip reset         # Reset TCP/IP stack
ping [address]             # Test connectivity
nslookup [domain]          # Test DNS resolution
tracert [address]          # Trace route to destination
pathping [address]         # Combined ping and traceroute
```