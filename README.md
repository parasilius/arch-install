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
- [ ] Add post-installation script (System Backup, KDE Plasma, fonts, and more!)
- [ ] Test the script!

## Resources
- [Arch Wiki]()
- [Modern Arch linux installation guide](https://gist.github.com/mjkstra/96ce7a5689d753e7a6bdd92cdc169bae)
- [Setting Up Arch Linux With BTRFS, Encryption, and Swap](https://www.codyhou.com/arch-encrypt-swap/)
- [Arch Linux Installation Guide (including BTRFS, QTile, ZRAM, disk encryption, timeshift)](https://youtu.be/Qgg5oNDylG8?si=rHSoV8IB-p6cWzaw)
- [Framework Laptop - Arch Linux - Btrfs, encrypted swap and hibernate](https://www.youtube.com/watch?v=BAQ78pBPjjc)