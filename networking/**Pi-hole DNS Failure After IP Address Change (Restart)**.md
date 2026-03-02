Date: 2025-MM-DD\ OS: Raspberry Pi OS (Debian-based)\ Environment: Homelab\ Category: Networking, DNS, Service

---

**Situation**

Pi-hole failed with the following error:

```
Connection error (1.1.1.1#53): failed to send UDP request (Network unreachable)
```

Pi-hole could not reach Cloudflare's upstream DNS server at `1.1.1.1`. After restarting the Raspberry Pi, it had grabbed a new DHCP lease from Google Fiber, causing its IP address to change from the expected static address.

> 📎 _[Insert screenshot of error here]_

---

**Task**

Restore Pi-hole DNS functionality and reassign the Raspberry Pi to its correct static IP address (`192.168.1.131`) to prevent future DHCP conflicts.

---

**Action**

**1. Scan the network to identify the new IP address:**

```bash
sudo nmap -sn 192.168.1.0/24
```

Confirmed the Pi had received a different IP from the DHCP pool.

**2. Verify basic network connectivity:**

```bash
ip addr show
ip route show
ping 192.168.1.1   # ping router
```

Router was reachable — network stack was functional.

**3. Reload Pi-hole DNS:**

```bash
sudo pihole reloaddns
```

Output:

```
[✓] Flushing DNS cache
```

**4. Check Pi-hole service status:**

```bash
pihole status
```

Output:

```
[✓] FTL is listening on port 53
[✓] UDP (IPv4)
[✓] TCP (IPv4)
[✓] UDP (IPv6)
[✓] TCP (IPv6)
[✓] Pi-hole blocking is enabled
```

**5. Review current network connections:**

```bash
nmcli connection show
```

**6. Reassign a static IP via nmcli:**

```bash
sudo nmcli connection modify "Wired connection 2" \
  ipv4.addresses 192.168.1.131/24 \
  ipv4.gateway 192.168.1.1 \
  ipv4.dns "8.8.8.8,8.8.4.4" \
  ipv4.method manual

sudo nmcli connection down "Wired connection 2" && \
  sudo nmcli connection up "Wired connection 2"
```

Output:

```
Connection successfully deactivated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/4)
Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/5)
```

**7. Disable UPnP port forwarding on the router:**

Turned off _"Enable UPnP port forwarding"_ in the router settings to reduce the risk of unwanted dynamic network changes.

---

**Result**

Pi-hole DNS was restored and the Raspberry Pi was locked to static IP `192.168.1.131`. The root cause was the Pi pulling a DHCP lease from Google Fiber on reboot rather than using its previously configured address. Setting a manual IP via `nmcli` resolved the conflict. Disabling UPnP was added as a preventive measure.

**Lesson learned:** Always configure a static IP (or a DHCP reservation on the router) for infrastructure devices like Pi-hole to prevent DNS failures after reboots.

Tags: `linux` `networking` `pihole` `dns` `nmcli` `raspberry-pi` `dhcp` `homelab`