# Disk Space Cleanup

Sometimes the C: drive will become completely full. On Windows 11 systems, here are a few ways to clear up space.

## Check where the storage is taken up
- Storage Settings
- Win + R > `sysdm.cpl` > crtl + shift + enter (open as administrator)
- WinDirStat (may need to download)

## Clearing the Prefetch and Temp files
```powershell
Get-ChildItem c:\Windows\Temp | Remove-Item -Force -Recurse  
Get-ChildItem c:\Windows\Prefetch | Remove-Item -Force -Recurse
```

## Run Disk Cleanup Utility
Launch Disk Cleanup with all options:
```powershell
cleanmgr /sageset:1
cleanmgr /sagerun:1
```

Manual method:

First command opens dialog - check all boxes \
Second command runs cleanup automatically \
Select "Clean up system files" for additional options

## Check the size of user profiles

```powershell
Get-ChildItem C:\Users -Directory | ForEach-Object {
    $size = (Get-ChildItem $_.FullName -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    [PSCustomObject]@{
        UserProfile = $_.Name
        SizeGB = [math]::Round($size / 1GB, 2)
    }
} | Sort-Object SizeGB -Descending | Format-Table
```

## Clear Browser Cache (All Users) 

<b>ASK FOR USER PERMISSION FIRST!!!</b>

Chrome cache:
```powershell
Get-ChildItem "C:\Users\*\AppData\Local\Google\Chrome\User Data\*\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

Get-ChildItem "C:\Users\*\AppData\Local\Google\Chrome\User Data\*\Code Cache\*" -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
```

Edge cache:

```powershell
Get-ChildItem "C:\Users\*\AppData\Local\Microsoft\Edge\User Data\*\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

Get-ChildItem "C:\Users\*\AppData\Local\Microsoft\Edge\User Data\*\Code Cache\*" -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
```
Firefox cache:

```powershell
Get-ChildItem "C:\Users\*\AppData\Local\Mozilla\Firefox\Profiles\*\cache2\*" -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
```

