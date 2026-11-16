# Error in NTP client
Date: 2026-11-16 @ 01:18:43
OS: Debian Trixie - PiHole
Environment: Homelab
Category: Networking

## Situation
What was the problem or alert? What were the symptoms?
- All devices on the network not able to connect to internet sites using hard-wire connection. WiFi connections worked fine. 
- Attempted to reach the PiHole's IP via SSH, Browser URL, via WiFi and Ethernet connection - all failing.
- PiHole's RJ45 port status light are without light, even after reseating the Ethernet cable.

## Task
What needed to be resolved or accomplished?
- Needed devices on network to be successfully resolving internet sites on Ethernet and wifi connections.

## Action
What steps did you take to diagnose and fix it?
- Performed power cycle on Raspberry Pi unit.
- MacOS laptop still not connecting to management VLAN port on network switch using Anker PowerExpand A8380 USB-C hub.
- Was able to reach Pi using the same USB-C hub on my Linux laptop running Ubuntu 26.04.1 LTS
- In PiHole connection > Tools > Pi-hole Diagnosis > "2026-11-16 01:18:43	NTP	Error in NTP client: Cannot resolve NTP server address: Try again"
- Event occured at 1:18AM CST. Event history for DNS events reflects the same time of Total Queries and Client Activity records stopping.
- Updating PiHole with "sudo apt update && sudo apt upgrade"
  
## Result
What was the outcome? What did you learn?
- Reliability of this PiHole device is now into question after 2 previous SD-card corruption events.
- UPS was added to network after 2nd SD-card corruption event, that specific error has not resurfaced.
- Will be on-watch for causes of the NTP error event. Mentioned in the following site is watching for a consistent time of the NTP error. (https://discourse.pi-hole.net/t/error-in-ntp-client-cannot-resolve-ntp-server-address/72036)
