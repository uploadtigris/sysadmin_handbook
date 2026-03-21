# AirPods Pairing Failure on Linux — Bluetooth Mode Mismatch

**Date:** 2026-03-21
**OS:** (your distro here)
**Environment:** Homelab / Personal Workstation
**Category:** Bluetooth, Hardware, Service

---

## Situation

AirPods were not appearing or pairing successfully via the Linux Bluetooth menu despite the adapter being active and other devices working normally.

## Task

Get AirPods discoverable and paired to the Linux machine without additional hardware.

## Action

The default `ControllerMode = dual` in the Bluetooth config causes compatibility issues with AirPods, which expect a classic BR/EDR connection rather than dual-mode. Switched the controller mode value to `bredr` and restarted the service.

> **Note:** The line was already uncommented. Only the value was changed from `dual` to `bredr`.

```bash
sudo nano /etc/bluetooth/main.conf
# Find: ControllerMode = dual
# Change to: ControllerMode = bredr

sudo systemctl restart bluetooth
```

Then opened the Bluetooth menu, clicked `+`, opened the AirPods case, and double-tapped the status light on the back of the case to enter pairing mode.

## Result

AirPods appeared in the Bluetooth device list and paired successfully. Root cause was the controller operating in dual mode, which AirPods don't handle gracefully on Linux. Switching to `bredr` forces classic Bluetooth, which AirPods expect.

---

**Tags:** `bluetooth` `hardware` `audio` `systemd` `config`
