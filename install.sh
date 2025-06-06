#!/bin/bash

source config.env || { echo "Error: config.env not found"; exit 1; }

run() {
    local boot_dev="$DRIVE"p1
    local btrfs_dev="$DRIVE"p2

    echo 'Configuring network...'
    network_config

    echo 'Partitioning drive...'
    partition_drive

    echo 'Formatting partitions...'
    format_partitions

    echo 'Creating swap file...'
    create_swap

    echo 'Installing packages...'
    install_packages

    echo 'Configuring the system...'
    configure_system
}

network_config() {
    iwctl station "$WIRELESS" scan
    iwctl --passphrase="$WIFI_PASSWORD" station "$WIRELESS" connect "$WIFI_SSID"
}

partition_drive() {
    if [[ ! -b "$DRIVE" ]]; then
        echo "Error: $DRIVE is not a valid block device."
        return 1
    fi
    wipefs --all "$DRIVE"
    printf -e 'o\nY\nn\n\n+1G\nef00\nn\n\n\n\nw\nY\n' | gdisk "$DRIVE"
}

format_partitions() {
    if ! lsmod | grep "dm_crypt" &>/dev/null; then
        modprobe dm_crypt
    fi

    cryptsetup -v luksFormat "$btrfs_dev"
    cryptsetup open "$btrfs_dev" main
    mkfs.btrfs /dev/mapper/main
    mkfs.fat -F 32 "$boot_dev"
    mount /dev/mapper/main /mnt
    btrfs subvolume create /mnt/@
    btrfs subvolume create /mnt/@home
    btrfs subvolume create /mnt/@snapshots
    btrfs subvolume create /mnt/@var_log
    btrfs subvolume create /mnt/@swap
    umount /mnt
    # cryptsetup close main
    # cryptsetup open "$btrfs_dev" main
    mount -o noatime,compress=zstd,space_cache=v2,subvol=@ /dev/mapper/main /mnt
    mount -o noatime,compress=zstd,space_cache=v2,subvol=@home --mkdir /dev/mapper/main /mnt/home
    mount -o noatime,compress=zstd,space_cache=v2,subvol=@snapshots --mkdir /dev/mapper/main /mnt/.snapshots
    mount -o noatime,compress=zstd,space_cache=v2,subvol=@var_log --mkdir /dev/mapper/main /mnt/var/log
    mount --mkdir "$boot_dev" /mnt/boot
    mount -o noatime,subvol=@swap --mkdir /dev/mapper/main /mnt/swap
}

create_swap() {
    btrfs filesystem mkswapfile --uuid clear /mnt/swap/swapfile
    swapon /mnt/swap/swapfile
}

install_packages() {
    reflector --latest 10 --download-timeout 60 --sort rate --save /etc/pacman.d/mirrorlist
    pacstrap -K /mnt base linux linux-firmware neovim networkmanager "$CPU"-ucode zsh sudo git openssh
}

configure_system() {
    genfstab -U /mnt >> /mnt/etc/fstab
    arch-chroot /mnt
    ln -sf /usr/share/zoneinfo/Iran /etc/localtime
    hwclock --systohc
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
    locale-gen
    echo "LANG=en_US.UTF-8" >> /etc/locale.conf
    echo "$HOSTNAME" >> /etc/hostname
    echo "127.0.1.1 $HOSTNAME" >> /etc/hosts
    echo -en "$ROOT_PASSWORD\n$ROOT_PASSWORD" | passwd
    useradd -mG wheel "$USER_NAME"
    echo -en "$password\n$password" | passwd "$USER_NAME"
    sed -i 's/^MODULES=()/MODULES=(btrfs)/' /etc/mkinitcpio.conf
    sed -i '/^HOOKS=/ {
        s/\<filesystems\>/encrypt &/
    }' /etc/mkinitcpio.conf
    mkinitcpio -P
    pacman -S grub efibootmgr
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
    btrfs_uuid=$(blkid "$btrfs_dev" -o value -s UUID)
    sed -i "/^GRUB_CMDLINE_LINUX_DEFAULT=/ {
        s/\"$/ root=\/dev\/mapper\/main cryptdevice=UUID=${btrfs_uuid}:main\"/
    }" /etc/default/grub
    grub-mkconfig -o /boot/grub/grub.cfg
    systemctl enable NetworkManager.service
    swapoff /swap/swapfile
    exit
    umount -R /mnt
    reboot
}

run