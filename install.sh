DRIVE='/dev/nvme0n1'
DRIVE_PASSPHRASE='drivepassword'
ROOT_PASSWORD='rootpassword'
USER_NAME='user'
USER_PASSWORD='userpassword'
TIMEZONE='Iran'
WIRELESS='wlan0'
WIFI_PASSWORD='wifipassword'
WIFI_SSID='wifi'

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