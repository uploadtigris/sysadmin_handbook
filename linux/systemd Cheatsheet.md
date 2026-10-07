# Systemd Cheatsheet

## Service Management
```bash
# Start/stop/restart service
systemctl start service_name
systemctl stop service_name
systemctl restart service_name

# Enable/disable service (autostart)
systemctl enable service_name
systemctl disable service_name

# Check status
systemctl status service_name

# View logs
journalctl -u service_name
journalctl -u service_name -f  # Follow logs
```

## Unit Files
Location: `/etc/systemd/system/`

Basic structure:
```ini
[Unit]
Description=My Service
After=network.target

[Service]
Type=simple
ExecStart=/path/to/executable
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

## Useful Commands
```bash
# Reload systemd after changes
systemctl daemon-reload

# List all services
systemctl list-units --type=service

# List failed services
systemctl --failed
```
