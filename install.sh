DRIVE='/dev/nvme0n1'
DRIVE_PASSPHRASE='drivepassword'
ROOT_PASSWORD='rootpassword'
USER_NAME='user'
USER_PASSWORD='userpassword'
TIMEZONE='Iran'
WIRELESS='wlan0'
WIFI_PASSWORD='wifipassword'
WIFI_SSID='wifi'
CPU='intel'

network_config() {
    iwctl
        station "$WIRELESS" scan
        station "$WIRELESS" connect "$WIFI_SSID"
        if [ -z "$WIFI_PASSWORD" ]
        then
            echo 'Enter the WiFi password:'
            stty -echo
            read WIFI_PASSWORD
            stty echo
        fi
        echo "$WIFI_PASSWORD"
}

partition_drive() {
    local dev="$1"; shift

    if [ -z "$DRIVE" ]
    then
        read -p "Enter the target disk (e.g., /dev/sda or /dev/nvme0n1): " DISK
    fi
    if [[ ! -b "$DISK" ]]; then
        echo "Error: $DISK is not a valid block device."
        exit 1
    fi
    echo -e "o\nY\nn\n\n+1G\nef00\nn\n\n\n\nw\nY\n"
}

format_partitions() {
    local boot_dev="$DRIVE"p1
    local btrfs_dev="$DRIVE"p2

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