# Arch Linux Installation
![Arch Linux logo](https://archlinux.org/static/logos/archlinux-logo-light-scalable.svg)

This repository provides both manual and automated installation solutions for Arch Linux:

## 📚 Manual Installation
- Detailed wiki covering the installation process (currently in progress)
- Step-by-step configuration guidance

## ⚙️ Automated Installation
- Installer script  (direct implementation of wiki steps - **untested: use with caution**)
- Post-installation automation script (coming soon)

## ✨ Features
- **Partitioning**:
  - 1GiB FAT32 `/boot` (UEFI System Partition)
  - Remaining space as Btrfs `/` with subvolumes (based on [Arch Wiki's Suggested filesystem layout](https://wiki.archlinux.org/title/Snapper#Suggested_filesystem_layout)):
    - `@` (root)
    - `@home`
    - `@snapshots`
    - `@var_log`
- **Setup**:
  - LUKS encryption
  - Base system installation (kernel + essential packages)
  - Wireless network configuration
  - 2GiB swap file creation
  - GRUB bootloader installation (UEFI/BIOS)
  - User account creation with sudo privileges
  - System snapshot/backup setup
  - KDE Plasma (minimal installation)
  - Security hardening
- **Additional Packages**:
    - Neovim
    - CPU Microcode
    - PipeWire
    - Git
    - Zsh
    - OpenSSH

## ✅ To-Do
- [ ] Add more details to wiki
- [ ] Add Virtual Machine support to script
- [ ] Add post-installation script (System Backup, KDE Plasma, fonts, and more!)
- [ ] Test the script!

## 🔗 Resources
- [Arch Wiki](https://wiki.archlinux.org/title/Main_page)
- [Modern Arch linux installation guide](https://gist.github.com/mjkstra/96ce7a5689d753e7a6bdd92cdc169bae)
- [Setting Up Arch Linux With BTRFS, Encryption, and Swap](https://www.codyhou.com/arch-encrypt-swap/)
- [Arch Linux Installation Guide (including BTRFS, QTile, ZRAM, disk encryption, timeshift)](https://youtu.be/Qgg5oNDylG8?si=rHSoV8IB-p6cWzaw)
- [Framework Laptop - Arch Linux - Btrfs, encrypted swap and hibernate](https://www.youtube.com/watch?v=BAQ78pBPjjc)