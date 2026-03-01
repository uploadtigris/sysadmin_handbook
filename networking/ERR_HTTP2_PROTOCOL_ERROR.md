
# ERR_HTTP2_PROTOCOL_ERROR – Winsock Corruption & Auth Loop

**Date:** 2026-02-15\
**OS:** Windows 11\
**Environment:** Enterprise\
**Category:** Networking, Authentication, Browser

---

## Situation

Multiple workstations at a location were unable to load an internal web application. Symptoms varied across incidents but included:

- Site continuously loading after clicking login (single workstation)
- Gray screen after login across multiple workstations on both Chrome and Edge
- `ERR_HTTP2_PROTOCOL_ERROR` appearing in the browser developer console
- A secondary internal server also loading slowly on affected machines
- External sites and internal SharePoint accessible without issue
- All application servers confirmed reachable; remote analyst able to log in from jump server without issue

---

## Task

Restore access to the internal web application for affected workstations. Determine whether the issue was isolated to individual machines or a broader network/server-side problem.

---

## Action

Performed remote support sessions on affected workstations with elevated credentials.

**Fix 1 – Single-workstation ERR_HTTP2_PROTOCOL_ERROR (Winsock reset):**

```cmd
ipconfig /flushdns         :: Partial improvement — more site content began to load
netsh winsock reset        :: Reset corrupted Winsock catalog
gpupdate                   :: Refreshed group policy
:: Restarted computer after each winsock reset
```

**Fix 2 – Multi-workstation gray screen / auth loop (ASPXAUTH cookie pre-fetch):**

When the browser times out during the cookie/auth phase and the gray screen persists, bypass the browser's auth flow entirely by grabbing the `.ASPXAUTH` session token directly from the ASP.NET server via PowerShell before loading the site. This is less intensive on the server — it avoids the double timeout (auth request → cookie store → reload) that causes the loop.

```powershell
# Create a web session and hit the login endpoint to retrieve the ASPXAUTH token
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$response = Invoke-WebRequest -Uri "https://<app-server>/OfficeClient/" -SessionVariable session -UseDefaultCredentials

# Confirm the ASPXAUTH cookie was collected
$session.Cookies.GetCookies("https://<app-server>/OfficeClient/") | Select-Object Name, Value

# (Optional) Inspect the HTML response to confirm login page loaded server-side
$response.Content | Select-String -Pattern "<input"
```

Once the `.ASPXAUTH` cookie is confirmed in the session, open the site in the browser — the cached auth state allows the page to load without hitting the timeout loop.

> **Why this works:** The application uses ASP.NET Forms Authentication. Under normal conditions, the browser handles the auth handshake and cookie storage, but on degraded machines the request times out before the cookie is stored, causing a loop. Pre-fetching the token via PowerShell seeds the auth state with less overhead, letting the browser pick it up cleanly on the next load.

**Additional steps tried (multi-workstation case):**

- Cleared browser cache and cookies — issue persisted; clearing cache regressed progress in one case
- Rebooted affected computers — issue persisted
- Verified network connectivity (store router, switches, file server, app server all pinging)
- Confirmed all application servers reachable via direct URL checks

---

## Result

- **Single-workstation case:** Access restored after `netsh winsock reset` and restart. Root cause identified as a corrupted Winsock catalog causing the HTTP/2 protocol to malfunction for that specific resource request, producing `ERR_HTTP2_PROTOCOL_ERROR`.
- **Multi-workstation case:** Resolved by pre-fetching the `.ASPXAUTH` session cookie via PowerShell before loading the site in the browser, bypassing the double-timeout auth loop.
- **Key learning:** `ERR_HTTP2_PROTOCOL_ERROR` on a single machine while others are unaffected points to Winsock corruption — `netsh winsock reset` + restart is the fix. For gray screen / auth loop issues across multiple machines, the ASPXAUTH pre-fetch is a lower-overhead workaround that avoids hammering the server during a degraded state. Clearing cache/cookies alone is insufficient and can regress progress.

---

**Tags:** `networking` `windows` `winsock` `http2` `aspnet` `authentication` `browser` `enterprise` `powershell`
