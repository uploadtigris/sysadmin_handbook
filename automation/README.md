# Automation

## Bash Scripts
- **system-health-check.sh** - Reports CPU, memory, disk, and service status
- **user-provisioning.sh** - Bulk-creates users and groups from a CSV file
- **backup-rotate.sh** - Rsync-based backups with automatic rotation

## Python Scripts
- **ssh-bruteforce-detector.py** - Detects repeated SSH failures and blocks offending IPs
- **system-inventory.py** - Collects system info across multiple hosts via SSH
- **port-scanner.py** - Simple TCP port scanner with CIDR range support

## Ansible Playbooks
- **system-hardening.yml** - Applies baseline security hardening to fresh Linux hosts
- **user-management.yml** - Manages users, SSH keys, and sudo access across a fleet
- **package-updates.yml** - Updates packages fleet-wide and flags hosts needing a reboot
