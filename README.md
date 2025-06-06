# Arch Linux Installer

**NOTE:** This script is not tested yet!

## Features
- **Partitioning**:
  - 1GiB FAT32 `/boot` (UEFI System Partition)
  - Remaining space as Btrfs `/` with subvolumes (based on [Arch Wiki's Suggested filesystem layout](https://wiki.archlinux.org/title/Snapper#Suggested_filesystem_layout)):
    - `@` (root)
    - `@home`
    - `@snapshots`
    - `@var_log`
- **Automated Setup**:
  - Base system installation
  - Wireless Internet connection
  - 2GiB swap file
  - GRUB bootloader configuration
  - Basic user creation

## To-Do
- [ ] Add support for Virtual Machines
- [ ] Add post-installation script (System Backup and more!)
- [ ] Test the script!