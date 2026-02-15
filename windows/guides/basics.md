# Preliminary Troubleshooting Checklist

## Basic Checks (Start Here)

- [ ] What network is the user on?
- [ ] Does the user need to be connected to VPN?
- [ ] Does the site work in incognito/private browsing?
- [ ] Is the user's password expired?
- [ ] Is the user's account locked out?
- [ ] Does the user have MFA setup?
- [ ] Are the user's Windows certificates updated with the latest passwords?
- [ ] Can the user access other sites/applications?
- [ ] Try a different browser (Edge, Chrome, Firefox)
- [ ] Clear browser cache and cookies
- [ ] Is the system date/time correct?
- [ ] Are there any error messages? (screenshot or note exact text)
- [ ] Has the device been restarted recently?
- [ ] Is there adequate disk space on C: drive?

---

## Quick Diagnostic Commands

### Check Account Status
```cmd
net user <username> /domain
```

### Check Certificate Status
```cmd
certutil -verifystore MY
```
**If error 0x80096004 or verification fails:**
1. Open Certificate Manager: `certmgr.msc`
2. Check Personal → Certificates for expired/invalid certs (red X or yellow triangle)
3. Delete problematic certificates
4. Refresh certificates:
```cmd
gpupdate /force
certutil -pulse
```
5. Reboot device

**View certificate details:**
```powershell
Get-ChildItem -Path Cert:\CurrentUser\My | Select-Object Subject, Issuer, NotAfter | Format-Table
```

### Check Active User Sessions
```cmd
query user
```
logoff user
```cmd
logoff <session_id>
#or
logoff <username>
```

### Check Disk Space
```powershell
Get-PSDrive C | Select-Object @{Name="UsedGB";Expression={[math]::Round($_.Used/1GB,2)}}, @{Name="FreeGB";Expression={[math]::Round($_.Free/1GB,2)}}
```

### Check Azure AD Status
```cmd
dsregcmd /status
```

---

## Common Issues & Quick Fixes

| Issue | Quick Fix |
|-------|-----------|
| Password expired | User must reset password |
| Account locked | Unlock in Active Directory/Azure AD |
| Certificate outdated | Update stored credentials in Credential Manager |
| Certificate verification failed (0x80096004) | Delete bad cert, run `gpupdate /force` + `certutil -pulse`, reboot |
| VPN not connected | Connect to required VPN profile |
| Browser cache issue | Clear cache or try incognito mode |
| Wrong network | Switch to correct WiFi/network |
| MFA not setup | Enroll in MFA at account portal |
| Uptime >14 days | Reboot device (especially if performance issues) |

---

## When to Use gpupdate /force

**Use `gpupdate /force` when:**
- Just deleted certificates (forces re-enrollment)
- Authentication/access issues
- After password change affecting certificates
- Group Policy not applying correctly

**Use regular `gpupdate` for routine checks**
