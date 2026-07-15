# Troubleshooting: "Failed to mount UUID=... on real root" (btrfs)

A guide for diagnosing and fixing a Linux system that drops to an emergency
shell with a root-mount failure on a btrfs filesystem.

## The error

```
ERROR: Failed to mount 'UUID=bad68549-9462-4717-aa48-37bc32781a71' on real root
You are now being dropped into an emergency shell.
sh: can't access tty; job control turned off
[rootfs ~]#
```

The `can't access tty` line is a harmless busybox message, ignore it. The
actual problem is the failed mount above it.

## Step 1 — Identify every partition and its real UUID

```sh
blkid
```

Example output:

```
/dev/nvme0n1p1: UUID="3CC0-679F" BLOCK_SIZE="512" TYPE="vfat" PARTUUID="d1b76a57-a256-493c-94d1-985c4199b0a5"
/dev/nvme0n1p2: UUID="bad68549-9462-4717-aa48-37bc32781a71" UUID_SUB="93457905-85d8-44b5-afcd-66552792eb45" BLOCK_SIZE="4096" TYPE="btrfs" PARTLABEL="root" PARTUUID="24f69046-991b-4fb0-ac9c-b1fbcd4c43c4"
```

Field cheat sheet:
- **`UUID`**: the filesystem's own ID. This is what the kernel cmdline and
  `/etc/fstab` reference. This is the one you're matching against the error.
- **`PARTUUID`**: the GPT partition table's ID. A different thing, used by
  different boot configs. Don't confuse it with `UUID`.
- **`UUID_SUB`**: only appears on btrfs. Normal, not a sign of a problem.

**Match the UUID from the error message against the `UUID` field, not
partition size or number.** In the example above, `bad68549-...` on
`/dev/nvme0n1p2` matches the error exactly, so `p2` is confirmed root.

If you don't have an error UUID to match against (e.g. just exploring),
fall back on size/mountpoint conventions: EFI partition is small (~300MB–1GB,
`vfat`, mounted at `/boot/efi`), a separate `/boot` is small (~500MB–2GB,
often ext4), and root is by far the largest partition on the disk.

## Step 2 — Confirm the btrfs module is loaded

```sh
cat /proc/filesystems | grep btrfs
```

Output of `btrfs` confirms it's loaded. If nothing prints, run `modprobe btrfs`.

## Step 3 — Attempt a manual mount to surface the real error

```sh
mkdir -p /mnt/root
mount -t btrfs /dev/nvme0n1p2 /mnt/root
```

- **Mounts clean**: the partition is fine; check subvolumes (Step 5).
- **Fails**: run `dmesg | tail -40` for the actual kernel-level reason
  (bad superblock, I/O error, etc.) instead of relying on the generic
  boot-time message.

## Step 4 — If it fails: try zero-log before anything more invasive

```sh
sudo btrfs rescue zero-log /dev/nvme0n1p2
```

Expected output on success:
```
clearing log on /dev/nvme0n1p2, previous log_root <number>, level 0
```

This clears an inconsistent tree-log, a common result of an unclean
shutdown, without touching your data. It's the safest first repair step.
After it succeeds, repeat Step 3's manual mount to confirm the fix worked.

**Do not** reach for `btrfs check --repair` or `btrfs-convert` before this.
`check --repair` can make things worse if misapplied, and `btrfs-convert` is
for converting an ext2/3/4 filesystem *into* btrfs. It has nothing to do
with this failure and will misleadingly report "No valid Btrfs found" if run
against the wrong or unrelated device.

## Step 5 — Once mounted, confirm subvolumes are intact

```sh
btrfs subvolume list /mnt/root
```

Look for the subvolumes your distro expects (commonly `@` and `@home`). If
they're missing or renamed, that's a separate issue from the log-tree problem
and needs its own fix.

## Common pitfalls

- **Whole-disk vs. partition device**: `/dev/nvme0n1` is the raw disk (a GPT
  table, not a filesystem). Always target the specific partition, e.g.
  `/dev/nvme0n1p2`. Running filesystem tools against the bare disk gives
  misleading "no valid filesystem" errors.
- **Confusing UUID types**: matching `PARTUUID` or `UUID_SUB` instead of
  `UUID` will lead you to "confirm" the wrong partition.
- **Trusting rescue-shell mountpoints as production truth**: what you see
  mounted in a live/emergency shell reflects that session only, not what
  `/etc/fstab` expects on the real system. Always cross-reference against
  `blkid`'s `UUID` field instead.

## Summary flow

```
Boot fails → note the UUID from the error
  → blkid: find matching partition
  → confirm btrfs module loaded
  → manual mount attempt
      → succeeds → check subvolumes → reboot
      → fails → dmesg for real error
              → btrfs rescue zero-log → retry manual mount
              → still fails → btrfs check (read-only) before --repair
```
## Step 3 — Attempt a manual mount to surface the real error

```sh
mkdir -p /mnt/root
mount -t btrfs /dev/nvme0n1p2 /mnt/root
```

- **Mounts clean** → the partition is fine; check subvolumes (Step 5).
- **Fails** → run `dmesg | tail -40` for the actual kernel-level reason
  (bad superblock, I/O error, etc.) instead of relying on the generic
  boot-time message.

## Step 4 — If it fails: try zero-log before anything more invasive

```sh
sudo btrfs rescue zero-log /dev/nvme0n1p2
```

Expected output on success:
```
clearing log on /dev/nvme0n1p2, previous log_root <number>, level 0
```

This clears an inconsistent tree-log — a common result of an unclean
shutdown — without touching your data. It's the safest first repair step.
After it succeeds, repeat Step 3's manual mount to confirm the fix worked.

**Do not** reach for `btrfs check --repair` or `btrfs-convert` before this.
`check --repair` can make things worse if misapplied, and `btrfs-convert` is
for converting an ext2/3/4 filesystem *into* btrfs — it has nothing to do
with this failure and will misleadingly report "No valid Btrfs found" if run
against the wrong or unrelated device.

## Step 5 — Once mounted, confirm subvolumes are intact

```sh
btrfs subvolume list /mnt/root
```

Look for the subvolumes your distro expects (commonly `@` and `@home`). If
they're missing or renamed, that's a separate issue from the log-tree problem
and needs its own fix.

## Common pitfalls

- **Whole-disk vs. partition device**: `/dev/nvme0n1` is the raw disk (a GPT
  table, not a filesystem). Always target the specific partition, e.g.
  `/dev/nvme0n1p2`. Running filesystem tools against the bare disk gives
  misleading "no valid filesystem" errors.
- **Confusing UUID types**: matching `PARTUUID` or `UUID_SUB` instead of
  `UUID` will lead you to "confirm" the wrong partition.
- **Trusting rescue-shell mountpoints as production truth**: what you see
  mounted in a live/emergency shell reflects that session only, not what
  `/etc/fstab` expects on the real system. Always cross-reference against
  `blkid`'s `UUID` field.

## Summary flow

```
Boot fails → note the UUID from the error
  → blkid: find matching partition
  → confirm btrfs module loaded
  → manual mount attempt
      → succeeds → check subvolumes → reboot
      → fails → dmesg for real error
              → btrfs rescue zero-log → retry manual mount
              → still fails → btrfs check (read-only) before --repair
```
