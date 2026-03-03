
# WSL Crashes Immediately on Launch After Previous Installation

Date: 2026-03-03\
OS: Windows 11\
Environment: Enterprise (HP EliteBook 845 14 inch G10 Notebook PC)\
Category: Virtualization / WSL

## Situation

WSL had been previously installed on the machine. When attempting to open the WSL application, the terminal window would flash open briefly and then immediately close. No error message was displayed. The machine is domain-joined and managed via Intune.

## Task
Restore WSL functionality and successfully install and access a Linux distribution (AlmaLinux 9).

## Action

```powershell
# Step 1: Verify WSL and Virtual Machine Platform features are enabled via Windows Features GUI
# Control Panel > Programs > Turn Windows features on or off
# Confirmed: "Windows Subsystem for Linux" ✅
# Confirmed: "Virtual Machine Platform" ✅

# Step 2: Re-enable features via DISM to ensure they are properly registered
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Step 3: Check for and apply WSL updates
wsl --update
# Output: "The most recent version of Windows Subsystem for Linux is already installed."

# Step 4: Shut down any lingering WSL processes
wsl --shutdown

# Step 5: Confirm WSL is not running
wsl
# Confirmed: not running / no active distro

# Step 6: List available online distributions
wsl.exe --list --online
# Output: Confirmed list of available distros displayed

# Step 7: Install AlmaLinux 9
wsl.exe --install AlmaLinux-9
```

## Result

After running DISM to re-enable the WSL and Virtual Machine Platform features and performing a clean shutdown of WSL, the install of AlmaLinux 9 completed successfully. The environment is now accessible and functional.

**Lesson learned:** Even when Windows Features shows WSL as enabled, a previous failed or partial install can leave WSL in a broken state. Re-running DISM commands forces the feature registration to be refreshed without requiring a full reinstall of Windows. Running `wsl --shutdown` before reinstalling clears any stuck state.

Tags: wsl windows11 virtualization almalinux dism elitebook enterprise intune
